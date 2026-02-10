# Architecture Overview / 架构概览

Image docs index: [docker/atlas/docs/README.md](README.md)
Repo docs index: [docs/README.md](../../../docs/README.md)


This document describes the ATLAS Docker image build system, CI flow, and runtime layout.
本文档描述 ATLAS Docker 镜像的构建系统、CI 流程与运行结构。

## Scope / 范围

- Build system in `docker/atlas/`
- CI/CD workflows in `.github/workflows/`
- Local scripts in `docker/atlas/scripts/`

## High-Level Components / 高层组件

- `Dockerfile`: single build context with a smoke stage for fast CI validation
- `requirements*.txt`: pinned dependency sets for each build tier
- `scripts/`: build/run/tag/push/check helpers
- `tests/`: build, healthcheck, and import validation
- `.github/workflows/`: CI for lint, smoke builds, and release pushes

## Build Architecture / 构建架构

The Dockerfile has two stages:
Dockerfile 包含两个阶段：

1. `smoke` stage: validates `requirements*.txt` syntax without pulling the large base image
2. `full` stage: installs packages based on `BUILD_TIER` and `ENABLE_MATERIALS`

Build tiers:
构建层级：

| Tier | Build Args | Content |
| --- | --- | --- |
| 0 | `BUILD_TIER=0` | Core data science stack |
| 1 | `BUILD_TIER=1` | Adds LLM base packages |
| 2 | `BUILD_TIER=2` | Adds LLM acceleration packages |
| Materials | `ENABLE_MATERIALS=1` | Adds materials science stack |

Key build inputs:
关键输入：

- `VERSION`: labels and tag generation
- `BUILD_TIER`: tier selection (0/1/2)
- `ENABLE_MATERIALS`: materials stack toggle
- `SMOKE_BASE_IMAGE`: lightweight base for CI smoke stage
- `USE_HASHED_REQUIREMENTS`: install `requirements*.lock` when available

## Runtime Architecture / 运行结构

- Default container command is `python`.
- Healthcheck inspects `torch` import and CUDA availability.
- GPU usage is optional; CPU-only usage is supported.

## CI/CD Architecture / CI/CD 架构

- PR/Push: lint + smoke build only (fast feedback)
- Release (tag): build + push base image to GHCR
- Nightly (optional): full build + tests + security scan

## Design Trade-offs / 设计权衡

- CI avoids full image builds on every push to keep runtime short.
- Full validation is done locally or nightly to reduce CI cost.
- Heavy dependency stacks are split into tiers to reduce build failures.
