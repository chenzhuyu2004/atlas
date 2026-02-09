# Third-Party Notices / 第三方声明

ATLAS Docker Image includes or depends on third-party software components.

ATLAS Docker 镜像包含或依赖第三方软件组件。

## License Summary / 许可证摘要

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE)。

The following third-party components are included or used by this project and are subject to their respective licenses:

以下第三方组件被本项目包含或使用，受其各自许可证约束：

---

## Core Dependencies / 核心依赖

### Base Image / 基础镜像
- **PyTorch Official Docker Image**
  - Image: pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel
  - License: BSD-3-Clause (PyTorch) + NVIDIA Software License (CUDA)
  - Source: https://hub.docker.com/r/pytorch/pytorch
  - Usage: Base container with PyTorch 2.10.0, CUDA 13.0, cuDNN 9
  - Includes: Python 3.12.3, Ubuntu 22.04, CUDA Toolkit

### Python Runtime / Python 运行时
- **Python 3.12.3**
  - License: PSF License (Python Software Foundation)
  - Source: https://www.python.org/
  - Usage: Core programming language runtime (included in base image)

---

## Machine Learning Frameworks / 机器学习框架

### PyTorch Ecosystem
- **PyTorch 2.10.0**
  - License: BSD-3-Clause
  - Source: https://github.com/pytorch/pytorch
  - Usage: Deep learning framework
  - Copyright: Meta Platforms, Inc. and affiliates

- **torchvision**
  - License: BSD-3-Clause
  - Source: https://github.com/pytorch/vision
  - Usage: Computer vision tools

- **torchaudio**
  - License: BSD-2-Clause
  - Source: https://github.com/pytorch/audio
  - Usage: Audio processing utilities

### Hugging Face (Tier 1+)
- **transformers**
  - License: Apache-2.0
  - Source: https://github.com/huggingface/transformers
  - Usage: Pre-trained model library

- **accelerate**
  - License: Apache-2.0
  - Source: https://github.com/huggingface/accelerate
  - Usage: Distributed training utilities

- **datasets**
  - License: Apache-2.0
  - Source: https://github.com/huggingface/datasets
  - Usage: Dataset management

- **peft**
  - License: Apache-2.0
  - Source: https://github.com/huggingface/peft
  - Usage: Parameter-efficient fine-tuning

- **bitsandbytes**
  - License: MIT
  - Source: https://github.com/TimDettmers/bitsandbytes
  - Usage: 8-bit optimizers and quantization

---

## Scientific Computing / 科学计算

### NumPy Stack
- **NumPy**
  - License: BSD-3-Clause
  - Source: https://github.com/numpy/numpy
  - Usage: Numerical computing foundation

- **SciPy**
  - License: BSD-3-Clause
  - Source: https://github.com/scipy/scipy
  - Usage: Scientific computing algorithms

- **pandas**
  - License: BSD-3-Clause
  - Source: https://github.com/pandas-dev/pandas
  - Usage: Data manipulation and analysis

### Machine Learning
- **scikit-learn**
  - License: BSD-3-Clause
  - Source: https://github.com/scikit-learn/scikit-learn
  - Usage: Traditional machine learning algorithms

---

## Visualization / 可视化

- **matplotlib**
  - License: PSF-based (Matplotlib License)
  - Source: https://github.com/matplotlib/matplotlib
  - Usage: Plotting and visualization

- **seaborn**
  - License: BSD-3-Clause
  - Source: https://github.com/mwaskom/seaborn
  - Usage: Statistical data visualization

---

## Development Tools / 开发工具

- **JupyterLab**
  - License: BSD-3-Clause
  - Source: https://github.com/jupyterlab/jupyterlab
  - Usage: Interactive development environment

- **IPython**
  - License: BSD-3-Clause
  - Source: https://github.com/ipython/ipython
  - Usage: Enhanced interactive Python shell

---

## Materials Science (Optional) / 材料科学（可选）

- **ASE (Atomic Simulation Environment)**
  - License: LGPL-2.1
  - Source: https://gitlab.com/ase/ase
  - Usage: Atomic structure manipulation

- **pymatgen**
  - License: MIT
  - Source: https://github.com/materialsproject/pymatgen
  - Usage: Materials analysis

- **spglib**
  - License: BSD-3-Clause
  - Source: https://github.com/spglib/spglib
  - Usage: Space group operations

- **phonopy**
  - License: BSD-3-Clause
  - Source: https://github.com/phonopy/phonopy
  - Usage: Phonon calculations

- **mace-torch**
  - License: MIT
  - Source: https://github.com/ACEsuit/mace
  - Usage: Machine learning interatomic potentials

---

## Build and CI Tools / 构建和 CI 工具

- **Docker**
  - License: Apache-2.0
  - Source: https://github.com/docker
  - Usage: Container platform

- **hadolint**
  - License: GPL-3.0
  - Source: https://github.com/hadolint/hadolint
  - Usage: Dockerfile linting

- **Trivy**
  - License: Apache-2.0
  - Source: https://github.com/aquasecurity/trivy
  - Usage: Container security scanning

---

## Full Dependency List / 完整依赖列表

For the complete list of dependencies with exact versions, see:

完整的带版本号的依赖列表，请查看：

- [docker/atlas/requirements.txt](docker/atlas/requirements.txt) - Core tier 0 / 核心层级 0
- [docker/atlas/requirements-llm.txt](docker/atlas/requirements-llm.txt) - LLM tier 1 / LLM 层级 1
- [docker/atlas/requirements-accel.txt](docker/atlas/requirements-accel.txt) - Acceleration tier 2 / 加速层级 2
- [docker/atlas/requirements-materials.txt](docker/atlas/requirements-materials.txt) - Materials science / 材料科学

---

## License Compatibility / 许可证兼容性

This project (MIT License) is compatible with and properly acknowledges all included dependencies:

本项目（MIT 许可证）与所有包含的依赖兼容并妥善声明：

- ✅ **Permissive licenses** (MIT, BSD, Apache-2.0, PSF): Fully compatible
- ✅ **LGPL-2.1** (ASE): Dynamic linking, no distribution restrictions for containers
- ✅ **GPL-3.0** (hadolint): Build-time only, not distributed in image

**宽松许可证**（MIT、BSD、Apache-2.0、PSF）：完全兼容
**LGPL-2.1**（ASE）：动态链接，容器分发无限制
**GPL-3.0**（hadolint）：仅构建时使用，不包含在镜像中

---

## Updates / 更新

This notice file should be updated when:

以下情况需要更新本声明文件：

1. Adding new major dependencies / 添加新的主要依赖
2. Changing base images / 更改基础镜像
3. Updating to versions with license changes / 更新到许可证变更的版本

Last updated: 2026-02-09
最后更新：2026-02-09

> **维护提示**: 本文件中的版本信息来自 Dockerfile 中声明的 base image (`pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel`) 和 requirements*.txt。当基础镜像或依赖包更新时，需同步更新此文件以保持一致。
>
> **Maintenance note**: Version information is based on the base image declared in Dockerfile and packages in requirements*.txt. When updating the base image or dependencies, this file must be synchronized to maintain accuracy.

---

## Disclaimer / 免责声明

This notice file is provided for informational purposes. Users are responsible for ensuring compliance with all applicable licenses when using or distributing this software.

本声明文件仅供参考。用户有责任在使用或分发本软件时确保遵守所有适用的许可证。

For the most up-to-date license information, refer to the official repositories of each component.

最新的许可证信息，请参考各组件的官方仓库。
