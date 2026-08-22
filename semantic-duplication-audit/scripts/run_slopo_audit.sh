#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  run_slopo_audit.sh --source PATH [options]

Options:
  --source PATH                 Source directory to analyze (required)
  --exclude GLOB               Exclusion pattern; may be repeated
  --similarity VALUE           Main similarity threshold (default: 0.92)
  --rerank VALUE               Main rerank threshold (default: 0.94)
  --loose-similarity VALUE     Loose similarity threshold (default: 0.88)
  --loose-rerank VALUE         Loose rerank threshold (default: 0.92)
  --body-node-count INTEGER    Minimum body AST nodes (default: 10)
  --slopo-version VERSION      Slopo version (default: 0.5.1)
  --model MODEL                LiteLLM model name
  --dimensions INTEGER         Embedding dimensions (default: 768)
  --skip-loose                 Do not generate the loose report
  --allow-remote-provider      Allow a non-Ollama model after explicit approval
  -h, --help                   Show this help

The script never deletes the analysis directory. It prints ANALYSIS_ROOT on
success and preserves partial artifacts on failure.
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command is missing: $1"
}

reject_multiline() {
  case "$2" in
    *$'\n'*|*$'\r'*) fail "$1 must not contain newlines" ;;
  esac
}

yaml_string() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  printf '"%s"' "$value"
}

source_path=''
similarity='0.92'
rerank='0.94'
loose_similarity='0.88'
loose_rerank='0.92'
body_node_count='10'
slopo_version='0.5.1'
embedding_model='ollama/unclemusclez/jina-embeddings-v2-base-code'
embedding_dimensions='768'
skip_loose='false'
allow_remote_provider='false'
analysis_root=''
exclude_patterns=()
exclude_count=0

