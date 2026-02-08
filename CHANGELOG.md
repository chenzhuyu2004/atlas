# ATLAS Docker Image Changelog
# ATLAS Docker 镜像更新日志

## [0.6] - 2026-02-08 (Stable / 稳定版)

### Build Tiers Completed / 构建层级完成
| Tag / 标签 | Size / 大小 | PyTorch | CUDA | Status / 状态 |
|------------|-------------|---------|------|----------------|
| v0.6-base | 21.7GB | 2.10.0 | 13.0 | Core DS / 核心数据科学 |
| v0.6-llm | 22.3GB | 2.10.0 | 13.0 | + LLM 微调 |
| v0.6-full | 37.3GB | 2.9.1 | 12.8 | + vLLM/DeepSpeed |
| v0.6-materials | 23.2GB | 2.10.0 | 13.0 | + 材料科学 |

### Version Notes / 版本说明
- v0.6 and v0.6-llm: Latest PyTorch 2.10.0 + CUDA 13.0
- v0.6 和 v0.6-llm: 最新 PyTorch 2.10.0 + CUDA 13.0
- v0.6-full: Uses PyTorch 2.9.1 + CUDA 12.8 (vLLM 0.15.1 hard dependency)
- v0.6-full: 使用 PyTorch 2.9.1 + CUDA 12.8 (vLLM 0.15.1 硬性依赖)

### Removed auto-latest tag / 移除自动 latest 标签
- Build script no longer auto-tags as 'latest'
- 构建脚本不再自动打 'latest' 标签

### Version Consolidation / 版本整合
- Consolidated all image tags into single v0.6 release
- 将所有镜像标签整合为单一 v0.6 版本
- Cleaned up old image tags (v0.5-base, stable, latest)
- 清理旧镜像标签 (v0.5-base, stable, latest)

---

## [0.5] - 2026-02-08

### Major Upgrade / 重大升级
Upgraded to PyTorch 2.10.0 + CUDA 13.0, the latest available versions.
升级到 PyTorch 2.10.0 + CUDA 13.0，目前可用的最新版本。

### Base Image / 基础镜像
- **Before / 之前**: `pytorch/pytorch:2.6.0-cuda12.4-cudnn9-devel`
- **After / 之后**: `pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel`

### PEP 668 Compatibility / PEP 668 兼容性
- Added `PIP_BREAK_SYSTEM_PACKAGES=1` environment variable
- 添加 `PIP_BREAK_SYSTEM_PACKAGES=1` 环境变量
- Ubuntu 24.04 base requires this for pip installations
- Ubuntu 24.04 基础镜像需要此设置才能进行 pip 安装

### Package Versions / 包版本
| Package / 包 | Version / 版本 |
|--------------|----------------|
| PyTorch | 2.10.0+cu130 |
| CUDA | 13.0 |
| NumPy | 2.4.2 |
| Pandas | 3.0.0 |
| SciPy | 1.17.0 |
| Polars | 1.38.1 |
| scikit-learn | 1.8.0 |
| matplotlib | 3.10.8 |
| IPython | 9.10.0 |
| JupyterLab | 4.5.3 |
| Pillow | 12.1.0 |
| OpenCV | 4.13.0.92 |
| transformers | 5.1.0 |
| accelerate | 1.12.0 |

### Image Size / 镜像大小
- v0.5-base: 21.7GB (reduced from 22.7GB in v0.4)
- v0.5-base: 21.7GB (从 v0.4 的 22.7GB 缩减)

---

## [0.4] - 2026-02-08 (Experimental / 实验版)

### Major Upgrade - NumPy 2.x Ecosystem
Upgraded to numpy 2.x and its dependent major versions.

### Core Data Science / 核心数据科学
| Package / 包 | Version / 版本 | Upgrade / 升级 |
|--------------|----------------|----------------|
| numpy | 2.4.2 | 1.x → 2.x |
| pandas | 3.0.0 | 2.x → 3.x |
| ipython | 9.10.0 | 8.x → 9.x |
| pillow | 12.1.0 | 11.x → 12.x |
| opencv | 4.13.0.92 | 4.11 → 4.13 |

### LLM Ecosystem / LLM 生态 (BUILD_TIER>=1)
| Package / 包 | Version / 版本 | Upgrade / 升级 |
|--------------|----------------|----------------|
| transformers | 5.1.0 | 4.x → 5.x |
| huggingface_hub | 1.4.1 | 0.x → 1.x |
| datasets | 4.5.0 | 3.x → 4.x |
| accelerate | 1.12.0 | 1.2 → 1.12 |
| peft | 0.18.1 | 0.14 → 0.18 |

---

## [0.3.1] - 2026-02-08

### Dependency Updates (Safe upgrades) / 依赖更新 (安全升级)
- scipy: 1.14.1 → 1.17.0
- polars: 1.15.0 → 1.38.1
- scikit-learn: 1.5.2 → 1.8.0
- jupyterlab: 4.2.5 → 4.5.3
- ipykernel: 6.30.0 → >=6.31.0
- safetensors: 0.5.1 → 0.7.0
- h5py: 3.11.0 → 3.15.1

---

## [0.3] - 2026-02-08

### Major Changes / 重大变更
- **16GB Memory Optimization**: MAX_JOBS=2 prevents OOM
- **Tiered Build**: BUILD_TIER 0/1/2 progressive build
- **File Cleanup**: Removed unused files
- **Unified Naming**: Removed `-slim-` prefix

### Build Tiers / 构建层级
- BUILD_TIER=0: Core Data Science (~8GB)
- BUILD_TIER=1: + LLM Base (~12GB)
- BUILD_TIER=2: + LLM Acceleration (~18GB)
- ENABLE_MATERIALS=1: Materials Science extension

---

## [0.2] - 2026-02-07

### Changes / 变更
- Split dependencies into core and optional stacks
- Added optional Materials Science stack
- Improved build reliability and health checks

---

## [0.1] - 2026-02-07

### Initial Release / 初始版本
- Basic PyTorch + CUDA environment
- Core data science packages
