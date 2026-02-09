#!/usr/bin/env bash
# ==============================================================================
# Update documentation version tags / 更新文档版本标签
# Usage: ./scripts/update-doc-version.sh [--dry-run] <old_version> [new_version]
# Example: ./scripts/update-doc-version.sh 0.6 0.7
#          ./scripts/update-doc-version.sh --dry-run 0.6 0.7
# ==============================================================================

set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") [--dry-run] <old_version> [new_version]"
  echo "Example: $(basename "$0") 0.6 0.7"
  echo "         $(basename "$0") --dry-run 0.6 0.7"
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${PROJECT_ROOT}/.." && pwd)"

DRY_RUN=0
args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done

OLD_VERSION="${args[0]:-}"
NEW_VERSION="${args[1]:-$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "")}" 

if [[ -z "${OLD_VERSION}" ]]; then
  usage
  exit 1
fi

if [[ -z "${NEW_VERSION}" ]]; then
  echo "ERROR: Could not read VERSION file"
  exit 1
fi

if [[ "${OLD_VERSION}" == "${NEW_VERSION}" ]]; then
  echo "Nothing to update: old_version == new_version (${NEW_VERSION})"
  exit 0
fi

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "Dry run: v${OLD_VERSION} -> v${NEW_VERSION}"
else
  echo "Updating docs: v${OLD_VERSION} -> v${NEW_VERSION}"
fi

mapfile -t files < <(
  rg -l "v${OLD_VERSION}" \
    "${PROJECT_ROOT}/README.md" \
    "${PROJECT_ROOT}/docs" \
    "${REPO_ROOT}/examples" \
    "${PROJECT_ROOT}/scripts/README.md" \
    "${PROJECT_ROOT}/SECURITY.md" \
    "${PROJECT_ROOT}/.env.example" \
    "${REPO_ROOT}/CHANGELOG.md" \
    "${REPO_ROOT}/SECURITY.md" \
    --glob '*.md' \
    --glob '*.yml' \
    --glob '*.yaml' \
    --glob '*.env' \
    2>/dev/null || true
)

if [[ "${#files[@]}" -eq 0 ]]; then
  echo "No files found containing v${OLD_VERSION}"
  exit 0
fi

for file in "${files[@]}"; do
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "Would update: ${file}"
  else
    sed -i -E "s/v${OLD_VERSION}/v${NEW_VERSION}/g" "${file}"
    echo "Updated: ${file}"
  fi
done
