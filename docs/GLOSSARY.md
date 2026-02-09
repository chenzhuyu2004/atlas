# ATLAS Glossary / 术语表

Short definitions for common ATLAS terms.
ATLAS 常见术语的简要解释。

## Terms / 术语

| Term / 术语 | Meaning / 含义 |
| --- | --- |
| ATLAS image | Docker image built from `docker/atlas`.
| Build tier | Build level controlled by `BUILD_TIER` (0=base, 1=LLM, 2=full).
| Smoke build | Minimal build used in PR validation to catch basic regressions.
| CI | GitHub Actions workflows that run tests, lint, and security checks.
| Nightly build | Scheduled workflow that runs full checks and uploads reports.
| Release | Tag-driven workflow that publishes images and updates changelog.
| Workspace | Local development area under `projects/` (not part of image build).
| Trivy | Container/image vulnerability scanner used in CI.
| Pre-commit | Local hook runner for formatting and linting before commits.
| Requirements hashes | SHA256 hashes in `requirements*.txt` for reproducible installs.
| Artifact | File uploaded by CI (logs, reports, scan outputs).

## Related Docs / 相关文档

- [docs/README.md](README.md)
- [docs/WORKFLOWS.md](WORKFLOWS.md)
- [docker/atlas/docs/BUILD.md](../docker/atlas/docs/BUILD.md)
- [docker/atlas/docs/TESTS.md](../docker/atlas/docs/TESTS.md)
