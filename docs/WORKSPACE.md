# Workspace Guide / 工作区指南

How to use [projects/](../projects/README.md) as your local development workspace without touching image source.
如何使用 `projects/` 作为本地开发工作区，而不影响镜像源码。

## Quick Start / 快速开始

```bash
# 1) Create a project directory
mkdir -p projects/my-app

# 2) Start a container and mount it to /workspace
docker run --gpus all -it --rm \
  -v $(pwd)/projects/my-app:/workspace \
  -w /workspace \
  atlas:v0.6-base \
  bash
```

## Recommended Layout / 推荐结构

```text
projects/
└── my-app/
    ├── README.md
    ├── .gitignore
    ├── src/
    └── data/
```

## Best Practices / 最佳实践

- Keep project code isolated under `projects/`.
- Add a project-level `.gitignore` for datasets and checkpoints.
- Avoid editing `docker/atlas/` when you only need runtime usage.
- Use `--user $(id -u):$(id -g)` if you hit permission issues.

## Common Tasks / 常见任务

1. **Run a script** / 运行脚本

```bash
docker run --gpus all -it --rm \
  -v $(pwd)/projects/my-app:/workspace \
  -w /workspace \
  atlas:v0.6-base \
  python src/train.py
```

2. **Launch JupyterLab** / 启动 JupyterLab

```bash
docker run --gpus all -it --rm \
  -p 8888:8888 \
  -v $(pwd)/projects/my-app:/workspace \
  -w /workspace \
  atlas:v0.6-base \
  jupyter lab --ip=0.0.0.0 --no-browser
```

## Related Docs / 相关文档

- [docs/README.md](README.md) - Repository docs index / 仓库文档索引
- [docker/atlas/docs/RUN.md](../docker/atlas/docs/RUN.md) - Runtime guide / 运行指南
- [examples/README.md](../examples/README.md) - Usage examples / 使用示例
