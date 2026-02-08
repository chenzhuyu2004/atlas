# ==============================================================================
# ATLAS Docker Image v0.6 (Stable)
# ATLAS Docker 镜像 v0.6 (稳定版)
# ==============================================================================
# Optimized for: 13980HX + RTX 4060 Laptop (16GB RAM)
# 针对硬件优化: 13980HX + RTX 4060 笔记本 (16GB 内存)
# 
# Components / 组件:
#   - PyTorch 2.10.0 + CUDA 13.0 + cuDNN 9
#   - NumPy 2.x ecosystem / NumPy 2.x 生态
#   - Full Data Science stack / 完整数据科学栈
# ==============================================================================
# Build Tiers / 构建层级 (BUILD_TIER):
#   0 = base   Core Data Science stack / 核心数据科学栈 (~22GB)
#   1 = llm    + LLM inference support / + LLM 推理支持 (~26GB)
#   2 = full   + Full LLM acceleration / + 完整 LLM 加速 (~32GB)
# 
# Optional / 可选: ENABLE_MATERIALS=1 adds Materials Science / 添加材料科学
# ==============================================================================

FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel

LABEL org.opencontainers.image.title="ATLAS ML/DS" \
      org.opencontainers.image.version="0.6" \
      org.opencontainers.image.description="ML/DS Docker image optimized for RTX 4060 Laptop"

# ==============================================================================
# Environment Variables / 环境变量
# Memory-optimized for 16GB RAM / 针对 16GB 内存优化
# ==============================================================================
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=180 \
    PIP_PREFER_BINARY=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    DEBIAN_FRONTEND=noninteractive \
    CUDA_HOME=/usr/local/cuda \
    TORCH_CUDA_ARCH_LIST="8.9" \
    MAX_JOBS=2 \
    MAKEFLAGS="-j2"

# Build arguments / 构建参数
ARG BUILD_TIER=0
ARG ENABLE_MATERIALS=0

# ==============================================================================
# System Dependencies / 系统依赖 (Minimal)
# ==============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git wget curl ca-certificates \
    pkg-config libssl-dev libffi-dev \
    libopenblas-dev liblapack-dev gfortran \
    cmake ninja-build \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /app

# Upgrade pip toolchain / 升级 pip 工具链
RUN pip install --upgrade pip setuptools wheel

# ==============================================================================
# Layer 0: Core Data Science Stack / 核心数据科学栈
# Packages: numpy, pandas, scipy, scikit-learn, matplotlib, jupyterlab, etc.
# ==============================================================================
COPY requirements.txt ./
RUN echo "=== Installing Core DS Stack / 安装核心数据科学栈 ===" && \
    pip install --no-cache-dir -r requirements.txt && \
    echo "✓ Core stack installed / 核心栈安装完成"

# ==============================================================================
# Layer 1: LLM Base Stack / LLM 基础栈 (BUILD_TIER >= 1)
# Packages: transformers, accelerate, datasets, peft, bitsandbytes
# ==============================================================================
COPY requirements-llm.txt ./
RUN if [ "${BUILD_TIER}" -ge "1" ]; then \
      echo "=== Installing LLM Stack / 安装 LLM 栈 ===" && \
      pip install --no-cache-dir -r requirements-llm.txt && \
      echo "✓ LLM stack installed / LLM 栈安装完成"; \
    else \
      echo "Skipping LLM stack / 跳过 LLM 栈 (BUILD_TIER=${BUILD_TIER})"; \
    fi

# ==============================================================================
# Layer 2: LLM Acceleration Stack / LLM 加速栈 (BUILD_TIER >= 2)
# Packages: vLLM, DeepSpeed (precompiled wheels)
# ==============================================================================
COPY requirements-accel.txt ./
RUN if [ "${BUILD_TIER}" -ge "2" ]; then \
      echo "=== Installing LLM Accel Stack / 安装 LLM 加速栈 ===" && \
      pip install --no-cache-dir -r requirements-accel.txt && \
      echo "✓ LLM accel stack installed / LLM 加速栈安装完成"; \
    else \
      echo "Skipping LLM accel / 跳过 LLM 加速 (BUILD_TIER=${BUILD_TIER})"; \
    fi

# ==============================================================================
# Layer 3: Materials Science Stack / 材料科学栈 (ENABLE_MATERIALS=1)
# Packages: ase, pymatgen, spglib, mendeleev, mp-api
# ==============================================================================
COPY requirements-materials.txt ./
RUN if [ "${ENABLE_MATERIALS}" = "1" ]; then \
      echo "=== Installing Materials Stack / 安装材料科学栈 ===" && \
      pip install --no-cache-dir -r requirements-materials.txt && \
      echo "✓ Materials stack installed / 材料科学栈安装完成"; \
    else \
      echo "Skipping materials / 跳过材料科学 (ENABLE_MATERIALS=0)"; \
    fi

# ==============================================================================
# Validation / 验证安装
# ==============================================================================
RUN echo "=== Validation / 验证 ===" && python -c "\
import torch; \
print(f'PyTorch {torch.__version__}'); \
print(f'  CUDA available: {torch.cuda.is_available()}'); \
import numpy, pandas, scipy, sklearn; \
print('Core DS: OK / 核心数据科学: 正常'); \
" && echo "✓ Core validation passed / 核心验证通过"

# Optional module check / 可选模块检查 (non-blocking)
RUN echo "=== Optional Modules / 可选模块 ===" && \
    python -c "import importlib.util; \
mods = [('transformers', 'Transformers'), ('vllm', 'vLLM'), ('ase', 'ASE'), ('pymatgen', 'Pymatgen')]; \
results = [(n, importlib.util.find_spec(m)) for m, n in mods]; \
[print(f'{n}: installed / 已安装') if spec else print(f'{n}: not installed / 未安装') for n, spec in results]" || \
    echo "(Some optional modules not installed - OK for base tier)"

# Health check / 健康检查
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=2 \
    CMD python -c "import torch; assert torch.cuda.is_available()" || exit 1

CMD ["python"]
