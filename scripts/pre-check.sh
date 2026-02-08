#!/usr/bin/env bash
# ==============================================================================
# ATLAS Build Pre-Check Script / 构建前检查脚本
# ==============================================================================
set -Eeuo pipefail
IFS=$'\n\t'
trap 'echo "[ERROR] ${0}:${LINENO} ${BASH_COMMAND}" >&2; exit 1' ERR
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

# Minimum Docker version / 最低 Docker 版本
MIN_DOCKER="20.10"
MIN_DOCKER_MAJOR=$(echo "$MIN_DOCKER" | cut -d. -f1)
MIN_DOCKER_MINOR=$(echo "$MIN_DOCKER" | cut -d. -f2)

echo "================================"
echo "ATLAS Build Pre-Check / 构建前检查"
echo "================================"
echo

# Check required files / 检查必需文件
echo "检查必需文件..."
REQUIRED_FILES=(
  "Dockerfile"
  "requirements.txt"
  "requirements-llm.txt"
  "requirements-accel.txt"
  "requirements-materials.txt"
  ".dockerignore"
  "build.sh"
  "run.sh"
)

ALL_EXIST=true
for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo -e "${GREEN}✓${NC} $file"
  else
    echo -e "${RED}✗${NC} $file (MISSING)"
    ALL_EXIST=false
  fi
done

echo
echo "检查脚本权限..."
for script in build.sh run.sh tag.sh; do
  if [ -x "$script" ]; then
    echo -e "${GREEN}✓${NC} $script (executable)"
  else
    echo -e "${YELLOW}⚠${NC} $script (not executable, will fix)"
    chmod +x "$script"
  fi
done

echo
echo "检查可选依赖文件..."
for opt_file in requirements-llm.txt requirements-accel.txt requirements-materials.txt; do
  if [ -f "$opt_file" ]; then
    echo -e "${GREEN}✓${NC} $opt_file"
  else
    echo -e "${YELLOW}⚠${NC} $opt_file (missing)"
  fi
done

echo
echo "检查 Docker 可用性..."
if command -v docker &> /dev/null; then
  DOCKER_VERSION=$(docker --version)
  echo -e "${GREEN}✓${NC} Docker installed: $DOCKER_VERSION"
  DOCKER_VER_NUM=$(echo "$DOCKER_VERSION" | sed -E 's/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
  DOCKER_MAJOR=$(echo "$DOCKER_VER_NUM" | cut -d. -f1)
  DOCKER_MINOR=$(echo "$DOCKER_VER_NUM" | cut -d. -f2)
  if [ "$DOCKER_MAJOR" -lt "$MIN_DOCKER_MAJOR" ] || { [ "$DOCKER_MAJOR" -eq "$MIN_DOCKER_MAJOR" ] && [ "$DOCKER_MINOR" -lt "$MIN_DOCKER_MINOR" ]; }; then
    echo -e "${YELLOW}⚠${NC} Docker version < ${MIN_DOCKER} may cause build issues"
  else
    echo -e "${GREEN}✓${NC} Docker version OK (>= ${MIN_DOCKER})"
  fi
else
  echo -e "${RED}✗${NC} Docker not found"
fi

echo
echo "检查系统资源..."
DISK_FREE=$(df "${PROJECT_ROOT}" | tail -1 | awk '{print $4}')
DISK_GB=$((DISK_FREE / 1024 / 1024))
echo "Available disk space: ${DISK_GB} GB"
if [ "$DISK_GB" -gt 25 ]; then
  echo -e "${GREEN}✓${NC} Sufficient disk space"
else
  echo -e "${RED}✗${NC} Insufficient disk space (need 25+ GB)"
fi

# 检查内存
MEM_TOTAL=$(free -g | awk '/^Mem:/{print $2}')
echo "Total memory: ${MEM_TOTAL} GB"
if [ "$MEM_TOTAL" -ge 10 ]; then
  echo -e "${GREEN}✓${NC} Sufficient memory"
  if [ "$MEM_TOTAL" -le 16 ]; then
    echo -e "${YELLOW}⚠${NC} <=16GB RAM: MAX_JOBS=2 will be used"
  fi
else
  echo -e "${RED}✗${NC} Insufficient memory (need 10+ GB)"
fi

echo
echo "================================"
if [ "$ALL_EXIST" = true ]; then
  echo -e "${GREEN}✓ All checks passed${NC}"
  echo "Ready to build: ./build.sh"
  echo "  BUILD_TIER=0 ./build.sh  # 核心版"
  echo "  BUILD_TIER=1 ./build.sh  # +LLM"
else
  echo -e "${RED}✗ Some checks failed${NC}"
fi
echo "================================"
