#!/usr/bin/env bash
# ==============================================================================
# ATLAS Docker Container Run Script
# ATLAS Docker 容器运行脚本
# ==============================================================================
set -Eeuo pipefail
IFS=$'\n\t'
trap 'echo "[ERROR] ${0}:${LINENO} ${BASH_COMMAND}" >&2; exit 1' ERR

# Configuration / 配置
IMAGE_NAME="${1:-atlas:v0.6-base}"
CONTAINER_NAME="${2:-atlas-$(date +%s)}"
GPU_DEVICE="${3:-all}"
WORK_DIR="$(pwd)"

# Colors / 输出颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions / 函数
print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Show usage / 显示用法
ARG1="${1:-}"
if [ "${ARG1}" == "-h" ] || [ "${ARG1}" == "--help" ]; then
  cat << HELP
Usage / 用法: $(basename "$0") [IMAGE] [CONTAINER_NAME] [GPU_DEVICE]

Arguments / 参数:
  IMAGE           Docker image (default: atlas:v0.6-base)
                  Docker 镜像 (默认: atlas:v0.6-base)
  CONTAINER_NAME  Container name (default: atlas-<timestamp>)
                  容器名称 (默认: atlas-<时间戳>)
  GPU_DEVICE      GPU device: all, 0, 1, 0,1 (default: all)
                  GPU 设备 (默认: all)

Examples / 示例:
  $(basename "$0")                          # Use defaults / 使用默认值
  $(basename "$0") atlas:v0.6-base          # Specific image / 指定镜像
  $(basename "$0") atlas:stable mycontainer # Custom name / 自定义名称
  $(basename "$0") atlas:stable mycontainer 0  # GPU 0 only / 仅 GPU 0

HELP
  exit 0
fi

# Main / 主函数
main() {
  print_info "Container Configuration / 容器配置"
  print_info "Image / 镜像: ${IMAGE_NAME}"
  print_info "Container / 容器: ${CONTAINER_NAME}"
  print_info "GPU: ${GPU_DEVICE}"
  print_info "Workspace / 工作目录: ${WORK_DIR}"

  # Check Docker / 检查 Docker
  if ! command -v docker &> /dev/null; then
    print_error "Docker not installed / Docker 未安装"
    exit 1
  fi

  # Check image / 检查镜像
  if ! docker image inspect "${IMAGE_NAME}" &> /dev/null; then
    print_error "Image not found / 镜像不存在: ${IMAGE_NAME}"
    print_info "Available images / 可用镜像:"
    docker images --filter "reference=atlas*" --format "  {{.Repository}}:{{.Tag}}" || true
    exit 1
  fi

  # GPU configuration / GPU 配置
  if [[ ! "$GPU_DEVICE" =~ ^(all|[0-9]+(,[0-9]+)*)$ ]]; then
    print_warn "Invalid GPU format, using 'all' / GPU 格式无效，使用 'all'"
    GPU_DEVICE="all"
  fi

  if [ "$GPU_DEVICE" = "all" ]; then
    GPU_ARG="--gpus all"
  else
    GPU_ARG="--gpus device=${GPU_DEVICE}"
  fi

  # Run container / 运行容器
  print_info "Starting container... / 启动容器..."

  docker run -it \
    --name "${CONTAINER_NAME}" \
    "${GPU_ARG}" \
    -v "${WORK_DIR}:/workspace" \
    -w /workspace \
    --rm \
    "${IMAGE_NAME}"
}

main
