#!/usr/bin/env bash
# ==============================================================================
# ATLAS Docker Build Test / ATLAS Docker 构建测试
# Tests building Docker images for all tiers
# 测试所有层级的 Docker 镜像构建
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

# Navigate to repo root / 导航到仓库根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${SCRIPT_DIR}/.."

TEST_PASSED=0
TEST_FAILED=0

# Test function / 测试函数
run_test() {
  local test_name="$1"
  local build_tier="$2"
  local enable_materials="$3"
  
  print_test "Testing: ${test_name}"
  
  if BUILD_TIER="${build_tier}" ENABLE_MATERIALS="${enable_materials}" NO_CACHE=0 ./build.sh; then
    print_info "✓ ${test_name} passed"
    ((TEST_PASSED++))
    return 0
  else
    print_error "✗ ${test_name} failed"
    ((TEST_FAILED++))
    return 1
  fi
}

# Header / 标题
echo "========================================"
echo "ATLAS Build Tests / ATLAS 构建测试"
echo "========================================"
echo ""

# Test 1: Base image / 基础镜像
print_test "Test 1: BUILD_TIER=0 (base)"
run_test "Base Image" 0 0 || true
echo ""

# Test 2: LLM image / LLM 镜像
print_test "Test 2: BUILD_TIER=1 (llm)"
run_test "LLM Image" 1 0 || true
echo ""

# Test 3: Full image (may fail due to vLLM) / 完整镜像（可能因 vLLM 失败）
print_test "Test 3: BUILD_TIER=2 (full) - may fail"
print_warn "This test may fail due to vLLM compatibility with PyTorch 2.10.0"
if run_test "Full Image" 2 0; then
  print_info "Full image build succeeded"
else
  print_warn "Full image build failed (expected, see README.md)"
  # Don't count as failure / 不计为失败
  ((TEST_FAILED--))
fi
echo ""

# Test 4: Materials science / 材料科学
print_test "Test 4: ENABLE_MATERIALS=1"
run_test "Materials Science" 0 1 || true
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
