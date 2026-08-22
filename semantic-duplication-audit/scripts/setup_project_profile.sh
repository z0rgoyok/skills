#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  setup_project_profile.sh --project-root PATH --profile NAME --source PATH [options]

Options:
  --project-root PATH           Git repository root (required)
  --profile NAME               Profile name: lowercase letters, digits, - or _
  --source PATH                Source path inside the repository (required)
  --exclude GLOB               Exclusion pattern; may be repeated
  --similarity VALUE           Main similarity threshold (default: 0.92)
  --rerank VALUE               Main rerank threshold (default: 0.94)
  --loose-similarity VALUE     Loose similarity threshold (default: 0.88)
  --loose-rerank VALUE         Loose rerank threshold (default: 0.92)
  --body-node-count INTEGER    Minimum body AST nodes (default: 10)
  --model MODEL                LiteLLM model name
  --dimensions INTEGER         Embedding dimensions (default: 768)
  --replace                    Replace existing YAML profiles; keep ignore hashes
  --no-gitignore               Do not add .slopo/local/ to .gitignore
  -h, --help                   Show this help
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
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

project_root=''
profile=''
source_input=''
similarity='0.92'
rerank='0.94'
loose_similarity='0.88'
loose_rerank='0.92'
body_node_count='10'
embedding_model='ollama/unclemusclez/jina-embeddings-v2-base-code'
embedding_dimensions='768'
replace_existing='false'
update_gitignore='true'
exclude_patterns=()
exclude_count=0

while (($# > 0)); do
  case "$1" in
    --project-root) (($# >= 2)) || fail '--project-root requires a value'; project_root=$2; shift 2 ;;
    --profile) (($# >= 2)) || fail '--profile requires a value'; profile=$2; shift 2 ;;
    --source) (($# >= 2)) || fail '--source requires a value'; source_input=$2; shift 2 ;;
    --exclude) (($# >= 2)) || fail '--exclude requires a value'; exclude_patterns[exclude_count]=$2; exclude_count=$((exclude_count + 1)); shift 2 ;;
    --similarity) (($# >= 2)) || fail '--similarity requires a value'; similarity=$2; shift 2 ;;
    --rerank) (($# >= 2)) || fail '--rerank requires a value'; rerank=$2; shift 2 ;;
    --loose-similarity) (($# >= 2)) || fail '--loose-similarity requires a value'; loose_similarity=$2; shift 2 ;;
    --loose-rerank) (($# >= 2)) || fail '--loose-rerank requires a value'; loose_rerank=$2; shift 2 ;;
    --body-node-count) (($# >= 2)) || fail '--body-node-count requires a value'; body_node_count=$2; shift 2 ;;
    --model) (($# >= 2)) || fail '--model requires a value'; embedding_model=$2; shift 2 ;;
    --dimensions) (($# >= 2)) || fail '--dimensions requires a value'; embedding_dimensions=$2; shift 2 ;;
    --replace) replace_existing='true'; shift ;;
    --no-gitignore) update_gitignore='false'; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
done

[[ -n "$project_root" ]] || fail '--project-root is required'
[[ -n "$profile" ]] || fail '--profile is required'
[[ -n "$source_input" ]] || fail '--source is required'
[[ "$profile" =~ ^[a-z0-9][a-z0-9_-]*$ ]] || fail 'profile must use lowercase letters, digits, - or _'
[[ -d "$project_root" ]] || fail "project root does not exist: $project_root"

project_root=$(cd "$project_root" && pwd -P)
[[ "$project_root" != '/' ]] || fail 'refusing to configure the filesystem root'
git_root=$(git -C "$project_root" rev-parse --show-toplevel 2>/dev/null || true)
[[ "$git_root" == "$project_root" ]] || fail '--project-root must be the Git repository root'

case "$source_input" in
  /*) source_candidate=$source_input ;;
  *) source_candidate=$project_root/$source_input ;;
esac
[[ -d "$source_candidate" ]] || fail "source directory does not exist: $source_candidate"
source_absolute=$(cd "$source_candidate" && pwd -P)
case "$source_absolute" in
  "$project_root") source_relative='.' ;;
  "$project_root"/*) source_relative=${source_absolute#"$project_root"/} ;;
  *) fail 'source directory must be inside the project root' ;;
esac

reject_multiline 'project root' "$project_root"
reject_multiline 'source path' "$source_relative"
reject_multiline 'model' "$embedding_model"
for ((exclude_index = 0; exclude_index < exclude_count; exclude_index++)); do
  pattern=${exclude_patterns[$exclude_index]}
  reject_multiline 'exclude pattern' "$pattern"
done

[[ "$body_node_count" =~ ^[0-9]+$ ]] || fail '--body-node-count must be a non-negative integer'
[[ "$embedding_dimensions" =~ ^[1-9][0-9]*$ ]] || fail '--dimensions must be a positive integer'

profile_directory=$project_root/.slopo
local_directory=$profile_directory/local
main_config=$profile_directory/$profile.yaml
loose_config=$profile_directory/$profile-loose.yaml
ignore_file=$profile_directory/$profile.ignore.txt

if [[ "$replace_existing" != 'true' ]] && { [[ -e "$main_config" ]] || [[ -e "$loose_config" ]]; }; then
  fail "profile already exists; inspect it or use --replace: $profile"
fi

umask 022
mkdir -p "$profile_directory" "$local_directory"

write_config() {
  local destination=$1
  local report_relative=$2
  local similarity_value=$3
  local rerank_value=$4

  {
    printf '# Generated for profile %s; run Slopo from the repository root.\n' "$profile"
    printf 'source_dir: '
    yaml_string "$source_relative"
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
    yaml_string ".slopo/local/$profile.db"
    printf '\nreport_dir: '
    yaml_string "$report_relative"
    printf '\nignore_file: '
    yaml_string ".slopo/$profile.ignore.txt"
    printf '\n\nembedding_model: '
    yaml_string "$embedding_model"
    printf '\nembedding_dimensions: %s\n' "$embedding_dimensions"
    printf '\nsimilarity_threshold: %s\n' "$similarity_value"
    printf 'rerank_threshold: %s\n' "$rerank_value"
    printf 'body_node_count_threshold: %s\n' "$body_node_count"
  } >"$destination"
}

main_temp=$(mktemp "$profile_directory/.${profile}.main.XXXXXX")
loose_temp=$(mktemp "$profile_directory/.${profile}.loose.XXXXXX")
cleanup_temps() {
  rm -f "$main_temp" "$loose_temp"
}
trap cleanup_temps EXIT

write_config "$main_temp" ".slopo/local/$profile-report" "$similarity" "$rerank"
write_config "$loose_temp" ".slopo/local/$profile-report-loose" "$loose_similarity" "$loose_rerank"
mv "$main_temp" "$main_config"
mv "$loose_temp" "$loose_config"
touch "$ignore_file"

if [[ "$update_gitignore" == 'true' ]]; then
  gitignore=$project_root/.gitignore
  if [[ ! -f "$gitignore" ]] || ! grep -Fqx '.slopo/local/' "$gitignore"; then
    printf '\n.slopo/local/\n' >>"$gitignore"
  fi
fi

printf 'PROFILE=%s\n' "$profile"
printf 'MAIN_CONFIG=%s\n' "$main_config"
printf 'LOOSE_CONFIG=%s\n' "$loose_config"
printf 'IGNORE_FILE=%s\n' "$ignore_file"
printf 'LOCAL_DIRECTORY=%s\n' "$local_directory"
