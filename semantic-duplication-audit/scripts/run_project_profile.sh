#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  run_project_profile.sh --project-root PATH --profile NAME [options]

Options:
  --project-root PATH         Git repository root (required)
  --profile NAME             Existing .slopo profile (required)
  --slopo-version VERSION    Slopo version (default: 0.5.1)
  --skip-loose               Do not generate the loose report
  --allow-remote-provider    Allow a non-Ollama model after explicit approval
  -h, --help                 Show this help
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command is missing: $1"
}

project_root=''
profile=''
slopo_version='0.5.1'
skip_loose='false'
allow_remote_provider='false'

while (($# > 0)); do
  case "$1" in
    --project-root) (($# >= 2)) || fail '--project-root requires a value'; project_root=$2; shift 2 ;;
    --profile) (($# >= 2)) || fail '--profile requires a value'; profile=$2; shift 2 ;;
    --slopo-version) (($# >= 2)) || fail '--slopo-version requires a value'; slopo_version=$2; shift 2 ;;
    --skip-loose) skip_loose='true'; shift ;;
    --allow-remote-provider) allow_remote_provider='true'; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
done

[[ -n "$project_root" ]] || fail '--project-root is required'
[[ -n "$profile" ]] || fail '--profile is required'
[[ "$profile" =~ ^[a-z0-9][a-z0-9_-]*$ ]] || fail 'profile must use lowercase letters, digits, - or _'
[[ -d "$project_root" ]] || fail "project root does not exist: $project_root"

project_root=$(cd "$project_root" && pwd -P)
git_root=$(git -C "$project_root" rev-parse --show-toplevel 2>/dev/null || true)
[[ "$git_root" == "$project_root" ]] || fail '--project-root must be the Git repository root'

main_config=$project_root/.slopo/$profile.yaml
loose_config=$project_root/.slopo/$profile-loose.yaml
local_directory=$project_root/.slopo/local
[[ -f "$main_config" ]] || fail "main profile does not exist: $main_config"
if [[ "$skip_loose" != 'true' ]]; then
  [[ -f "$loose_config" ]] || fail "loose profile does not exist: $loose_config"
fi

require_command uvx
require_command curl
require_command git

embedding_model=$(awk -F': ' '$1 == "embedding_model" { value=$2; gsub(/^"|"$/, "", value); print value; exit }' "$main_config")
[[ -n "$embedding_model" ]] || fail 'embedding_model is missing from the main profile'

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
mkdir -p "$local_directory"

{
  printf 'started_utc=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  printf 'profile=%s\n' "$profile"
  printf 'git_revision=%s\n' "$(git -C "$project_root" rev-parse HEAD)"
  printf 'git_branch=%s\n' "$(git -C "$project_root" branch --show-current)"
  printf 'slopo_version=%s\n' "$slopo_version"
  printf 'embedding_model=%s\n' "$embedding_model"
  printf '\n[git_status_short]\n'
  git -C "$project_root" status --short
  if [[ "$embedding_model" == ollama/* ]]; then
    printf '\n[ollama_model]\n'
    ollama list | awk -v wanted="${embedding_model#ollama/}" 'NR == 1 || $1 == wanted || $1 == wanted ":latest"'
  fi
} >"$local_directory/$profile-last-run.txt"

slopo=(uvx --from "slopo==$slopo_version" slopo)
cd "$project_root"

"${slopo[@]}" --config ".slopo/$profile.yaml" show-config >".slopo/local/$profile-show-config.txt"
"${slopo[@]}" --config ".slopo/$profile.yaml" index
"${slopo[@]}" --config ".slopo/$profile.yaml" embed
"${slopo[@]}" --config ".slopo/$profile.yaml" analyze | tee ".slopo/local/$profile-analyze-main.txt"
if [[ ! -s ".slopo/local/$profile-report/index.md" ]]; then
  if grep -Fq 'No similar pairs found.' ".slopo/local/$profile-analyze-main.txt"; then
    mkdir -p ".slopo/local/$profile-report"
    printf '# Slopo report\n\nNo similar pairs found.\n' >".slopo/local/$profile-report/index.md"
  else
    fail 'main report was not created'
  fi
fi

if [[ "$skip_loose" != 'true' ]]; then
  "${slopo[@]}" --config ".slopo/$profile-loose.yaml" analyze | tee ".slopo/local/$profile-analyze-loose.txt"
  if [[ ! -s ".slopo/local/$profile-report-loose/index.md" ]]; then
    if grep -Fq 'No similar pairs found.' ".slopo/local/$profile-analyze-loose.txt"; then
      mkdir -p ".slopo/local/$profile-report-loose"
      printf '# Slopo report\n\nNo similar pairs found.\n' >".slopo/local/$profile-report-loose/index.md"
    else
      fail 'loose report was not created'
    fi
  fi
fi

printf 'MAIN_REPORT=%s\n' "$project_root/.slopo/local/$profile-report/index.md"
if [[ "$skip_loose" != 'true' ]]; then
  printf 'LOOSE_REPORT=%s\n' "$project_root/.slopo/local/$profile-report-loose/index.md"
fi
