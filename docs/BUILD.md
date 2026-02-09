## Python 虚拟环境与依赖锁定建议

强烈建议在本地开发和测试时使用 Python 虚拟环境（如 venv 或 conda），以避免依赖冲突：

```bash
# venv 示例
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# conda 示例
conda create -n atlas python=3.10
conda activate atlas
pip install -r requirements.txt
```

依赖锁定建议：
- requirements.txt/llm/materials/accel 文件已锁定主要依赖版本，确保可复现性。
- 如需进一步锁定所有依赖（含间接依赖），可用 pip-tools 生成 requirements.lock：

```bash
pip install pip-tools
pip-compile requirements.txt --output-file requirements.lock
```

如需升级依赖，建议先在本地虚拟环境中测试，确认无冲突后再更新 requirements 文件。
# ATLAS Build Guide / 构建指南

> **Note**: Examples use `v0.6` tags. Replace with `v$(cat VERSION)` (or your current version) when you follow these commands.

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
├── VERSION                 # Version number / 版本号
│
├── scripts/                # Actual scripts / 实际脚本目录
│   ├── build.sh            # Build implementation / 构建实现
│   ├── run.sh              # Run implementation / 运行实现
│   ├── pre-check.sh        # Pre-check implementation / 预检查实现
│   ├── tag.sh              # Tag management / 标签管理
│   ├── push.sh             # Push to registry / 推送到注册表
│   └── check-updates.sh    # Check package updates / 检查包更新
│
├── build.sh                # Wrapper (→ scripts/build.sh)
├── run.sh                  # Wrapper (→ scripts/run.sh)
├── pre-check.sh            # Wrapper (→ scripts/pre-check.sh)
├── tag.sh                  # Wrapper (→ scripts/tag.sh)
├── push.sh                 # Wrapper (→ scripts/push.sh)
├── check-updates.sh        # Wrapper (→ scripts/check-updates.sh)
│
├── requirements.txt        # Core dependencies / 核心依赖
├── requirements-llm.txt    # LLM base / LLM 基础
├── requirements-accel.txt  # LLM acceleration / LLM 加速
├── requirements-materials.txt # Materials science / 材料科学
│
├── README.md               # Main documentation / 主文档
├── CHANGELOG.md            # Version history / 版本历史
├── docs/                   # Detailed documentation / 详细文档
│   ├── README.md           # Documentation index / 文档索引
│   ├── BUILD.md            # This file / 本文件
│   ├── RUN.md              # Runtime guide / 运行指南
│   └── TESTS.md            # Testing guide / 测试指南
└── tests/                  # Test suite / 测试套件
    └── test_*.{py,sh}      # Test scripts / 测试脚本
```

> **Note**: Root directory scripts are wrappers for backward compatibility.
> Actual implementations are in `scripts/` directory.
>
> **注意**: 根目录的脚本是向后兼容的 wrapper，实际实现在 `scripts/` 目录中。

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
