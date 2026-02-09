#!/usr/bin/env bash
# ==============================================================================
# ATLAS End-to-End Test / 端到端测试
# Validate container runtime, volume mounts, and basic tooling.
# 验证容器运行、挂载读写与基础工具可用性。
# ==============================================================================

set -euo pipefail

# Colors / 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_VERSION="$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION" 2>/dev/null || echo "0.6")"
DEFAULT_IMAGE="atlas:v${DEFAULT_VERSION}-base"
IMAGE_NAME="${IMAGE_NAME:-${DEFAULT_IMAGE}}"

if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${IMAGE_NAME}$"; then
  print_error "Image not found: ${IMAGE_NAME}"
  print_info "Please build the image first: ./build.sh"
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

print_info "Running end-to-end test for ${IMAGE_NAME}"
print_info "Workspace: ${TMP_DIR}"

echo "hello" > "${TMP_DIR}/input.txt"

print_info "1) Verify container runs as non-root user"
USER_ID="$(docker run --rm "${IMAGE_NAME}" id -u)"
if [ "${USER_ID}" = "0" ]; then
  print_error "Container is running as root (uid 0)"
  exit 1
fi
print_info "✓ Non-root user detected (uid ${USER_ID})"

print_info "2) Verify volume mount and file write"
docker run --rm \
  -v "${TMP_DIR}:/workspace" \
  -w /workspace \
  "${IMAGE_NAME}" \
  python - <<'PY'
import pathlib
path = pathlib.Path("/workspace/output.txt")
path.write_text("ok")
print("Wrote", path)
PY

if [ ! -f "${TMP_DIR}/output.txt" ]; then
  print_error "Failed to write output file via container"
  exit 1
fi
print_info "✓ Volume write verified"

print_info "3) Verify JupyterLab import"
docker run --rm "${IMAGE_NAME}" python - <<'PY'
import jupyterlab
print("jupyterlab", jupyterlab.__version__)
PY
print_info "✓ JupyterLab import OK"

print_info "All end-to-end checks passed"
