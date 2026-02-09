#!/usr/bin/env bash
# Wrapper only. All logic lives under docker/atlas/.
# 本脚本仅作转发，所有逻辑请见 docker/atlas/。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${SCRIPT_DIR}/docker/atlas/run.sh"

if [[ ! -x "${TARGET}" ]]; then
  echo "Missing run script: ${TARGET}" >&2
  exit 1
fi

exec "${TARGET}" "$@"
