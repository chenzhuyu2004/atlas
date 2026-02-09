#!/usr/bin/env bash
# Wrapper for scripts/build.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/scripts/build.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing build script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
