# ATLAS Documentation Style Guide / 文档规范

This guide defines structure, tone, and maintenance rules for ATLAS documentation.
本指南定义 ATLAS 文档的结构、语气和维护规范。

## Goals / 目标

- Make docs easy to navigate and keep consistent.
- Reduce drift between docs and code.
- Provide predictable sections and examples.

## Scope / 范围

- Repo-level docs: [docs/README.md](README.md), [README.md](../README.md), [CONTRIBUTING.md](../CONTRIBUTING.md), [CHANGELOG.md](../CHANGELOG.md)
- Repo references: [docs/WORKFLOWS.md](WORKFLOWS.md), [docs/ROLE_QUICKSTARTS.md](ROLE_QUICKSTARTS.md), [docs/GLOSSARY.md](GLOSSARY.md)
- Image docs: [docker/atlas/docs/README.md](../docker/atlas/docs/README.md), [docker/atlas/README.md](../docker/atlas/README.md)
- Examples: [examples/README.md](../examples/README.md)

## Required Structure / 必备结构

Every guide should follow this minimum structure:
每个指南至少包含以下结构：

1. **Title** / 标题
2. **Short purpose** / 简短用途说明（1-2 行）
3. **Quick start or minimal example** / 最小示例（可选但推荐）
4. **Details** / 详细说明（分节）
5. **Troubleshooting or FAQ link** / 故障排查或 FAQ 链接
6. **Related docs** / 相关文档链接

## Writing Rules / 写作规范

- Use concise, action-focused sentences.
- Keep English and Chinese side-by-side where possible.
- Prefer absolute paths in examples (`/path/to/atlas`) unless context is clear.
- Prefer links for file references when possible (e.g. `[docs/README.md](README.md)`).
- Use consistent terminology (e.g. “build tier”, “smoke build”, “release job”).
- Avoid duplicated content; link instead.

## Example Template / 示例模板

```md
# Title / 标题

One-sentence purpose.
一句话用途说明。

## Quick Start / 快速开始

```bash
# minimal working example
```

## Usage / 用法

- Key option 1
- Key option 2

## Troubleshooting / 故障排除

- Common issue → solution

## Related Docs / 相关文档

- `docs/README.md`
- `docker/atlas/docs/README.md`
```

## Update Triggers / 更新触发点

- Dockerfile, build args, requirements → update [docker/atlas/docs/BUILD.md](../docker/atlas/docs/BUILD.md)
- Runtime, GPU flags, healthcheck → update [docker/atlas/docs/RUN.md](../docker/atlas/docs/RUN.md)
- CI workflows, tests, release steps → update [docker/atlas/docs/TESTS.md](../docker/atlas/docs/TESTS.md) or [CHANGELOG.md](../CHANGELOG.md)
- Scripts or flags → update [docker/atlas/docs/API.md](../docker/atlas/docs/API.md) and [docker/atlas/scripts/README.md](../docker/atlas/scripts/README.md)
- Examples or demos → update [examples/README.md](../examples/README.md)

## Versioning / 版本同步

- Keep versioned docs aligned with [docker/atlas/VERSION](../docker/atlas/VERSION).
- When bumping versions, run:
  - `make -C docker/atlas docs-ver OLD_VERSION=0.6 NEW_VERSION=0.7`

## Review Checklist / 文档检查清单

- [ ] Purpose is clear in first paragraph.
- [ ] Quick start works and is minimal.
- [ ] Links resolve relative to file location.
- [ ] Related docs section exists.
- [ ] Terms and version numbers are consistent.
