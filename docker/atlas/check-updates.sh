#!/usr/bin/env bash
# Wrapper for scripts/check-updates.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/scripts/check-updates.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing check-updates script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
