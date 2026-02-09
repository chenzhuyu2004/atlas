# ATLAS Monorepo

[![CI](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml)
[![Nightly Build](https://github.com/chenzhuyu2004/atlas/actions/workflows/nightly-build.yml/badge.svg)](https://github.com/chenzhuyu2004/atlas/actions/workflows/nightly-build.yml)
[![Security](https://github.com/chenzhuyu2004/atlas/actions/workflows/security.yml/badge.svg)](https://github.com/chenzhuyu2004/atlas/actions/workflows/security.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-ghcr.io-blue.svg)](https://github.com/chenzhuyu2004/atlas/pkgs/container/atlas)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyTorch 2.10.0](https://img.shields.io/badge/pytorch-2.10.0-ee4c2c.svg)](https://pytorch.org/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

This repository contains the ATLAS Docker image build system and a separate project workspace.

## Table of Contents

- [Quick Start](#quick-start-docker-image)
- [Documentation](#documentation)
- [Repository Layout](#repository-layout)
- [Project Tree](#project-tree)
- [Community](#community)
- [Release & Upgrade](#release--upgrade)

## Quick Start (Docker Image)

```bash
cd docker/atlas
./build.sh
./run.sh
```

## Documentation

Start here: [docs/README.md](docs/README.md) (repository documentation index).
Image docs index: [docker/atlas/docs/README.md](docker/atlas/docs/README.md).

Choose your path:
- **User**: [docker/atlas/README.md](docker/atlas/README.md), [docker/atlas/docs/RUN.md](docker/atlas/docs/RUN.md), [examples/README.md](examples/README.md), [docs/WORKSPACE.md](docs/WORKSPACE.md)
- **Builder/Maintainer**: [docker/atlas/docs/BUILD.md](docker/atlas/docs/BUILD.md), [docker/atlas/docs/TESTS.md](docker/atlas/docs/TESTS.md), [docs/RELEASE.md](docs/RELEASE.md), [SECURITY.md](SECURITY.md)
- **Contributor**: [CONTRIBUTING.md](CONTRIBUTING.md), [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), [SUPPORT.md](SUPPORT.md)

Role quick starts: [docs/ROLE_QUICKSTARTS.md](docs/ROLE_QUICKSTARTS.md)
Common workflows: [docs/WORKFLOWS.md](docs/WORKFLOWS.md)
Glossary: [docs/GLOSSARY.md](docs/GLOSSARY.md)

Core guides:
- [docker/atlas/README.md](docker/atlas/README.md) - Image overview and quick start
- [docker/atlas/docs/BUILD.md](docker/atlas/docs/BUILD.md) - Build guide
- [docker/atlas/docs/RUN.md](docker/atlas/docs/RUN.md) - Runtime guide
- [docker/atlas/docs/TESTS.md](docker/atlas/docs/TESTS.md) - Tests and CI
- [docker/atlas/docs/FAQ.md](docker/atlas/docs/FAQ.md) - Troubleshooting

Other references:
- [CHANGELOG.md](CHANGELOG.md) - Release history and checklist
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [SECURITY.md](SECURITY.md) - Vulnerability disclosure policy
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - Community guidelines
- [SUPPORT.md](SUPPORT.md) - How to get help
- [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md) - Documentation structure and maintenance
- [docs/WORKSPACE.md](docs/WORKSPACE.md) - Local workspace usage
- [docs/RELEASE.md](docs/RELEASE.md) - Release workflow and CI triggers
- [docs/ROLE_QUICKSTARTS.md](docs/ROLE_QUICKSTARTS.md) - Runnable commands per role
- [docs/WORKFLOWS.md](docs/WORKFLOWS.md) - Common workflows
- [docs/GLOSSARY.md](docs/GLOSSARY.md) - Glossary of terms

## Repository Layout

- `docker/atlas/` - Docker image source, scripts, and docs
- `docs/` - Repository-level documentation index
- `examples/` - Usage examples (Docker Compose, training demo)
- `projects/` - Your development projects (no image source code)

## Project Tree

```text
atlas/
├── docs/                      # Repo-level docs index
├── docker/
│   └── atlas/                 # Image build context
│       ├── Dockerfile
│       ├── requirements*.txt
│       ├── scripts/
│       ├── docs/
│       └── tests/
├── examples/                  # Usage examples
├── projects/                  # Local development projects
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
└── README.md
```

## Community

- 💬 [Discussions](https://github.com/chenzhuyu2004/atlas/discussions) - Ask questions, share ideas
- 🐛 [Issues](https://github.com/chenzhuyu2004/atlas/issues) - Report bugs, request features
- 📖 [Wiki](https://github.com/chenzhuyu2004/atlas/wiki) - Community guides and tips
- 🔒 [Security](https://github.com/chenzhuyu2004/atlas/security) - Report vulnerabilities

## Release & Upgrade

- Update [docker/atlas/VERSION](docker/atlas/VERSION) and [CHANGELOG.md](CHANGELOG.md)
- Run `./pre-check.sh` and local tests (see [docker/atlas/docs/TESTS.md](docker/atlas/docs/TESTS.md))
- Tag and push release: `git tag -a vX.Y.Z -m "Release vX.Y.Z" && git push origin vX.Y.Z`
- Use [docker/atlas/tag.sh](docker/atlas/tag.sh) to create local image tags when needed
