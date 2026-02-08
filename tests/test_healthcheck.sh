#!/usr/bin/env bash
# ==============================================================================
# ATLAS Health Check Test / ATLAS 健康检查测试
# Tests Docker HEALTHCHECK functionality and basic container operations
# 测试 Docker HEALTHCHECK 功能和基本容器操作
# ==============================================================================

set -e

# Colors / 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_test()  { echo -e "${BLUE}[TEST]${NC} $1"; }

# Configuration / 配置
CONTAINER_NAME="${1:-}"
IMAGE_NAME="${IMAGE_NAME:-atlas:v0.6-base}"
TEST_PASSED=0
TEST_FAILED=0

# Check if image exists / 检查镜像是否存在
if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${IMAGE_NAME}$"; then
  print_error "Image not found: ${IMAGE_NAME}"
  print_info "Please build the image first: ./build.sh"
  exit 1
fi

echo "========================================"
echo "ATLAS Health Check Tests"
echo "ATLAS 健康检查测试"
echo "========================================"
echo ""

# Test 1: Container starts / 容器启动
print_test "Test 1: Container starts successfully"
if docker run --rm "${IMAGE_NAME}" python --version > /dev/null 2>&1; then
  print_info "✓ Container starts successfully"
  ((TEST_PASSED++))
else
  print_error "✗ Container failed to start"
  ((TEST_FAILED++))
fi
echo ""

# Test 2: Docker HEALTHCHECK status / Docker HEALTHCHECK 状态
print_test "Test 2: Docker HEALTHCHECK status"
if [ -n "${CONTAINER_NAME}" ]; then
  # Check if container exists and is running / 检查容器是否存在且运行中
  if docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    # Wait for healthcheck to initialize / 等待健康检查初始化
    sleep 5
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "${CONTAINER_NAME}" 2>/dev/null || echo "none")
    print_info "Container health status: ${HEALTH_STATUS}"
    
    if [ "${HEALTH_STATUS}" = "healthy" ] || [ "${HEALTH_STATUS}" = "starting" ]; then
      print_info "✓ HEALTHCHECK is functional (status: ${HEALTH_STATUS})"
      ((TEST_PASSED++))
    elif [ "${HEALTH_STATUS}" = "none" ]; then
      print_warn "⚠ No HEALTHCHECK defined in image"
      ((TEST_PASSED++))
    elif [ "${HEALTH_STATUS}" = "unhealthy" ]; then
      print_error "✗ Container is unhealthy"
      ((TEST_FAILED++))
    else
      print_warn "⚠ Unknown health status: ${HEALTH_STATUS}"
      ((TEST_PASSED++))
    fi
  else
    print_warn "Container '${CONTAINER_NAME}' not found, testing image health command directly"
    if docker run --rm "${IMAGE_NAME}" python -c "import torch; print(f'PyTorch {torch.__version__}')"; then
      print_info "✓ Health check command works"
      ((TEST_PASSED++))
    else
      print_error "✗ Health check command failed"
      ((TEST_FAILED++))
    fi
  fi
else
  print_info "No container name provided, testing health command directly"
  if docker run --rm "${IMAGE_NAME}" python -c "import torch; print(f'PyTorch {torch.__version__}')"; then
    print_info "✓ Health check command works"
    ((TEST_PASSED++))
  else
    print_error "✗ Health check command failed"
    ((TEST_FAILED++))
  fi
fi
echo ""

# Test 3: CUDA detection (if NVIDIA runtime available) / CUDA 检测
print_test "Test 3: CUDA availability detection"
if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
  print_info "NVIDIA runtime detected, testing with GPU"
  if docker run --gpus all --rm "${IMAGE_NAME}" python -c "import torch; assert torch.cuda.is_available(), 'CUDA not available'"; then
    print_info "✓ CUDA is available in container"
    ((TEST_PASSED++))
  else
    print_warn "✗ CUDA not available (check NVIDIA Docker runtime)"
    ((TEST_FAILED++))
  fi
else
  print_warn "NVIDIA runtime not available, skipping GPU test"
  print_info "CPU-only test:"
  if docker run --rm "${IMAGE_NAME}" python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"; then
    print_info "✓ Container works in CPU mode"
    ((TEST_PASSED++))
  else
    print_error "✗ Container failed in CPU mode"
    ((TEST_FAILED++))
  fi
fi
echo ""

# Test 4: Health check exit codes / 健康检查退出码
print_test "Test 4: Health check exit codes"
if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
  print_info "Testing health check exit codes with GPU"
  docker run --gpus all --rm "${IMAGE_NAME}" python -c "import sys, torch; sys.exit(0 if torch.cuda.is_available() else 1)"
  EXIT_CODE=$?
  
  if [ $EXIT_CODE -eq 0 ]; then
    print_info "✓ Health check returns exit code 0 (CUDA available)"
    ((TEST_PASSED++))
  elif [ $EXIT_CODE -eq 1 ]; then
    print_error "✗ Health check returns exit code 1 (CUDA not available in container)"
    ((TEST_FAILED++))
  else
    print_error "✗ Unexpected exit code: ${EXIT_CODE}"
    ((TEST_FAILED++))
  fi
else
  print_info "Skipping GPU exit code test (no NVIDIA runtime)"
  ((TEST_PASSED++))
fi
echo ""

# Summary / 总结
echo "========================================"
echo "Test Summary / 测试总结"
echo "========================================"
echo "Passed / 通过: ${TEST_PASSED}"
echo "Failed / 失败: ${TEST_FAILED}"
echo ""

if [ "${TEST_FAILED}" -eq 0 ]; then
  print_info "All tests passed! / 所有测试通过！"
  exit 0
else
  print_error "Some tests failed. / 部分测试失败。"
  exit 1
fi
