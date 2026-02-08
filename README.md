# ATLAS Docker Image v0.6

[![CI](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml/badge.svg)](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.10.0-EE4C2C.svg)](https://pytorch.org/)
[![CUDA](https://img.shields.io/badge/CUDA-13.0-76B900.svg)](https://developer.nvidia.com/cuda-toolkit)

**ML/DS Docker environment optimized for Intel 13980HX + RTX 4060 Laptop (16GB RAM)**

针对 **Intel 13980HX + RTX 4060 笔记本 (16GB 内存)** 优化的 ML/DS Docker 环境

## Hardware / 硬件配置

| Component / 组件 | Spec / 规格 | Note / 说明 |
|------------------|-------------|-------------|
| **CPU** | i9-13980HX | 24 cores, build parallelism limited to 2 / 24核心，编译并发限制为2 |
| **GPU** | RTX 4060 Laptop | Ada Lovelace (sm_89), 8GB VRAM |
| **RAM** | 16GB | MAX_JOBS=2 prevents OOM / MAX_JOBS=2 防止构建 OOM |

## Image Specs / 镜像规格

| Component / 组件 | Version / 版本 |
|------------------|----------------|
| Base Image | `pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel` |
| Python | 3.12 |
| PyTorch | 2.10.0 |
| CUDA | 13.0 |
| cuDNN | 9 |
| NumPy | 2.4.2 |
| Pandas | 3.0.0 |

## Scope / 适用范围

- This image is GPU-first and expects NVIDIA runtime for normal use.
- 该镜像以 GPU 为优先设计，正常使用需要 NVIDIA 运行时。

## Quick Start / 快速开始

```bash
cd ~/build/atlas
chmod +x *.sh

# Core only (recommended for first build)
# 仅核心版 (推荐首次构建)
./build.sh

# Core + Materials Science / 核心 + 材料科学
ENABLE_MATERIALS=1 ./build.sh

# Core + LLM / 核心 + LLM
BUILD_TIER=1 ./build.sh

# Full version / 完整版
BUILD_TIER=2 ENABLE_MATERIALS=1 ./build.sh
```

For detailed build options and troubleshooting, see `docs/BUILD.md`.
更详细的构建选项与故障排除请见 `docs/BUILD.md`。

## Build Tiers / 构建层级

| BUILD_TIER | Tag / 标签 | Content / 内容 | Size / 大小 | PyTorch | CUDA |
|------------|------------|----------------|-------------|---------|------|
| 0 (default) | v0.6-base | PyTorch + sklearn + pandas + matplotlib | ~22GB | 2.10.0 | 13.0 |
| 1 | v0.6-llm | + transformers + bitsandbytes | ~22GB | 2.10.0 | 13.0 |
| 2 | v0.6-full | + vLLM + DeepSpeed | ~37GB | 2.9.1* | 12.8* |
| ENABLE_MATERIALS=1 | v0.6-materials | + ase + pymatgen + phonopy + mace | ~23GB | 2.10.0 | 13.0 |

> **Note / 注意**: v0.6-full is *intended* to use PyTorch 2.9.1 + CUDA 12.8 due to vLLM 0.15.1 hard dependency.
> 当前 Dockerfile 统一基于 PyTorch 2.10.0 + CUDA 13.0，BUILD_TIER=2 可能因 vLLM 兼容性而失败。
> 建议在 vLLM 更新前使用 BUILD_TIER=1，或等待后续重构。

## Included Packages / 包含组件

### Core Data Science / 核心数据科学 (BUILD_TIER=0)
- numpy, pandas, scipy, polars
- scikit-learn
- matplotlib, seaborn
- jupyterlab, ipython
- opencv, pillow
- pydantic, safetensors, h5py

### LLM Base / LLM 基础 (BUILD_TIER>=1)
- transformers, accelerate, datasets, peft
- huggingface_hub
- sentencepiece, tiktoken
- bitsandbytes (4/8bit quantization / 量化)

### LLM Acceleration / LLM 加速 (BUILD_TIER>=2)
- vLLM (high-performance inference / 高性能推理)
- DeepSpeed (distributed training / 分布式训练)

### Materials Science / 材料科学 (ENABLE_MATERIALS=1)
- ase (atomic simulation / 原子模拟)
- pymatgen (materials analysis / 材料分析)
- spglib (symmetry / 对称性)
- mendeleev, mp-api

## Run Container / 运行容器

```bash
# Interactive / 交互式
./run.sh

# Or directly / 或直接运行
docker run --gpus all -it --rm atlas:v0.6-base

# Mount workspace / 挂载工作目录
docker run --gpus all -it --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    atlas:v0.6-base

# Start JupyterLab / 启动 JupyterLab
docker run --gpus all -it --rm \
    -p 8888:8888 \
    -v $(pwd):/workspace \
    -w /workspace \
    atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```

## Healthcheck / 健康检查

- Exit code `0` means CUDA is available.
- Exit code `1` means CUDA is unavailable (GPU not visible).
- Exit code `2` means `torch` failed to import.
- 退出码 `0` 表示 CUDA 可用。
- 退出码 `1` 表示 CUDA 不可用（GPU 不可见）。
- 退出码 `2` 表示 `torch` 导入失败。

## Tagging Images / 镜像打标

```bash
# Tag using default source (v$(cat VERSION)-base)
./tag.sh tag 1.0.0

# Tag from a specific tier
./tag.sh tag 1.0.0 v0.6-llm

# Make wrapper
make tag TAG_VERSION=1.0.0 SOURCE=v0.6-llm
```

## License

MIT
