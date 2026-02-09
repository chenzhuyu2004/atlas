# ATLAS Monorepo

[![CI](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml)

This repository contains the ATLAS Docker image build system and a separate project workspace.

## Layout

- `docker/atlas/` - Docker image source, scripts, and docs
- `examples/` - Usage examples (Docker Compose, training demo)
- `projects/` - Your development projects (no image source code)

## Project Tree

```text
atlas/
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

## Documentation

Recommended reading order:
- `docker/atlas/README.md` - Image overview and quick start
- `docker/atlas/docs/BUILD.md` - Build guide
- `docker/atlas/docs/RUN.md` - Runtime guide
- `docker/atlas/docs/TESTS.md` - Tests and CI
- `docker/atlas/docs/FAQ.md` - Troubleshooting
- `docker/atlas/docs/README.md` - Full documentation index

Other references:
- `CHANGELOG.md` - Release history and checklist
- `CONTRIBUTING.md` - Contribution guidelines
- `SECURITY.md` - Vulnerability disclosure policy

## Release & Upgrade

- Update `docker/atlas/VERSION` and `CHANGELOG.md`
- Run `./pre-check.sh` and local tests (see `docker/atlas/docs/TESTS.md`)
- Tag and push release: `git tag -a vX.Y.Z -m "Release vX.Y.Z" && git push origin vX.Y.Z`
- Use `docker/atlas/tag.sh` to create local image tags when needed

## Quick Start (Docker Image)

```bash
cd docker/atlas
./build.sh
./run.sh
```
