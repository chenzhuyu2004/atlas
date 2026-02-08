#!/usr/bin/env bash
# ==============================================================================
# ATLAS Test Runner / ATLAS 测试运行器
# Run all tests / 运行所有测试
# ==============================================================================

set -euo pipefail

# Colors / 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# Navigate to test directory / 导航到测试目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${SCRIPT_DIR}"

TOTAL_PASSED=0
TOTAL_FAILED=0

# Header / 标题
echo "========================================================"
echo "ATLAS Test Suite / ATLAS 测试套件"
echo "========================================================"
echo ""

# Make scripts executable / 使脚本可执行
chmod +x *.sh 2>/dev/null || true

# Test 1: Build tests / 构建测试
print_header "1. Build Tests / 构建测试"
if [ "${SKIP_BUILD_TESTS:-0}" = "1" ]; then
  print_info "Skipping build tests (SKIP_BUILD_TESTS=1)"
else
  if ./test_docker_build.sh; then
    print_info "✓ Build tests passed"
    ((TOTAL_PASSED++))
  else
    print_error "✗ Build tests failed"
    ((TOTAL_FAILED++))
  fi
fi

# Test 2: Health check tests / 健康检查测试
print_header "2. Health Check Tests / 健康检查测试"
if ./test_healthcheck.sh; then
  print_info "✓ Health check tests passed"
  ((TOTAL_PASSED++))
else
  print_error "✗ Health check tests failed"
  ((TOTAL_FAILED++))
fi

# Test 3: Package import tests / 包导入测试
print_header "3. Package Import Tests / 包导入测试"
IMAGE_NAME="${IMAGE_NAME:-atlas:v0.6-base}"
if docker run --rm "${IMAGE_NAME}" python /dev/stdin < test_import_packages.py; then
  print_info "✓ Package import tests passed"
  ((TOTAL_PASSED++))
else
  print_error "✗ Package import tests failed"
  ((TOTAL_FAILED++))
fi

# Final summary / 最终总结
echo ""
echo "========================================================"
echo "Final Test Summary / 最终测试总结"
echo "========================================================"
echo "Test suites passed / 通过的测试套件: ${TOTAL_PASSED}"
echo "Test suites failed / 失败的测试套件: ${TOTAL_FAILED}"
echo ""

if [ "${TOTAL_FAILED}" -eq 0 ]; then
  print_info "🎉 All test suites passed! / 所有测试套件通过！"
  exit 0
else
  print_error "❌ Some test suites failed. / 部分测试套件失败。"
  exit 1
fi
