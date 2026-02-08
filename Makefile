# ==============================================================================
# ATLAS Makefile
# Simplified build commands / 简化构建命令
# ==============================================================================

# Read version from VERSION file / 从 VERSION 文件读取版本号
VERSION := $(shell cat VERSION 2>/dev/null || echo "0.6")
IMAGE_BASE := atlas:v$(VERSION)-base

.PHONY: help build base llm full materials clean prune run jupyter check

# Default target / 默认目标
help:
	@echo "ATLAS Build Commands / 构建命令"
	@echo "================================"
	@echo "  make build      Build base image (default) / 构建基础镜像"
	@echo "  make base       Same as build / 同上"
	@echo "  make llm        Build LLM image / 构建 LLM 镜像"
	@echo "  make full       Build full image / 构建完整镜像"
	@echo "  make materials  Build materials science image / 构建材料科学镜像"
	@echo ""
	@echo "Run Commands / 运行命令"
	@echo "================================"
	@echo "  make run        Run base container / 运行基础容器"
	@echo "  make jupyter    Start JupyterLab / 启动 JupyterLab"
	@echo ""
	@echo "Utilities / 工具"
	@echo "================================"
	@echo "  make check      Pre-build check / 构建前检查"
	@echo "  make clean      Remove build cache / 清除构建缓存"
	@echo "  make prune      Remove all unused images / 清除所有未使用镜像"
	@echo "  make list       List ATLAS images / 列出 ATLAS 镜像"

# Build targets / 构建目标
build base:
	@BUILD_TIER=0 ./build.sh

llm:
	@BUILD_TIER=1 ./build.sh

full:
	@BUILD_TIER=2 ./build.sh

materials:
	@ENABLE_MATERIALS=1 ./build.sh

# No-cache rebuilds / 禁用缓存重建
rebuild:
	@NO_CACHE=1 BUILD_TIER=0 ./build.sh

rebuild-llm:
	@NO_CACHE=1 BUILD_TIER=1 ./build.sh

rebuild-full:
	@NO_CACHE=1 BUILD_TIER=2 ./build.sh

rebuild-materials:
	@NO_CACHE=1 ENABLE_MATERIALS=1 ./build.sh

# Run targets / 运行目标
run:
	@./run.sh

jupyter:
	@docker run --gpus all -it --rm \
		-p 8888:8888 \
		-v $$(pwd):/workspace \
		-w /workspace \
		$(IMAGE_BASE) \
		jupyter lab --ip=0.0.0.0 --allow-root --no-browser

# Utility targets / 工具目标
check:
	@./pre-check.sh

list:
	@docker images atlas --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

clean:
	@docker builder prune -f
	@echo "Build cache cleaned / 构建缓存已清除"

prune:
	@docker system prune -af
	@echo "System pruned / 系统已清理"
