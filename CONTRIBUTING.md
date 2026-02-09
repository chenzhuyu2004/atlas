# Contributing to ATLAS / 为 ATLAS 做贡献

Docs index: [docs/README.md](docs/README.md)


Welcome! We're excited that you're interested in contributing to ATLAS.
欢迎！我们很高兴您有兴趣为 ATLAS 做贡献。

## Table of Contents / 目录

- [Code of Conduct](#code-of-conduct--行为准则)
- [How Can I Contribute?](#how-can-i-contribute--我能做什么贡献)
- [Development Setup](#development-setup--开发环境设置)
- [Branching Model](#branching-model--分支模型)
- [Testing and CI](#testing-and-ci--测试与ci)
- [Submitting Changes](#submitting-changes--提交更改)
- [Style Guidelines](#style-guidelines--代码规范)
- [Community](#community--社区)

## Code of Conduct / 行为准则

This project adheres to a code of conduct. By participating, you are expected to:
本项目遵守行为准则。参与时，您应该：

- Be respectful and inclusive / 尊重和包容他人
- Welcome newcomers / 欢迎新手
- Focus on what is best for the community / 关注对社区最有利的事
- Show empathy towards others / 对他人表示同理心

## How Can I Contribute? / 我能做什么贡献？

### Reporting Bugs / 报告 Bug

Before creating bug reports, please check existing issues to avoid duplicates.
在创建 bug 报告之前，请检查现有 issue 以避免重复。

When filing a bug report, include:
提交 bug 报告时，请包含：

- **Clear title** / **清晰的标题**
- **Environment** (OS, Docker version, GPU driver) / **环境信息**（操作系统、Docker 版本、GPU 驱动）
- **Steps to reproduce** / **重现步骤**
- **Expected vs actual behavior** / **预期行为 vs 实际行为**
- **Relevant logs** / **相关日志**

Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.yml).
使用 [bug 报告模板](.github/ISSUE_TEMPLATE/bug_report.yml)。

### Suggesting Enhancements / 提出改进建议

Enhancement suggestions are tracked as GitHub issues. When creating one:
改进建议通过 GitHub issue 跟踪。创建时请：

- **Use a clear title** / **使用清晰的标题**
- **Provide detailed description** / **提供详细描述**
- **Explain why this would be useful** / **说明为什么有用**
- **Include examples** / **包含示例**

Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.yml).
使用 [功能请求模板](.github/ISSUE_TEMPLATE/feature_request.yml)。

### Documentation Improvements / 文档改进

Documentation is crucial! You can help by:
文档至关重要！您可以通过以下方式帮助：

- Fixing typos or unclear wording / 修复拼写错误或不清楚的措辞
- Adding examples / 添加示例
- Translating documentation / 翻译文档
- Improving README or guides / 改进 README 或指南

### Code Contributions / 代码贡献

#### Good First Issues / 新手友好问题

Look for issues labeled `good first issue` or `help wanted`.
查找标记为 `good first issue` 或 `help wanted` 的 issue。

#### Areas to Contribute / 贡献领域

- **Bug fixes** / **Bug 修复**
- **Performance improvements** / **性能改进**
- **New package additions** / **添加新包**
- **Testing** / **测试**
- **CI/CD improvements** / **CI/CD 改进**

## Development Setup / 开发环境设置

### Prerequisites / 前置要求

- Docker 20.10+ with BuildKit / Docker 20.10+ 并启用 BuildKit
- Git
- NVIDIA Docker runtime (for GPU support) / NVIDIA Docker 运行时（GPU 支持）
- Basic shell scripting knowledge / 基本 shell 脚本知识

### Local Development / 本地开发

1. **Fork and clone** / **Fork 并克隆**

```bash
git clone https://github.com/YOUR_USERNAME/atlas.git
cd atlas
```

2. **Create a branch** / **创建分支**

```bash
git checkout -b feature/your-feature-name
# or / 或
git checkout -b fix/your-bug-fix
```

3. **Make changes** / **进行更改**

Follow the [style guidelines](#style-guidelines--代码规范) below.
遵循下面的[代码规范](#style-guidelines--代码规范)。

4. **Test locally** / **本地测试**

```bash
# Pre-check / 预检查
./pre-check.sh

# Build and test / 构建和测试
BUILD_TIER=0 ./build.sh

# Run container / 运行容器
./run.sh

# Test scripts / 测试脚本
bash -n *.sh
```

5. **Run linters** / **运行代码检查**

```bash
make lint
# or / 或
pre-commit run --all-files
```

## Branching Model / 分支模型

- `main`: stable, release-ready
- `feature/*`: new features
- `fix/*`: bug fixes
- `docs/*`: documentation changes
- `release/*`: release preparation (optional)

## Testing and CI / 测试与 CI

- CI runs lint and smoke build on every PR/push
- Full build and tests are expected to run locally before release
- Use `docker/atlas/tests/run_all_tests.sh` for full validation
- Install dev dependencies with `docker/atlas/requirements-dev.txt` if you run linters locally

## Submitting Changes / 提交更改

### Pull Request Process / Pull Request 流程

This repository protects `main`. Direct pushes are blocked and changes must go through a PR.
本仓库对 `main` 启用了保护，禁止直接 push，所有更改必须通过 PR 合并。

1. **Update documentation** / **更新文档**
   - Update README.md if you changed features / 如果更改了功能，请更新 README.md
   - Update CHANGELOG.md / 更新 CHANGELOG.md
   - Update docs/BUILD.md if relevant / 如有相关，更新 docs/BUILD.md

2. **Ensure tests pass** / **确保测试通过**
   - All shell scripts validate with `bash -n` / 所有脚本通过 `bash -n` 验证
   - Docker builds successfully / Docker 构建成功
   - Pre-commit hooks pass / Pre-commit hooks 通过

3. **Write clear commit messages** / **编写清晰的提交信息**

```bash
# Good / 好的例子
feat: add support for Python 3.13
fix: correct memory limit in build script
docs: update installation instructions

# Bad / 不好的例子
update stuff
fix bug
changes
```

Follow [Conventional Commits](https://www.conventionalcommits.org/):
遵循 [约定式提交](https://www.conventionalcommits.org/zh-hans/)：

- `feat:` new feature / 新功能
- `fix:` bug fix / bug 修复
- `docs:` documentation / 文档
- `style:` formatting / 格式化
- `refactor:` code restructuring / 代码重构
- `test:` adding tests / 添加测试
- `chore:` maintenance / 维护

4. **Create Pull Request** / **创建 Pull Request**
   - Fill out the PR template / 填写 PR 模板
   - Link related issues / 链接相关 issue
   - Request review / 请求审查

5. **Address review comments** / **处理审查意见**
   - Be responsive to feedback / 及时响应反馈
   - Make requested changes / 进行请求的更改

### Main Branch Workflow / 主分支推送流程

Minimal flow (owner PRs are auto-approved after CI starts):
最简流程（仓库 owner 的 PR 会在 CI 运行后自动审批）：

```bash
git checkout -b feature/short-title
git commit -am "feat: describe change"
git push -u origin feature/short-title
gh pr create --base main --head feature/short-title
# wait for required checks to pass
gh pr merge <PR_NUMBER> --merge
```

Notes:
- Auto-approve only applies to PRs created by the repository owner from the same repo.
- Non-owner PRs still require a human review.

注意：
- 自动审批仅对“同仓库 + 仓库 owner 发起的 PR”生效。
- 非 owner 的 PR 仍需人工 review。
   - Update PR description if scope changes / 如果范围变化，更新 PR 描述

### PR Requirements / PR 要求

- [ ] Code follows style guidelines / 代码遵循规范
- [ ] Self-review completed / 完成自我审查
- [ ] Documentation updated / 文档已更新
- [ ] Tests added/updated / 测试已添加/更新
- [ ] Pre-commit run locally / 已在本地运行 pre-commit
- [ ] CI checks pass / CI 检查通过
- [ ] No merge conflicts / 无合并冲突

## Style Guidelines / 代码规范

### Shell Scripts / Shell 脚本

```bash
#!/usr/bin/env bash
# Use bash shebang / 使用 bash shebang

set -e  # Exit on error / 出错时退出

# Use 2-space indentation / 使用 2 空格缩进
if [ condition ]; then
  command
fi

# Use [[ ]] for conditions / 使用 [[ ]] 进行条件判断
if [[ "${VAR}" == "value" ]]; then
  echo "match"
fi

# Quote variables / 变量加引号
echo "${MY_VAR}"

# Use meaningful variable names / 使用有意义的变量名
IMAGE_NAME="atlas"  # Good / 好
x="atlas"           # Bad / 差
```

### Dockerfile

```dockerfile
# Use specific tags / 使用具体标签
FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel

# One instruction per line / 每行一个指令
RUN apt-get update && \
    apt-get install -y package && \
    rm -rf /var/lib/apt/lists/*

# Group related packages / 分组相关包
# ===== Section Title =====
COPY requirements.txt ./
RUN pip install -r requirements.txt
```

### Python (in requirements files)

```txt
# Pin all versions / 固定所有版本
numpy==2.4.2

# Add comments for context / 添加上下文注释
# ===== Data Processing / 数据处理 =====
pandas==3.0.0

# Group by category / 按类别分组
```

### Documentation

- Use clear, concise language / 使用清晰、简洁的语言
- Provide both English and Chinese / 提供中英文内容
- Include code examples / 包含代码示例
- Keep README.md up-to-date / 保持 README.md 最新

Documentation scope / 文档范围：
- `docs/README.md` is the repository documentation index / 仓库文档索引
- `docker/atlas/docs/` contains image-specific guides / 镜像专用指南
- `examples/README.md` contains usage examples / 使用示例

Documentation update triggers / 文档更新触发点：
- Dockerfile, build args, requirements changes → update `docker/atlas/docs/BUILD.md`
- Runtime, GPU flags, healthcheck changes → update `docker/atlas/docs/RUN.md`
- CI workflows, tests, release steps → update `docker/atlas/docs/TESTS.md` or `CHANGELOG.md`
- Script flags, usage, or defaults → update `docker/atlas/docs/API.md` and `docker/atlas/scripts/README.md`
- New examples → update `examples/README.md`

If documentation does not need updates, state the reason in the PR description.
如果无需更新文档，请在 PR 描述中说明原因。

## Community / 社区

### Getting Help / 获取帮助

- **Questions**: Open a [GitHub Discussion](https://github.com/chenzhuyu2004/atlas/discussions)
  **问题**：开启 [GitHub Discussion](https://github.com/chenzhuyu2004/atlas/discussions)
- **Bugs**: File an [issue](https://github.com/chenzhuyu2004/atlas/issues)
  **Bug**：提交 [issue](https://github.com/chenzhuyu2004/atlas/issues)
- **Chat**: Join discussions in issues and PRs
  **聊天**：在 issue 和 PR 中参与讨论

### Recognition / 致谢

Contributors are recognized in:
贡献者会在以下地方被致谢：

- [CHANGELOG.md](CHANGELOG.md) for significant contributions
  [CHANGELOG.md](CHANGELOG.md) 用于重要贡献
- GitHub contributors page
  GitHub 贡献者页面
- Release notes
  发布说明

## Questions? / 有疑问？

Don't hesitate to ask! Open an issue or discussion if you need clarification.
不要犹豫！如果需要说明，请开启 issue 或 discussion。

---

Thank you for contributing to ATLAS! / 感谢您为 ATLAS 做出贡献！
