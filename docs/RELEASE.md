# Release Guide / 发布指南

This guide explains the release workflow and CI triggers.
本指南说明发布流程与 CI 触发规则。

## Quick Summary / 快速摘要

- Tagging `vX.Y.Z` triggers the release job.
- Release builds and pushes the base image to GHCR.
- Full validation runs locally or via nightly workflows.

## Release Steps / 发布步骤

1. Update [docker/atlas/VERSION](../docker/atlas/VERSION) and [CHANGELOG.md](../CHANGELOG.md).
2. Run pre-check and local tests.
3. Create and push a tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z" && git push origin vX.Y.Z`.
4. Verify the release job and image push in GitHub Actions.
5. Create a GitHub Release using the latest [CHANGELOG.md](../CHANGELOG.md) entry.

## CI Triggers / CI 触发规则

- **PR/Push**: lint + smoke build
- **Release (tag v*)**: build + push base image
- **Nightly**: full build + tests + security scan (if enabled)

## Notes / 注意事项

- Release jobs do not run full test suites by default.
- Keep [CHANGELOG.md](../CHANGELOG.md) and versioned docs consistent.
- If you change build args or scripts, update related docs.

## Related Docs / 相关文档

- [CHANGELOG.md](../CHANGELOG.md) - Release checklist and history / 发布检查清单与历史
- [docker/atlas/docs/TESTS.md](../docker/atlas/docs/TESTS.md) - Tests and CI overview / 测试与 CI 总览
- [docs/STYLE_GUIDE.md](STYLE_GUIDE.md) - Documentation rules / 文档规范
