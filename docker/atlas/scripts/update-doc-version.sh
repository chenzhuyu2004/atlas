#!/usr/bin/env bash
# ==============================================================================
# Update documentation version tags / 更新文档版本标签
# Usage: ./scripts/update-doc-version.sh <old_version> [new_version]
# Example: ./scripts/update-doc-version.sh 0.6 0.7
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${PROJECT_ROOT}/.." && pwd)"

OLD_VERSION="${1:-}"
NEW_VERSION="${2:-$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "")}"

if [[ -z "${OLD_VERSION}" ]]; then
    echo "Usage: $(basename "$0") <old_version> [new_version]"
    echo "Example: $(basename "$0") 0.6 0.7"
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

echo "Updating docs: v${OLD_VERSION} -> v${NEW_VERSION}"

mapfile -t files < <(
    rg -l "v${OLD_VERSION}" \
        "${PROJECT_ROOT}/README.md" \
        "${PROJECT_ROOT}/docs" \
        "${PROJECT_ROOT}/examples" \
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
    sed -i -E "s/v${OLD_VERSION}/v${NEW_VERSION}/g" "${file}"
    echo "Updated: ${file}"
done
