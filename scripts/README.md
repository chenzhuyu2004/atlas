# Scripts Directory / 脚本目录

This directory contains the main operational scripts for ATLAS Docker image.

包含 ATLAS Docker 镜像的主要操作脚本。

## Scripts Overview / 脚本概览

| Script / 脚本 | Purpose / 用途 | Usage / 使用 |
|--------------|----------------|-------------|
| `build.sh` | Build Docker image / 构建 Docker 镜像 | `./build.sh` or `BUILD_TIER=1 ./build.sh` |
| `run.sh` | Run container interactively / 交互式运行容器 | `./run.sh` |
| `tag.sh` | Tag image for release / 为发布打标签 | `./tag.sh tag 1.0.0` |
| `push.sh` | Push image to registry / 推送镜像到注册表 | `./push.sh v0.6-base` |
| `pre-check.sh` | Pre-build checks / 预构建检查 | Called by `build.sh` |
| `check-updates.sh` | Check package updates / 检查包更新 | `./check-updates.sh` |

## Backward Compatibility / 向后兼容

Root directory contains wrapper scripts for backward compatibility:
根目录包含 wrapper 脚本以保持向后兼容：

```bash
# These work the same / 这些用法相同
./build.sh          # wrapper → scripts/build.sh
./scripts/build.sh  # direct call / 直接调用
```

## Usage Examples / 使用示例

### Build / 构建

```bash
# Basic build (tier 0) / 基础构建
./scripts/build.sh

# Build with LLM support (tier 1) / 带 LLM 支持
BUILD_TIER=1 ./scripts/build.sh

# Build with materials science / 带材料科学
ENABLE_MATERIALS=1 ./scripts/build.sh

# Full build (tier 2, experimental) / 完整构建（实验性）
BUILD_TIER=2 ./scripts/build.sh
```

### Run / 运行

```bash
# Interactive shell / 交互式终端
./scripts/run.sh

# Run specific tier / 运行特定层级
./scripts/run.sh atlas:v0.6-llm
```

### Tag & Push / 打标签和推送

```bash
# Tag for release / 为发布打标签
./scripts/tag.sh tag 1.0.0

# Tag from specific tier / 从特定层级打标签
./scripts/tag.sh tag 1.0.0 v0.6-llm

# Push to registry / 推送到注册表
./scripts/push.sh v0.6-base
```

### Maintenance / 维护

```bash
# Check for package updates / 检查包更新
./scripts/check-updates.sh

# Manual pre-check / 手动预检查
./scripts/pre-check.sh
```

## Environment Variables / 环境变量

Scripts respect the following environment variables:
脚本遵循以下环境变量：

- `BUILD_TIER`: Build tier (0, 1, or 2) / 构建层级
- `ENABLE_MATERIALS`: Enable materials science packages (0 or 1) / 启用材料科学包
- `IMAGE_TAG`: Docker image tag to use / 使用的 Docker 镜像标签
- `REGISTRY`: Container registry for push/pull / 容器注册表
- `MAX_JOBS`: Build parallelism (default: 2) / 构建并发数

## See Also / 相关文档

- [docs/BUILD.md](../docs/BUILD.md) - Detailed build documentation / 详细构建文档
- [docs/RUN.md](../docs/RUN.md) - Runtime guide / 运行指南
- [Makefile](../Makefile) - Make targets wrapping these scripts / Make 目标包装这些脚本