while (($# > 0)); do
  case "$1" in
    --source)
      (($# >= 2)) || fail '--source requires a value'
      source_path=$2
      shift 2
      ;;
    --exclude)
      (($# >= 2)) || fail '--exclude requires a value'
      exclude_patterns[exclude_count]=$2
      exclude_count=$((exclude_count + 1))
      shift 2
      ;;
    --similarity)
      (($# >= 2)) || fail '--similarity requires a value'
      similarity=$2
      shift 2
      ;;
    --rerank)
      (($# >= 2)) || fail '--rerank requires a value'
      rerank=$2
      shift 2
      ;;
    --loose-similarity)
      (($# >= 2)) || fail '--loose-similarity requires a value'
      loose_similarity=$2
      shift 2
      ;;
    --loose-rerank)
      (($# >= 2)) || fail '--loose-rerank requires a value'
      loose_rerank=$2
      shift 2
      ;;
    --body-node-count)
      (($# >= 2)) || fail '--body-node-count requires a value'
      body_node_count=$2
      shift 2
      ;;
    --slopo-version)
      (($# >= 2)) || fail '--slopo-version requires a value'
      slopo_version=$2
      shift 2
      ;;
    --model)
      (($# >= 2)) || fail '--model requires a value'
      embedding_model=$2
      shift 2
      ;;
    --dimensions)
      (($# >= 2)) || fail '--dimensions requires a value'
      embedding_dimensions=$2
      shift 2
      ;;
    --skip-loose)
      skip_loose='true'
      shift
      ;;
    --allow-remote-provider)
      allow_remote_provider='true'
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

[[ -n "$source_path" ]] || fail '--source is required'
[[ -d "$source_path" ]] || fail "source directory does not exist: $source_path"

source_path=$(cd "$source_path" && pwd -P)
[[ "$source_path" != '/' ]] || fail 'refusing to analyze the filesystem root'

reject_multiline 'source path' "$source_path"
reject_multiline 'model' "$embedding_model"
reject_multiline 'Slopo version' "$slopo_version"
for ((exclude_index = 0; exclude_index < exclude_count; exclude_index++)); do
  pattern=${exclude_patterns[$exclude_index]}
  reject_multiline 'exclude pattern' "$pattern"
done

[[ "$body_node_count" =~ ^[0-9]+$ ]] || fail '--body-node-count must be a non-negative integer'
[[ "$embedding_dimensions" =~ ^[1-9][0-9]*$ ]] || fail '--dimensions must be a positive integer'

require_command uvx
require_command curl
require_command git

case "$embedding_model" in
  ollama/*)
    require_command ollama
    curl --silent --show-error --fail http://127.0.0.1:11434/api/tags >/dev/null ||
      fail 'Ollama is not reachable at 127.0.0.1:11434; start ollama serve'
    ollama_model=${embedding_model#ollama/}
    ollama show "$ollama_model" >/dev/null 2>&1 ||
      fail "Ollama model is not installed: $ollama_model"
    ;;
  *)
    [[ "$allow_remote_provider" == 'true' ]] ||
      fail 'non-Ollama models require --allow-remote-provider after explicit approval to send source code'
    ;;
esac

uvx --from "slopo==$slopo_version" slopo --version >/dev/null

umask 077
analysis_root=$(mktemp -d "${TMPDIR:-/tmp}/semantic-duplication-audit.XXXXXX")
chmod 700 "$analysis_root"

on_exit() {
  local status=$?
  if ((status != 0)) && [[ -n "$analysis_root" ]]; then
    printf 'Partial analysis preserved at: %s\n' "$analysis_root" >&2
  fi
}
trap on_exit EXIT

write_config() {
  local destination=$1
  local report_directory=$2
  local similarity_value=$3
  local rerank_value=$4

  {
    printf 'source_dir: '
    yaml_string "$source_path"
    printf '\n\n'
    if ((exclude_count == 0)); then
      printf 'source_dir_exclude: []\n'
    else
      printf 'source_dir_exclude:\n'
      for ((exclude_index = 0; exclude_index < exclude_count; exclude_index++)); do
        pattern=${exclude_patterns[$exclude_index]}
        printf '  - '
        yaml_string "$pattern"
        printf '\n'
      done
    fi
    printf '\n'
    printf 'db_file: '
    yaml_string "$analysis_root/slopo.db"
    printf '\nreport_dir: '
    yaml_string "$report_directory"
    printf '\nignore_file: '
    yaml_string "$analysis_root/slopo.ignore.txt"
    printf '\n\nembedding_model: '
    yaml_string "$embedding_model"
    printf '\nembedding_dimensions: %s\n' "$embedding_dimensions"
    printf '\nsimilarity_threshold: %s\n' "$similarity_value"
    printf 'rerank_threshold: %s\n' "$rerank_value"
    printf 'body_node_count_threshold: %s\n' "$body_node_count"
  } >"$destination"
}

write_config "$analysis_root/config.yaml" "$analysis_root/report" "$similarity" "$rerank"
if [[ "$skip_loose" != 'true' ]]; then
  write_config "$analysis_root/config-loose.yaml" "$analysis_root/report-loose" "$loose_similarity" "$loose_rerank"
fi

git_root='not-a-git-worktree'
git_revision='unknown'
git_branch='unknown'
if git_root_value=$(git -C "$source_path" rev-parse --show-toplevel 2>/dev/null); then
  git_root=$git_root_value
  git_revision=$(git -C "$source_path" rev-parse HEAD 2>/dev/null || printf 'unknown')
  git_branch=$(git -C "$source_path" branch --show-current 2>/dev/null || printf 'unknown')
fi

{
  printf 'started_utc=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  printf 'source_dir=%s\n' "$source_path"
  printf 'git_root=%s\n' "$git_root"
  printf 'git_revision=%s\n' "$git_revision"
  printf 'git_branch=%s\n' "$git_branch"
  printf 'slopo_version=%s\n' "$slopo_version"
  printf 'embedding_model=%s\n' "$embedding_model"
  printf 'embedding_dimensions=%s\n' "$embedding_dimensions"
  printf 'main_thresholds=%s/%s\n' "$similarity" "$rerank"
  printf 'loose_thresholds=%s/%s\n' "$loose_similarity" "$loose_rerank"
  printf 'body_node_count_threshold=%s\n' "$body_node_count"
  printf 'exclude_count=%s\n' "$exclude_count"
  for ((exclude_index = 0; exclude_index < exclude_count; exclude_index++)); do
    pattern=${exclude_patterns[$exclude_index]}
    printf 'exclude=%s\n' "$pattern"
  done
  if [[ "$git_root" != 'not-a-git-worktree' ]]; then
    printf '\n[git_status_short]\n'
    git -C "$source_path" status --short
  fi
  if [[ "$embedding_model" == ollama/* ]]; then
    printf '\n[ollama_model]\n'
    ollama list | awk -v wanted="${embedding_model#ollama/}" 'NR == 1 || $1 == wanted || $1 == wanted ":latest"'
  fi
} >"$analysis_root/run-metadata.txt"

slopo=(uvx --from "slopo==$slopo_version" slopo)

"${slopo[@]}" --config "$analysis_root/config.yaml" show-config >"$analysis_root/show-config.txt"
"${slopo[@]}" --config "$analysis_root/config.yaml" index
"${slopo[@]}" --config "$analysis_root/config.yaml" embed
"${slopo[@]}" --config "$analysis_root/config.yaml" analyze | tee "$analysis_root/analyze-main.txt"
if [[ ! -s "$analysis_root/report/index.md" ]]; then
  if grep -Fq 'No similar pairs found.' "$analysis_root/analyze-main.txt"; then
    mkdir -p "$analysis_root/report"
    printf '# Slopo report\n\nNo similar pairs found.\n' >"$analysis_root/report/index.md"
  else
    fail 'main report was not created'
  fi
fi

if [[ "$skip_loose" != 'true' ]]; then
  "${slopo[@]}" --config "$analysis_root/config-loose.yaml" analyze | tee "$analysis_root/analyze-loose.txt"
  if [[ ! -s "$analysis_root/report-loose/index.md" ]]; then
    if grep -Fq 'No similar pairs found.' "$analysis_root/analyze-loose.txt"; then
      mkdir -p "$analysis_root/report-loose"
      printf '# Slopo report\n\nNo similar pairs found.\n' >"$analysis_root/report-loose/index.md"
    else
      fail 'loose report was not created'
    fi
  fi
fi

printf 'ANALYSIS_ROOT=%s\n' "$analysis_root"
