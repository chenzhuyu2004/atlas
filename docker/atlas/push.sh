#!/usr/bin/env bash
# Wrapper for scripts/push.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/scripts/push.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing push script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
