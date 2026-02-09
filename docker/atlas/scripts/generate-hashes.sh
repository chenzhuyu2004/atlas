#!/usr/bin/env bash
# ==============================================================================
# Generate hashed requirements lockfiles / 生成带哈希的锁定依赖
# Requires pip-tools (pip-compile).
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-${PROJECT_ROOT}/requirements-locks}"

if ! command -v pip-compile >/dev/null 2>&1; then
  echo -e "${RED}[ERROR]${NC} pip-compile not found."
  echo "Install with: pip install pip-tools"
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"

FILES=(
  "requirements.txt"
  "requirements-llm.txt"
  "requirements-accel.txt"
  "requirements-materials.txt"
  "requirements-dev.txt"
)

echo -e "${GREEN}[INFO]${NC} Generating hashed lock files in ${OUTPUT_DIR}"
for file in "${FILES[@]}"; do
  src="${PROJECT_ROOT}/${file}"
  if [[ ! -f "${src}" ]]; then
    echo -e "${RED}[ERROR]${NC} Missing ${src}"
    exit 1
  fi
  base="$(basename "${file}" .txt)"
  out="${OUTPUT_DIR}/${base}.lock.txt"
  echo -e "${GREEN}[INFO]${NC} ${file} -> ${out}"
  pip-compile --generate-hashes --allow-unsafe --output-file "${out}" "${src}"
done

echo -e "${GREEN}[INFO]${NC} Done"
