# ATLAS Build Guide / 构建指南

## Build Tiers / 构建层级

| BUILD_TIER | Tag / 标签 | Content / 内容 | Size / 大小 | Time / 时间 |
|------------|------------|----------------|-------------|-------------|
| 0 (default) | v0.6-base | Core Data Science / 核心数据科学 | ~22GB | ~5min |
| 1 | v0.6-llm | + LLM Base / + LLM 基础 | ~22GB | ~10min |
| 2 | v0.6-full | + LLM Acceleration / + LLM 加速 | ~37GB | ~20min |

Materials Science / 材料科学: `ENABLE_MATERIALS=1` adds ~1GB / 追加 ~1GB

## Build Commands / 构建命令

```bash
cd ~/build/atlas

# Note: build.sh reads environment variables from the shell only.
# .env is NOT loaded automatically.
# 注意：build.sh 只读取当前 shell 的环境变量，
# 不会自动加载 .env。

# If you want to use .env, source it before running build.sh:
# 如果需要使用 .env，请先 source 再运行 build.sh：
# set -a; [ -f .env ] && . .env; set +a

# Pre-check / 预检查
./pre-check.sh

# Core only (recommended first) / 仅核心版 (推荐首次)
./build.sh

# + Materials Science / + 材料科学
ENABLE_MATERIALS=1 ./build.sh

# + LLM Base / + LLM 基础
BUILD_TIER=1 ./build.sh

# Full version / 完整版
BUILD_TIER=2 ENABLE_MATERIALS=1 ./build.sh

# No cache rebuild / 禁用缓存重新构建
NO_CACHE=1 ./build.sh
```

## Tagging Images / 镜像打标

```bash
# Default source: v$(cat VERSION)-base
./tag.sh tag 1.0.0

# Specific source tier
./tag.sh tag 1.0.0 v0.6-llm

# Make wrapper
make tag TAG_VERSION=1.0.0 SOURCE=v0.6-llm
```

Notes / 说明:
- `TAG_VERSION` is required for `make tag`.
- `TAG_VERSION` 为 `make tag` 必填参数。
- `SOURCE` is optional; default is `v$(cat VERSION)-base`.
- `SOURCE` 可选，默认是 `v$(cat VERSION)-base`。

## Run Container / 运行容器

```bash
# Interactive / 交互式
./run.sh

# Specific image / 指定镜像
./run.sh atlas:v0.6-base

# Mount + JupyterLab / 挂载 + JupyterLab
docker run --gpus all -it --rm \
    -p 8888:8888 \
    -v $(pwd):/workspace \
    -w /workspace \
    atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```

## 16GB Memory Optimization / 内存优化

Built-in optimizations / 已内置优化:
- `MAX_JOBS=2`: Limits compile parallelism / 限制编译并发
- `MAKEFLAGS="-j2"`: Limits make parallelism / 限制 make 并发
- Precompiled wheels preferred / 优先使用预编译 wheel
- Tiered build: can resume from checkpoint / 分层构建: 可从断点继续

If still OOM / 如仍 OOM:
```bash
docker build --build-arg MAX_JOBS=1 -t atlas:v0.6-base .
```

## Materials Versioning / 材料栈版本锁定

`requirements-materials.txt` is fully pinned to ensure reproducible builds.
If you update materials packages, keep versions pinned and rebuild the image.
`requirements-materials.txt` 已完整锁定版本以确保可复现构建。
如需更新材料包，请保持锁定并重新构建镜像。

## File Structure / 文件结构

```
build/atlas/
├── Dockerfile              # Build file / 构建文件
├── build.sh                # Build script / 构建脚本
├── run.sh                  # Run script / 运行脚本
├── pre-check.sh            # Pre-check script / 预检查脚本
├── tag.sh                  # Tag management / 标签管理
│
├── requirements.txt        # Core dependencies / 核心依赖
├── requirements-llm.txt    # LLM base / LLM 基础
├── requirements-accel.txt  # LLM acceleration / LLM 加速
├── requirements-materials.txt # Materials science / 材料科学
│
├── README.md               # Main documentation / 主文档
├── CHANGELOG.md            # Version history / 版本历史
└── docs/
    └── BUILD.md            # This file / 本文件
```

## Troubleshooting / 故障排除

| Issue / 问题 | Solution / 解决方案 |
|--------------|---------------------|
| OOM / 内存不足 | `MAX_JOBS=1` |
| Network timeout / 网络超时 | Use domestic pip mirror / 使用国内 pip 镜像 |
| Disk full / 磁盘不足 | `docker system prune -a` |
| vLLM fails / vLLM 失败 | Use BUILD_TIER=1 instead / 使用 BUILD_TIER=1 |

Notes / 说明:
- vLLM 0.15.1 currently expects PyTorch 2.9.1 + CUDA 12.8.
- vLLM 0.15.1 目前期望 PyTorch 2.9.1 + CUDA 12.8。
- The Dockerfile base is 2.10.0 + 13.0, so BUILD_TIER=2 may fail until vLLM updates.
- 当前 Dockerfile 基础镜像为 2.10.0 + 13.0，因此 BUILD_TIER=2 可能失败，需等待 vLLM 更新。
