# ATLAS Docker Image Changelog
# ATLAS Docker 镜像更新日志

## Release Checklist / 发布检查清单

Before creating a new release, ensure all items are checked:
在创建新版本前，确保所有项目已检查：

### Pre-release / 发布前
- [ ] All tests pass locally / 本地所有测试通过
  ```bash
  docker/atlas/tests/run_all_tests.sh
  ```
- [ ] Update VERSION file / 更新 VERSION 文件
  ```bash
  echo "0.7" > docker/atlas/VERSION
  ```
- [ ] Update CHANGELOG.md with new version / 更新 CHANGELOG.md 添加新版本
  - Document all changes / 记录所有变更
  - Include version comparison table / 包含版本对比表
- [ ] Run pre-check / 运行预检查
  ```bash
  ./pre-check.sh
  ```
- [ ] Build and test all tiers / 构建并测试所有层级
  ```bash
  ./build.sh && docker run --gpus all --rm atlas:v0.7-base python -c "import torch; print(torch.cuda.is_available())"
  BUILD_TIER=1 ./build.sh && docker run --gpus all --rm atlas:v0.7-llm python -c "import transformers"
  ```
- [ ] Run security scan locally / 本地运行安全扫描
  ```bash
  trivy image atlas:v0.7-base
  ```
- [ ] Update documentation if needed / 如需要更新文档
  - [ ] docker/atlas/README.md - version badges / 版本徽章
  - [ ] docker/atlas/docs/BUILD.md - build instructions / 构建说明
  - [ ] docker/atlas/docs/RUN.md - runtime examples / 运行示例
  - [ ] Update doc version tags / 更新文档版本标签
    ```bash
    make -C docker/atlas docs-ver OLD_VERSION=0.6 NEW_VERSION=0.7
    ```

### Release / 发布
- [ ] Create and push git tag / 创建并推送 git 标签
  ```bash
  git tag -a v0.7.0 -m "Release v0.7.0"
  git push origin v0.7.0
  ```
- [ ] Monitor CI/CD pipeline / 监控 CI/CD 流水线
  - [ ] Release job completes / Release job 完成
  - [ ] Image pushed to GHCR / 镜像推送到 GHCR
  - [ ] Release summary generated / 生成发布摘要
- [ ] Create GitHub Release / 创建 GitHub Release
  - [ ] Copy CHANGELOG entry / 复制 CHANGELOG 条目
  - [ ] Add installation instructions / 添加安装说明
  - [ ] Include image digest / 包含镜像摘要

### Post-release / 发布后
- [ ] Test pull from registry / 测试从注册表拉取
  ```bash
  docker pull ghcr.io/chenzhuyu2004/atlas:v0.7.0
  ```
- [ ] Verify image digest matches / 验证镜像摘要匹配
- [ ] Update project board / 更新项目看板
- [ ] Close related issues / 关闭相关 issue
- [ ] Announce release (optional) / 发布公告（可选）

---

## [Unreleased]

Changelog format: Added / Changed / Fixed / Removed.
变更格式：Added / Changed / Fixed / Removed。

### Added / 新增
- (none)

### Changed / 变更
- (none)

### Fixed / 修复
- (none)

### Removed / 移除
- (none)

## [0.6.1] - 2026-02-08

### Fixed / 修复
- HEALTHCHECK now distinguishes CUDA unavailable (exit 1) from import failure (exit 2)
- 健康检查现在区分 CUDA 不可用 (exit 1) 与 torch 导入失败 (exit 2)
- `tag.sh` simplified default source tag logic (uses `v$(VERSION)-base`)
- `tag.sh` 简化默认源标签逻辑（使用 `v$(VERSION)-base`）
- `make tag` now requires `TAG_VERSION` to avoid accidental tagging
- `make tag` 现在要求 `TAG_VERSION`，避免误打标
- `pre-check.sh` uses a `MIN_DOCKER` variable instead of hard-coded values
- `pre-check.sh` 使用 `MIN_DOCKER` 变量替代硬编码

### Changed / 文档
- Added tagging examples and Makefile wrapper usage
- 增加打标示例与 Makefile 包装用法
- Materials stack version pinning noted in build guide
- 在构建指南中说明材料栈版本锁定

## [0.6] - 2026-02-08 (Stable / 稳定版)

### Added / 新增

Build tiers completed / 构建层级完成:
| Tag / 标签 | Size / 大小 | PyTorch | CUDA | Status / 状态 |
|------------|-------------|---------|------|----------------|
| v0.6-base | 21.7GB | 2.10.0 | 13.0 | Core DS / 核心数据科学 |
| v0.6-llm | 22.3GB | 2.10.0 | 13.0 | + LLM 微调 |
| v0.6-full | 37.3GB | 2.9.1 | 12.8 | + vLLM/DeepSpeed |
| v0.6-materials | 23.2GB | 2.10.0 | 13.0 | + 材料科学 |

### Changed / 变更
- v0.6 and v0.6-llm: Latest PyTorch 2.10.0 + CUDA 13.0
- v0.6 和 v0.6-llm: 最新 PyTorch 2.10.0 + CUDA 13.0
- v0.6-full: Uses PyTorch 2.9.1 + CUDA 12.8 (vLLM 0.15.1 hard dependency)
- v0.6-full: 使用 PyTorch 2.9.1 + CUDA 12.8 (vLLM 0.15.1 硬性依赖)
- Consolidated all image tags into single v0.6 release
- 将所有镜像标签整合为单一 v0.6 版本

### Removed / 移除
- Build script no longer auto-tags as 'latest'
- 构建脚本不再自动打 'latest' 标签
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
