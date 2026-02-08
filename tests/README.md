# ATLAS Test Suite / ATLAS 测试套件

Automated tests for ATLAS Docker images.
ATLAS Docker 镜像的自动化测试。

## Test Structure / 测试结构

```
tests/
├── README.md                    # This file / 本文件
├── test_docker_build.sh         # Build tests / 构建测试
├── test_healthcheck.sh          # Health check tests / 健康检查测试
├── test_import_packages.py      # Package import tests / 包导入测试
└── run_all_tests.sh             # Run all tests / 运行所有测试
```

## Running Tests / 运行测试

### All Tests / 所有测试

```bash
cd tests
./run_all_tests.sh
```

### Individual Tests / 单独测试

```bash
# Build test / 构建测试
./test_docker_build.sh

# Health check test / 健康检查测试
./test_healthcheck.sh

# Package import test / 包导入测试
python test_import_packages.py
```

## Test Categories / 测试分类

### 1. Build Tests / 构建测试

Tests Docker image building for all tiers:
测试所有层级的 Docker 镜像构建：

- BUILD_TIER=0 (base)
- BUILD_TIER=1 (llm)
- BUILD_TIER=2 (full) - may skip if dependencies unavailable
- ENABLE_MATERIALS=1

### 2. Health Check Tests / 健康检查测试

Tests container health checks:
测试容器健康检查：

- Container starts successfully / 容器成功启动
- Health check returns correct exit codes / 健康检查返回正确退出码
- CUDA availability detection / CUDA 可用性检测

### 3. Package Import Tests / 包导入测试

Tests that all required packages can be imported:
测试所有必需包可以导入：

- Core packages (numpy, pandas, etc)
- LLM packages (transformers, etc) if applicable
- Materials science packages if applicable

## CI Integration / CI 集成

Tests run automatically in GitHub Actions:
测试在 GitHub Actions 中自动运行：

- **Build tests**: On every push/PR / 每次 push/PR
- **Package import tests**: On every push/PR / 每次 push/PR
- **Health check tests**: On every push/PR / 每次 push/PR
- **Security scans**: On every push/PR / 每次 push/PR
- **Dependency checks**: Weekly / 每周

See `.github/workflows/ci.yml` for details.
详见 `.github/workflows/ci.yml`。

## Writing New Tests / 编写新测试

When adding new tests:
添加新测试时：

1. Follow existing naming convention / 遵循现有命名约定
2. Add proper error handling / 添加适当的错误处理
3. Include both English and Chinese comments / 包含中英文注释
4. Update this README / 更新此 README
5. Add to `run_all_tests.sh` / 添加到 `run_all_tests.sh`

## Test Requirements / 测试要求

- Docker 20.10+
- Python 3.8+ (for Python tests)
- bash
- NVIDIA Docker runtime (optional, for GPU tests)

## Known Limitations / 已知限制

- GPU tests require NVIDIA runtime / GPU 测试需要 NVIDIA 运行时
- BUILD_TIER=2 tests may fail due to vLLM compatibility / BUILD_TIER=2 测试可能因 vLLM 兼容性失败
- Tests may take 10-30 minutes depending on tier / 测试可能需要 10-30 分钟，取决于层级
