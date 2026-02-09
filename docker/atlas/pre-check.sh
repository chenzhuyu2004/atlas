#!/usr/bin/env bash
# Wrapper for scripts/pre-check.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/scripts/pre-check.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing pre-check script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
