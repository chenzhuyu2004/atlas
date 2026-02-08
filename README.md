# ATLAS Docker Image v0.6

[![CI](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml/badge.svg)](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.10.0-EE4C2C.svg)](https://pytorch.org/)
[![CUDA](https://img.shields.io/badge/CUDA-13.0-76B900.svg)](https://developer.nvidia.com/cuda-toolkit)

**ML/DS Docker environment optimized for Intel 13980HX + RTX 4060 Laptop (16GB RAM)**

针对 **Intel 13980HX + RTX 4060 笔记本 (16GB 内存)** 优化的 ML/DS Docker 环境

## Features / 核心特性

- 🚀 **GPU-First Design**: PyTorch 2.10.0 + CUDA 13.0 + cuDNN 9
- 🧪 **Tiered Build System**: 从核心数据科学到完整 LLM 支持的可选构建层级
- 🔬 **Materials Science Support**: 可选的材料科学工具包集成
- 📊 **Production Ready**: 完整的测试套件、CI/CD 和安全扫描
- 💻 **Memory Optimized**: 针对 16GB RAM 笔记本优化的构建参数

## Quick Start / 快速开始

```bash
# Clone and build
git clone https://github.com/chenzhuyu2004/atlas.git
cd atlas
./build.sh

# Run with GPU
./run.sh

# Start JupyterLab
docker run --gpus all -p 8888:8888 atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```

## Build Tiers / 构建层级

| BUILD_TIER | Content / 内容 | Size / 大小 |
|------------|----------------|-------------|
| 0 (default) | PyTorch + sklearn + pandas + matplotlib | ~22GB |
| 1 | + transformers + bitsandbytes | ~22GB |
| 2 | + vLLM + DeepSpeed (experimental) | ~37GB |

```bash
# Core only (tier 0)
./build.sh

# With LLM support (tier 1)
BUILD_TIER=1 ./build.sh

# With materials science
ENABLE_MATERIALS=1 ./build.sh
```

> **Note**: Tier 2 (vLLM/DeepSpeed) may have compatibility issues with PyTorch 2.10.0. See [docs/BUILD.md](docs/BUILD.md) for details.

## Included Packages / 主要组件

**Core**: numpy, pandas, scipy, scikit-learn, matplotlib, seaborn, jupyterlab

**LLM (Tier 1+)**: transformers, accelerate, datasets, peft, bitsandbytes

**Materials Science**: ase, pymatgen, spglib, phonopy, mace

> For complete package list, see [docs/BUILD.md](docs/BUILD.md)

## Documentation / 文档

- 📖 [构建指南 (Build Guide)](docs/BUILD.md) - 详细构建选项、故障排除、层级说明
- 🚀 [运行指南 (Run Guide)](docs/RUN.md) - 容器运行、GPU 配置、JupyterLab 使用
- 🧪 [测试与 CI (Tests & CI)](docs/TESTS.md) - 测试套件使用、CI 策略、健康检查
- 💡 [示例项目 (Examples)](examples/README.md) - Docker Compose 配置、训练示例

## Contributing / 贡献

欢迎提交 Issue 和 Pull Request！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献指南。

安全漏洞请参考 [SECURITY.md](SECURITY.md) 进行负责任的披露。

## License

MIT - See [LICENSE](LICENSE) for details
