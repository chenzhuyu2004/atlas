# Role Quick Starts / 角色快速开始

Minimal, runnable commands for common roles.
面向常见角色的最小可运行命令示例。

## User / 使用者

Use the image locally for experiments.
在本地使用镜像进行实验。

```bash
cd /path/to/atlas/docker/atlas
make build
make run
```

Launch JupyterLab (optional).
启动 JupyterLab（可选）。

```bash
cd /path/to/atlas/docker/atlas
make jupyter
```

## Builder/Maintainer / 构建与维护者

Validate and build the image before releasing.
发布前验证并构建镜像。

```bash
cd /path/to/atlas/docker/atlas
make check
make lint
make test
make build
```

## Contributor / 贡献者

Run repository checks before opening a PR.
在提交 PR 前执行仓库检查。

```bash
cd /path/to/atlas
python -m pip install -U pre-commit
pre-commit run --all-files
```

## Troubleshooting / 故障排除

- See [docker/atlas/docs/FAQ.md](../docker/atlas/docs/FAQ.md) for common fixes.

## Related Docs / 相关文档

- [docs/README.md](README.md)
- [docs/WORKFLOWS.md](WORKFLOWS.md)
- [docker/atlas/docs/RUN.md](../docker/atlas/docs/RUN.md)
- [docker/atlas/docs/BUILD.md](../docker/atlas/docs/BUILD.md)
- [docker/atlas/docs/TESTS.md](../docker/atlas/docs/TESTS.md)
