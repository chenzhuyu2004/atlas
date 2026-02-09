#!/usr/bin/env bash
# Wrapper for scripts/tag.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/scripts/tag.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing tag script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
