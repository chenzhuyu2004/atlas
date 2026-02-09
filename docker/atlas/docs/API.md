# Interfaces & Configuration / 接口与配置

Image docs index: [docker/atlas/docs/README.md](README.md)
Repo docs index: [docs/README.md](../../../docs/README.md)


This document lists user-facing interfaces: scripts, environment variables, and container defaults.
本文档列出用户可见的接口：脚本、环境变量与容器默认行为。

## Script Interfaces / 脚本接口

All scripts are located in `docker/atlas/`. Root-level scripts are wrappers.
脚本位于 `docker/atlas/`，根目录脚本是封装。

- `build.sh`: build the image
- `run.sh`: run a container interactively
- `pre-check.sh`: preflight checks
- `tag.sh`: tag or inspect images
- `push.sh`: push images to registry
- `check-updates.sh`: check dependency updates
- `scripts/update-doc-version.sh`: update version strings in docs

## Environment Variables / 环境变量

Build-time:
构建阶段：

- `IMAGE_NAME`: image name (default: `atlas`)
- `BUILD_TIER`: 0, 1, 2 (default: 0)
- `ENABLE_MATERIALS`: 0 or 1 (default: 0)
- `NO_CACHE`: 1 to disable build cache
- `VERSION`: used for tagging and labels

Runtime:
运行阶段：

- `GPU_DEVICE`: GPU selector used by `run.sh`
- `CONTAINER_NAME`: container name used by `run.sh`

## Container Defaults / 容器默认行为

- Default command: `python`
- Healthcheck: validates `torch` import and CUDA availability
- Exposed port: none by default (JupyterLab uses 8888 when enabled)

## Related Docs / 相关文档

- [docs/BUILD.md](BUILD.md)
- [docs/RUN.md](RUN.md)
- [docs/TESTS.md](TESTS.md)
