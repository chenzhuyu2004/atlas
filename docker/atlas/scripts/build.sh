#!/usr/bin/env bash
# ==============================================================================
# ATLAS Build Script / 构建脚本
# Optimized for: 13980HX + RTX 4060 Laptop (16GB RAM)
# 针对硬件优化: 13980HX + RTX 4060 笔记本 (16GB 内存)
# ==============================================================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step()  { echo -e "${BLUE}[STEP]${NC} $1"; }

# 目录设置
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOCKERFILE="${PROJECT_ROOT}/Dockerfile"

# 默认配置
IMAGE_NAME="${IMAGE_NAME:-atlas}"
BUILD_TIER="${BUILD_TIER:-0}"
ENABLE_MATERIALS="${ENABLE_MATERIALS:-0}"

# 使用说明
usage() {
    cat << EOF
ATLAS Build Script
用法: $0 [选项]

构建层级 (BUILD_TIER):
  0 = base      核心数据科学栈 (PyTorch + sklearn + pandas等)
  1 = llm       + LLM基础支持 (transformers + bitsandbytes)
  2 = full      + LLM加速推理 (vLLM + DeepSpeed)

材料科学 (ENABLE_MATERIALS):
  0 = 不安装
  1 = 安装 (ase + pymatgen + spglib等)

示例:
  # 仅核心数据科学 (最快，最稳定)
  BUILD_TIER=0 $0

  # 核心 + LLM基础
  BUILD_TIER=1 $0

  # 完整LLM支持
  BUILD_TIER=2 $0

  # 核心 + 材料科学
  BUILD_TIER=0 ENABLE_MATERIALS=1 $0

  # 完整版 (LLM + 材料科学)
  BUILD_TIER=2 ENABLE_MATERIALS=1 $0

环境变量:
  IMAGE_NAME        镜像名称 (默认: atlas)
  BUILD_TIER        构建层级 0-2 (默认: 0)
  ENABLE_MATERIALS  启用材料科学 0/1 (默认: 0)
  NO_CACHE          禁用缓存 0/1 (默认: 0)

EOF
    exit 0
}

# 解析参数
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
fi

# 读取版本号
VERSION=$(tr -d '\n' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "0.6")

# 生成标签
generate_tag() {
    local tag="v${VERSION}"
    if [[ "${ENABLE_MATERIALS}" == "1" ]]; then
        tag+="-materials"
    else
        case "${BUILD_TIER}" in
            0) tag+="-base" ;;
            1) tag+="-llm" ;;
            2) tag+="-full" ;;
        esac
    fi
    echo "${tag}"
}

# 构建函数
build_image() {
    local tag
    tag=$(generate_tag)
    local cache_opt=""
    [[ "${NO_CACHE:-0}" == "1" ]] && cache_opt="--no-cache"

    print_info "============================================"
    print_info "ATLAS Build"
    print_info "============================================"
    print_info "镜像: ${IMAGE_NAME}:${tag}"
    print_info "层级: BUILD_TIER=${BUILD_TIER}"
    print_info "材料科学: ENABLE_MATERIALS=${ENABLE_MATERIALS}"
    print_info "============================================"

    # 检查Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker未安装"
        exit 1
    fi

    # 检查Dockerfile
    if [[ ! -f "${DOCKERFILE}" ]]; then
        print_error "Dockerfile不存在: ${DOCKERFILE}"
        exit 1
    fi

    # 预估镜像大小
    print_step "预估镜像大小..."
    local est_size="~22GB"
    case "${BUILD_TIER}" in
        0) est_size="~22GB" ;;
        1) est_size="~22GB" ;;
        2) est_size="~37GB" ;;
    esac
    [[ "${ENABLE_MATERIALS}" == "1" ]] && est_size="${est_size} + ~1GB"
    print_info "预估大小: ${est_size}"

    # 检查磁盘空间
    local avail_space
    avail_space=$(df -BG "${PROJECT_ROOT}" | awk 'NR==2 {print $4}' | tr -d 'G')
    if [[ "${avail_space}" -lt 30 ]]; then
        print_warn "磁盘空间不足30GB (当前: ${avail_space}GB)，可能导致构建失败"
        if [[ "${AUTO_YES:-0}" == "1" ]]; then
            print_warn "AUTO_YES=1 set, continuing anyway"
        elif [[ "${NON_INTERACTIVE:-0}" == "1" || ! -t 0 ]]; then
            print_error "非交互环境下无法确认，设置 AUTO_YES=1 以继续"
            exit 1
        else
            read -p "是否继续? [y/N] " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
        fi
    fi

    # 检查内存 (16GB优化)
    local total_mem
    total_mem=$(free -g | awk '/^Mem:/{print $2}')
    if [[ "${total_mem}" -le 16 ]]; then
        print_warn "检测到内存 ${total_mem}GB，已启用低内存模式 (MAX_JOBS=2)"
        if [[ "${BUILD_TIER}" -ge 2 ]]; then
            print_warn "BUILD_TIER=2 在16GB内存下可能较慢，建议先尝试 BUILD_TIER=1"
        fi
    fi

    # 构建
    print_step "开始构建..."
    export DOCKER_BUILDKIT=1

    if docker build \
        --file "${DOCKERFILE}" \
        --tag "${IMAGE_NAME}:${tag}" \
        --build-arg BUILD_TIER="${BUILD_TIER}" \
        --build-arg ENABLE_MATERIALS="${ENABLE_MATERIALS}" \
        --build-arg VERSION="${VERSION}" \
        --progress=plain \
        ${cache_opt} \
        "${PROJECT_ROOT}"; then
        print_info "============================================"
        print_info "✓ 构建成功!"
        print_info "============================================"
        docker images "${IMAGE_NAME}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

        echo ""
        print_info "运行命令:"
        echo "  docker run --gpus all -it --rm ${IMAGE_NAME}:${tag}"
        echo ""
        print_info "挂载工作目录:"
        echo "  docker run --gpus all -it --rm -v \$(pwd):/workspace ${IMAGE_NAME}:${tag}"
    else
        print_error "构建失败"
        exit 1
    fi
}

# 主函数
main() {
    build_image
}

main "$@"
