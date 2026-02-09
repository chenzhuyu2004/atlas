# ATLAS Monorepo

[![CI](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/chenzhuyu2004/atlas/actions/workflows/ci.yml)

This repository contains the ATLAS Docker image build system and a separate project workspace.

## Layout

- `docker/atlas/` - Docker image source, scripts, and docs
- `projects/` - Your development projects (no image source code)

## Quick Start (Docker Image)

```bash
cd docker/atlas
./build.sh
./run.sh
```

For full documentation, see `docker/atlas/README.md`.
