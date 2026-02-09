# ATLAS Documentation Index / 文档索引

This index covers repository-level documentation and routes you to image-specific guides.
此索引涵盖仓库级文档，并指向镜像相关的详细指南。

## Start Here / 从这里开始

Choose the path that matches your goal:
根据目标选择阅读路径：

- **Use the image quickly** / **快速使用镜像**: `README.md`, `docker/atlas/README.md`
- **Build or customize the image** / **构建或定制镜像**: `docker/atlas/docs/BUILD.md`, `docker/atlas/docs/RUN.md`
- **Understand CI and tests** / **理解 CI 与测试**: `docker/atlas/docs/TESTS.md`, `docker/atlas/docs/ARCHITECTURE.md`
- **Contribute or maintain** / **贡献或维护**: `CONTRIBUTING.md`, `CHANGELOG.md`, `SECURITY.md`

## Documentation Map / 文档地图

| Document / 文档 | Audience / 面向对象 | Scope / 说明 |
| --- | --- | --- |
| `README.md` | All users | Monorepo overview and entry links |
| `docker/atlas/README.md` | Image users | Docker image features and quick start |
| `docker/atlas/docs/README.md` | Image users | Full image documentation index |
| `docker/atlas/docs/BUILD.md` | Builders | Build tiers, args, and troubleshooting |
| `docker/atlas/docs/RUN.md` | Runtime users | GPU runtime, Jupyter, mounts |
| `docker/atlas/docs/TESTS.md` | Maintainers | Tests, CI strategy, validation |
| `docker/atlas/docs/FAQ.md` | All users | Common issues and fixes |
| `docker/atlas/docs/ARCHITECTURE.md` | Maintainers | Build + CI architecture |
| `docker/atlas/docs/API.md` | Maintainers | Scripts and env variable reference |
| `examples/README.md` | Users | Usage examples and demos |
| `CONTRIBUTING.md` | Contributors | PR rules, workflow, quality gates |
| `CHANGELOG.md` | Maintainers | Release checklist and history |
| `SECURITY.md` | Maintainers | Vulnerability policy and handling |
| `SUPPORT.md` | Users | Where to get help |

## Repository Doc Layout / 文档目录结构

```text
atlas/
├── README.md
├── docs/                         # Repo-level documentation index
├── docker/
│   └── atlas/
│       ├── README.md             # Image quick start
│       ├── docs/                 # Image documentation
│       ├── scripts/README.md
│       └── tests/README.md
├── examples/README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
└── SECURITY.md
```

## Documentation Maintenance / 文档维护

Update docs when you change behavior, interfaces, or workflows.
当行为、接口或流程发生变化时必须更新文档。

**Update triggers / 更新触发点**
- Dockerfile, build args, or requirements changes → `docker/atlas/docs/BUILD.md`
- Runtime behavior, GPU flags, healthcheck changes → `docker/atlas/docs/RUN.md`
- CI workflows, tests, or release steps → `docker/atlas/docs/TESTS.md` or `CHANGELOG.md`
- Script flags or usage changes → `docker/atlas/docs/API.md` and `docker/atlas/scripts/README.md`
- New examples → `examples/README.md`

**Versioned docs / 版本化文档**
- Update `docker/atlas/VERSION` and `CHANGELOG.md` before release.
- Update docs version tags when bumping versions: `make -C docker/atlas docs-ver OLD_VERSION=0.6 NEW_VERSION=0.7`

If a change does not require documentation updates, mention it explicitly in the PR description.
如无需更新文档，请在 PR 描述中明确说明原因。
