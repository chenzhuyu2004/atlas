# Common Workflows / 常见工作流

Standard workflows for building, validating, and releasing ATLAS.
ATLAS 的构建、验证与发布标准流程。

## Build And Run Locally / 本地构建与运行

1. `cd /path/to/atlas/docker/atlas`
2. `make build`
3. `make run`

## Run Lint And Tests / 代码检查与测试

1. `cd /path/to/atlas`
2. `python -m pip install -U pre-commit`
3. `pre-commit run --all-files`
4. `make -C docker/atlas test`

## Update Dependencies / 依赖更新

1. `cd /path/to/atlas/docker/atlas`
2. `make updates`
3. Review changes in `requirements*.txt` and re-run `make lint`.

## Release Prep / 发布准备

1. Update `docker/atlas/VERSION` and `CHANGELOG.md`.
2. Run `make -C docker/atlas check` and `make -C docker/atlas test`.
3. Follow [docs/RELEASE.md](RELEASE.md) before tagging.

## Security Review / 安全检查

1. Review Trivy results in CI artifacts.
2. Check GitHub Security alerts for dependency updates.
3. Follow [SECURITY.md](../SECURITY.md) for reporting.

## Nightly Build Review / 夜间构建检查

1. Inspect workflow runs in [nightly-build.yml](../.github/workflows/nightly-build.yml).
2. Download archived reports if needed.

## Troubleshooting / 故障排除

- See [docker/atlas/docs/FAQ.md](../docker/atlas/docs/FAQ.md) for common issues.

## Related Docs / 相关文档

- [docs/README.md](README.md)
- [docs/ROLE_QUICKSTARTS.md](ROLE_QUICKSTARTS.md)
- [docs/RELEASE.md](RELEASE.md)
- [docker/atlas/docs/BUILD.md](../docker/atlas/docs/BUILD.md)
- [docker/atlas/docs/TESTS.md](../docker/atlas/docs/TESTS.md)
