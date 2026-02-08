#!/usr/bin/env bash
# ==============================================================================
# ATLAS Docker Image Tag Management Script
# ATLAS Docker 镜像标签管理脚本
# ==============================================================================

set -Eeuo pipefail
IFS=$'\n\t'
trap 'echo "[ERROR] ${0}:${LINENO} ${BASH_COMMAND}" >&2; exit 1' ERR

# Colors / 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions / 函数
print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# Show help / 显示帮助
show_help() {
    cat << EOF
Usage: $(basename "$0") COMMAND [VERSION] [SOURCE_TAG]

Commands:
  tag VERSION [SOURCE]  Tag image with version (e.g., 1.0.0)
                        为镜像标记版本（例如 1.0.0）
  list                  List all image tags
                        列出所有镜像标签
  inspect [VERSION]     Inspect image metadata
                        检查镜像元数据
  promote VERSION       Promote version to stable
                        将版本升级为稳定版
  cleanup               Remove old versions
                        删除旧版本
  help                  Show this help
                        显示此帮助

Examples:
  $(basename "$0") tag 1.0.0              # Tag v0.6-base as v1.0.0
  $(basename "$0") tag 1.0.0 v0.6-llm     # Tag v0.6-llm as v1.0.0
  $(basename "$0") promote 1.0.0          # Promote to stable
  $(basename "$0") list                   # List all tags
  $(basename "$0") cleanup                # Clean old images

EOF
}

# Get script directory / 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read VERSION file once / 读取 VERSION 文件（一次）
CURRENT_VERSION="$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "0.6")"

# Tag image with semantic version / 用语义化版本标记镜像
tag_image() {
    local version=$1
    local source_tag=${2:-"v${CURRENT_VERSION}-base"}  # Optional source tag / 可选的源标签
    local image_name="atlas"
    
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Use X.Y.Z (e.g., 1.0.0)"
        return 1
    fi
    
    print_header "Tagging Image with Version: $version"
    
    # Extract major.minor
    local major
    major=$(echo "$version" | cut -d. -f1)
    local minor
    minor=$(echo "$version" | cut -d. -f2)
    local major_minor="${major}.${minor}"
    
    # Check if source image exists / 检查源镜像是否存在
    if ! docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^${image_name}:${source_tag}$"; then
        print_error "Image not found: ${image_name}:${source_tag}"
        print_info "Available images:"
        docker images --format '{{.Repository}}:{{.Tag}}' | grep "^${image_name}:" || true
        print_info "\nUsage: $(basename "$0") tag VERSION [SOURCE_TAG]"
        print_info "Example: $(basename "$0") tag 1.0.0 v0.6-base"
        return 1
    fi
    
    # Create tags / 创建标签
    print_info "Source image: ${image_name}:${source_tag}"
    print_info "Creating tags..."
    
    docker tag "${image_name}:${source_tag}" "${image_name}:${version}"
    print_info "✓ Tagged as: ${image_name}:${version}"
    
    docker tag "${image_name}:${source_tag}" "${image_name}:${major_minor}"
    print_info "✓ Tagged as: ${image_name}:${major_minor}"
    
    docker tag "${image_name}:${source_tag}" "${image_name}:v${major}"
    print_info "✓ Tagged as: ${image_name}:v${major}"
    
    # Show all tags / 显示所有标签
    print_info "\nAll tags for this version:"
    docker images | grep "${image_name}" | grep -E "(${version}|${major_minor}|v${major})" || true
}

# List all tags / 列出所有标签
list_tags() {
    print_header "ATLAS Docker Image Tags"
    
    if docker images | grep -q "^atlas"; then
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | grep atlas
    else
        print_warn "No ATLAS images found"
    fi
}

# Inspect image / 检查镜像
inspect_image() {
    local version=$1
    local image="${version:+atlas:$version}"
    
    # Default to VERSION-base if no version specified / 默认使用 VERSION-base
    if [ -z "$image" ]; then
        image="atlas:v${CURRENT_VERSION}-base"
    fi
    
    print_header "Image Details: $image"
    
    if ! docker images | grep -q "^atlas"; then
        print_error "Image not found: $image"
        return 1
    fi
    
    print_info "Image Metadata:"
    docker inspect "$image" --format='
Created:     {{.Created}}
Architecture: {{.Architecture}}
OS:          {{.Os}}
Size:        {{.Size}} bytes
' || true
    
    print_info "\nLabels:"
    docker inspect "$image" --format='
{{range $key, $value := .Config.Labels}}{{$key}}: {{$value}}
{{end}}' || true
    
    print_info "\nEnvironment Variables:"
    docker inspect "$image" --format='
{{range .Config.Env}}{{.}}
{{end}}' | head -20 || true
}

# Promote to stable / 升级为稳定版
promote_version() {
    local version=$1
    local image="atlas:${version}"
    
    print_header "Promoting Version to Stable: $version"
    
    if ! docker images | grep -q "^${image}"; then
        print_error "Image not found: $image"
        return 1
    fi
    
    print_warn "This will tag $version as stable"
    read -p "Continue? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker tag "$image" "atlas:stable"
        print_info "✓ Tagged as stable"
        docker images | grep atlas:stable
    else
        print_info "Cancelled"
    fi
}

# Cleanup old images / 清理旧镜像
cleanup_images() {
    print_header "Cleaning Up Old Images"
    
    print_warn "This will remove dangling images"
    read -p "Continue? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Removing dangling images..."
        docker image prune -f
        
        print_info "Removing old build cache..."
        docker builder prune -f
        
        print_info "Current images:"
        docker images | grep atlas
    else
        print_info "Cancelled"
    fi
}

# Main / 主程序
main() {
    local command=${1:-help}
    
    case "$command" in
        tag)
            if [ -z "$2" ]; then
                print_error "Version required"
                show_help
                exit 1
            fi
            tag_image "$2" "$3"
            ;;
        list)
            list_tags
            ;;
        inspect)
            inspect_image "$2"
            ;;
        promote)
            if [ -z "$2" ]; then
                print_error "Version required"
                show_help
                exit 1
            fi
            promote_version "$2"
            ;;
        cleanup)
            cleanup_images
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
