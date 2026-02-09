#!/usr/bin/env bash
# ==============================================================================
# ATLAS Usage Metrics Helper / 使用指标收集辅助脚本
# Collect basic image and container metrics (no telemetry).
# 采集镜像与容器的基础指标（不做任何远程上报）。
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_VERSION="$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "0.6")"
DEFAULT_IMAGE="atlas:v${DEFAULT_VERSION}-base"

IMAGE_NAME="${IMAGE_NAME:-${DEFAULT_IMAGE}}"
CONTAINER_NAME="${1:-}"

print_info "Image metrics for ${IMAGE_NAME}"
if docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
  docker image inspect "${IMAGE_NAME}" --format \
    "  ID={{.Id}}\n  Size={{.Size}} bytes\n  Created={{.Created}}\n  Labels={{json .Config.Labels}}"
else
  print_warn "Image not found: ${IMAGE_NAME}"
  print_info "Available atlas images:"
  docker images atlas --format "  {{.Repository}}:{{.Tag}}\t{{.Size}}" || true
fi

echo ""
if [[ -n "${CONTAINER_NAME}" ]]; then
  print_info "Container metrics for ${CONTAINER_NAME}"
  if docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    docker stats --no-stream "${CONTAINER_NAME}"
  else
    print_warn "Container not running: ${CONTAINER_NAME}"
  fi
else
  print_info "No container specified. To collect runtime metrics:"
  echo "  ./scripts/collect-metrics.sh <container-name>"
fi
