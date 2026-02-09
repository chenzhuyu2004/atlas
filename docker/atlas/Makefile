# ==============================================================================
# ATLAS Makefile
# Simplified build commands / 简化构建命令
# ==============================================================================

# Read version from VERSION file / 从 VERSION 文件读取版本号
VERSION := $(shell cat VERSION 2>/dev/null || echo "0.6")
IMAGE_BASE := atlas:v$(VERSION)-base

.PHONY: help build base llm full materials clean prune run jupyter check push updates lint tag format test typecheck sec lint-fast clean-all

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
	@echo "  make updates    Check dependency updates / 检查依赖更新"
	@echo "  make push       Push images to registry / 推送镜像到仓库"
	@echo "  make lint       Run pre-commit hooks / 运行代码检查"
	@echo "  make lint-fast  Only run fast checks (no install) / 仅快速检查"
	@echo "  make format     Format Python/Shell code / 格式化代码"
	@echo "  make test       Run Python tests / 运行 Python 测试"
	@echo "  make typecheck  Run mypy type checks / 类型检查"
	@echo "  make sec        Run bandit security checks / 安全检查"
	@echo "  make clean      Remove build cache / 清除构建缓存"
	@echo "  make clean-all  Remove all containers/images/volumes / 全清理"
	@echo "  make prune      Remove all unused images / 清除所有未使用镜像"
	@echo "  make list       List ATLAS images / 列出 ATLAS 镜像"
	@echo "  make tag        Tag image (TAG_VERSION=1.0.0, SOURCE=v0.6-base) / 镜像打标"
	@echo "  make docs-ver   Update doc version tags / 更新文档版本标签"
# 快速代码格式化
format:
	@black . || true
	@isort . || true
	@shfmt -i 2 -ci -w scripts/*.sh || true

# Python 测试
test:
	@pytest || echo "Install pytest: pip install pytest"

# 类型检查
typecheck:
	@mypy . || echo "Install mypy: pip install mypy"

# 安全检查
sec:
	@bandit -r . || echo "Install bandit: pip install bandit"

# 仅快速lint（不自动安装）
lint-fast:
	@pre-commit run --all-files --show-diff-on-failure || true

# 一键全清理
clean-all:
	@docker system prune -af --volumes
	@echo "All containers/images/volumes removed / 所有容器、镜像、卷已清理"

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

# New tools / 新工具
updates:
	@./check-updates.sh

push:
	@./push.sh

lint:
	@pre-commit run --all-files || echo "Install pre-commit: pip install pre-commit && pre-commit install"

# Tag helper / 打标辅助
tag:
	@if [ -z "$(TAG_VERSION)" ]; then \
		echo "TAG_VERSION is required. Example: make tag TAG_VERSION=1.0.0 SOURCE=v0.6-base"; \
		exit 1; \
	fi
	@./tag.sh tag $(TAG_VERSION) $(SOURCE)

# Update documentation version tags / 更新文档版本标签
docs-ver:
	@if [ -z "$(OLD_VERSION)" ]; then \
		echo "OLD_VERSION is required. Example: make docs-ver OLD_VERSION=0.6"; \
		exit 1; \
	fi
	@./scripts/update-doc-version.sh $(OLD_VERSION) $(NEW_VERSION)
