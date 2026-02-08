#!/usr/bin/env bash
# ==============================================================================
# ATLAS Image Push Script / 镜像推送脚本
# Push images to Docker Hub or private registry
# 推送镜像到 Docker Hub 或私有仓库
# ==============================================================================

set -Eeuo pipefail
IFS=$'\n\t'
trap 'echo "[ERROR] ${0}:${LINENO} ${BASH_COMMAND}" >&2; exit 1' ERR

# Colors / 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration / 配置
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REGISTRY="${REGISTRY:-docker.io}"
NAMESPACE="${NAMESPACE:-}" # e.g., your-username
IMAGE_NAME="${IMAGE_NAME:-atlas}"
VERSION=$(tr -d '\n' < "${PROJECT_ROOT}/VERSION" 2> /dev/null || echo "0.6")

# Usage / 用法
usage() {
  cat << EOF
Usage / 用法: $0 [TAG] [OPTIONS]

Push ATLAS images to registry / 推送 ATLAS 镜像到仓库

Arguments / 参数:
  TAG         Image tag to push (default: all v${VERSION}-* tags)
              要推送的标签 (默认: 所有 v${VERSION}-* 标签)

Options / 选项:
  -r, --registry REGISTRY   Target registry (default: docker.io)
                            目标仓库 (默认: docker.io)
  -n, --namespace NAMESPACE Your Docker Hub username or org
                            你的 Docker Hub 用户名或组织
  --dry-run                 Show actions without pushing
                            仅显示操作，不执行推送
  -h, --help                Show this help / 显示帮助

Examples / 示例:
  # Push all images to Docker Hub
  NAMESPACE=myusername $0

  # Push specific tag
  NAMESPACE=myusername $0 v0.6-base

  # Push to private registry
  REGISTRY=ghcr.io NAMESPACE=myorg $0

EOF
  exit 0
}

# Parse args / 解析参数
require_arg() {
  local opt="$1"
  local val="${2:-}"
  if [[ -z "${val}" ]]; then
    print_error "Option ${opt} requires a value"
    print_error "参数 ${opt} 需要值"
    exit 1
  fi
}

DRY_RUN=0
TAG_FILTER=""
while [[ $# -gt 0 ]]; do
  case $1 in
  -r | --registry)
    require_arg "$1" "${2:-}"
    REGISTRY="$2"
    shift 2
    ;;
  -n | --namespace)
    require_arg "$1" "${2:-}"
    NAMESPACE="$2"
    shift 2
    ;;
  --dry-run)
    DRY_RUN=1
    shift
    ;;
  -h | --help) usage ;;
  *)
    TAG_FILTER="$1"
    shift
    ;;
  esac
done

# Validate / 验证
if [[ -z "$NAMESPACE" ]]; then
  print_error "NAMESPACE is required. Set via -n or NAMESPACE env var"
  print_error "NAMESPACE 必需。通过 -n 参数或 NAMESPACE 环境变量设置"
  exit 1
fi

# Get tags to push / 获取要推送的标签
if [[ -n "${TAG_FILTER}" ]]; then
  TAGS=("$TAG_FILTER")
else
  mapfile -t TAGS < <(docker images atlas --format "{{.Tag}}" | grep "^v${VERSION}" || true)
fi

if [[ ${#TAGS[@]} -eq 0 ]]; then
  print_error "No matching tags found / 未找到匹配的标签"
  exit 1
fi

# Login check / 登录检查
print_info "Checking registry login... / 检查仓库登录..."
if ! docker login "${REGISTRY}" --get-login &> /dev/null; then
  print_warn "Not logged in. Run: docker login ${REGISTRY}"
  print_warn "未登录。请运行: docker login ${REGISTRY}"
  exit 1
fi

# Push / 推送
for tag in "${TAGS[@]}"; do
  local_image="atlas:${tag}"
  remote_image="${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${tag}"

  print_info "Tagging: ${local_image} -> ${remote_image}"
  if [ "$DRY_RUN" -eq 1 ]; then
    print_info "DRY-RUN: docker tag ${local_image} ${remote_image}"
  else
    docker tag "${local_image}" "${remote_image}"
  fi

  print_info "Pushing: ${remote_image}"
  if [ "$DRY_RUN" -eq 1 ]; then
    print_info "DRY-RUN: docker push ${remote_image}"
  else
    docker push "${remote_image}"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    print_info "✓ DRY-RUN complete for ${remote_image}"
  else
    print_info "✓ Pushed ${remote_image}"
  fi
done

print_info "============================================"
if [ "$DRY_RUN" -eq 1 ]; then
  print_info "✓ Dry run complete!"
else
  print_info "✓ All images pushed successfully!"
fi
print_info "============================================"
