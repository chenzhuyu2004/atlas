# Testing & CI/CD / 测试与持续集成

Image docs index: [docker/atlas/docs/README.md](README.md)
Repo docs index: [docs/README.md](../../../docs/README.md)


> **Note**: Run commands from `docker/atlas/`.

Complete guide for ATLAS testing infrastructure and CI/CD workflows.

ATLAS 测试基础设施和 CI/CD 工作流的完整说明。

## Test Suite Overview / 测试套件概览

ATLAS 项目包含多层测试体系：

| Test Type / 测试类型 | Location / 位置 | Purpose / 用途 |
|---------------------|-----------------|---------------|
| Package Import Tests | `tests/test_import_packages.py` | 验证所有声明的包可以正常导入 |
| Health Check Tests | `tests/test_healthcheck.sh` | 验证容器健康检查机制 |
| Docker Build Tests | `tests/test_docker_build.sh` | 测试镜像构建流程 |
| End-to-End Tests | `tests/test_e2e.sh` | 端到端运行与挂载验证 |
| Security Scans | CI/CD | Trivy 容器安全扫描 |
| Static Analysis | CI/CD | bash -n (syntax), hadolint |

## Running Tests Locally / 本地运行测试

### Prerequisites / 前置条件

```bash
cd /path/to/atlas/docker/atlas

# Ensure image is built / 确保镜像已构建
./build.sh

# Or use tier 1 / 或使用 tier 1
BUILD_TIER=1 ./build.sh
```

For local linting and unit tests, install dev dependencies:
本地 lint 和单元测试请安装开发依赖：

```bash
pip install -r requirements-dev.txt
```

### Minimal Local Validation / 最小本地验证

Run a fast sanity check before the full suite:
在运行完整测试前先执行快速验证：

```bash
cd /path/to/atlas/docker/atlas
./build.sh

cd tests
docker run --rm -v "$(pwd)":/workspace -w /workspace atlas:v0.6-base \
  python test_import_packages.py
./test_healthcheck.sh
```

### Run All Tests / 运行所有测试

```bash
# Run complete test suite / 运行完整测试套件
cd tests
./run_all_tests.sh
```

### Individual Test Scripts / 单独运行测试脚本

#### 1. Package Import Tests / 包导入测试

验证所有声明的 Python 包可以成功导入：

```bash
cd tests

# Test specific tier / 测试特定层级
docker run --rm -v "$(pwd)":/workspace -w /workspace \
  atlas:v0.6-base python test_import_packages.py
docker run --rm -v "$(pwd)":/workspace -w /workspace \
  atlas:v0.6-llm python test_import_packages.py

# Test with GPU check / 带 GPU 检查测试
docker run --gpus all --rm -v "$(pwd)":/workspace -w /workspace \
  atlas:v0.6-base python test_import_packages.py
```

**检测内容**：
- 核心包：numpy, pandas, torch, sklearn, matplotlib 等
- LLM 包（tier 1+）：transformers, bitsandbytes, accelerate 等
- 材料科学包：ase, pymatgen, spglib 等
- GPU 可用性：torch.cuda.is_available()

#### 2. Health Check Tests / 健康检查测试

测试 Docker HEALTHCHECK 机制：

```bash
cd tests
./test_healthcheck.sh
```

**测试场景**：
- 容器启动后健康检查返回 0（CUDA 可用）
- 无 GPU 时健康检查返回 1（CUDA 不可用）
- 容器正常停止和清理

#### 3. End-to-End Tests / 端到端测试

验证容器启动与挂载读写是否正常：

```bash
cd tests
./test_e2e.sh
```

**测试内容**：
- 容器可启动并执行 Python 命令
- 工作目录挂载可读写
- JupyterLab 包可导入

#### 4. Docker Build Tests / 镜像构建测试

验证不同层级的构建流程：

```bash
cd tests
./test_docker_build.sh
```

**测试内容**：
- Tier 0 基础构建
- Tier 1 LLM 构建
- 材料科学变体构建
- 构建缓存效率

### Unit Tests / 单元测试

```bash
# Run Python unit tests / 运行 Python 单元测试
python -m pytest tests/

# With coverage / 带覆盖率
python -m pytest --cov=. tests/
```

## CI/CD Workflows / CI/CD 工作流

### Workflow Strategy / 工作流策略

ATLAS 采用**轻量级 CI 策略**，针对大型 Docker 镜像优化：

```
┌─────────────────┬──────────────────┬─────────────────┐
│  PR/Push (Fast) │  Release (Tag)   │  Nightly        │
├─────────────────┼──────────────────┼─────────────────┤
│ ✅ shellcheck    │ ✅ Build tier 0   │ ✅ Build tier 0  │
│ ✅ bash -n       │ ✅ Push to GHCR   │ ✅ Build tier 1  │
│ ✅ hadolint      │ ~10 minutes      │ ✅ Full tests    │
│ ✅ smoke build   │                  │ ✅ Security scan │
│ ✅ requirements  │ (构建+推送)      │                 │
│ ✅ syntax check  │                  │ ✅ Push nightly  │
│ ~2 minutes      │                  │ ~30 minutes     │
│ (lint + smoke)  │                  │                 │
└─────────────────┴──────────────────┴─────────────────┘
```

> **重要**：
> - **PR/Push**: 仅运行 lint 检查（shellcheck、bash -n、hadolint 等静态分析）
> - **Release (tag)**: 构建 tier 0 镜像并推送到 GHCR，**不运行测试**
> - **Nightly**: 完整构建（tier 0+1）、测试套件、安全扫描（如已配置）

### 1. CI Workflow / 持续集成工作流

**File**: `../../.github/workflows/ci.yml`

#### Lint Job / 语法检查任务

在每次 PR/push 时运行，提供快速反馈（**不构建大镜像**，只做轻量 smoke build）：

```yaml
triggers:
  - pull_request
  - push to main

checks:
  - bash -n: *.sh (shell script syntax)
  - hadolint: Dockerfile
  - smoke build: docker build --target smoke
  - validate: requirements*.txt
  - syntax: Python unit tests
```

**运行时间**: ~1 分钟
**范围**: 静态检查 + 轻量 smoke build，不进行大镜像构建、包测试或安全扫描

#### Release Job / 发布任务

**仅在打 tag 时触发**（如 `v0.7.0`），执行镜像构建和发布：

```yaml
triggers:
  - tags: v*

steps:
  1. Clean up disk space (~12GB freed)
  2. Set up Docker Buildx
  3. Login to GHCR
  4. Build tier 0 image
  5. Push to GHCR
  6. Output release summary (version, digest, pull commands)
```

**运行时间**: ~10 分钟
**范围**: 镜像构建和推送（不包含测试和安全扫描）

> **注意**: Release job 专注于快速发布。完整测试应在 release 前本地运行，安全扫描在 nightly build 中执行。

### 2. Nightly Build Workflow / 定时构建工作流

**File**: `../../.github/workflows/nightly-build.yml` (如已配置)

每晚定期运行完整构建和测试（需配置）：

```yaml
schedule:
  - cron: '0 2 * * *'  # 示例：02:00 UTC

matrix:
  tier: [0, 1]  # Tier 2 excluded due to vLLM compatibility

steps:
  1. Clean up disk space
  2. Build tier 0 and tier 1
  3. Run package import tests
  4. Run health check tests
  5. Security scan (Trivy)
  6. Push nightly tags to GHCR
```

**运行时间**: ~30 分钟
**状态**: 如需完整 CI（测试+安全扫描），建议配置 nightly workflow

**手动触发**：
```bash
# Via GitHub CLI / 通过 GitHub CLI
gh workflow run nightly-build.yml

# Via GitHub UI / 通过 GitHub UI
# Actions → Nightly Build → Run workflow
```

### 3. Dependabot / 依赖更新

**File**: `.github/dependabot.yml`

自动检测依赖更新并创建 PR：

- **GitHub Actions**: 每周检查一次
- **Python packages**: 每周检查一次（requirements*.txt）

**处理 Dependabot PR**：
```bash
# List Dependabot PRs / 查看 Dependabot PR
gh pr list --author app/dependabot

# Rebase if conflicts / 有冲突时 rebase
gh pr comment <PR-number> --body "@dependabot rebase"

# Auto-merge low-risk updates / 自动合并低风险更新
gh pr review <PR-number> --approve
gh pr merge <PR-number> --auto --squash
```

## Security Scanning / 安全扫描

### Trivy Container Scanning / Trivy 容器扫描

可以对构建的镜像进行 Trivy 安全扫描（手动或在 nightly build 中自动执行）：

```bash
# Manual scan / 手动扫描
trivy image atlas:v0.6-base

# Scan with specific severity / 按严重程度扫描
trivy image --severity HIGH,CRITICAL atlas:v0.6-base

# Output to SARIF for GitHub / 输出 SARIF 格式给 GitHub
trivy image --format sarif --output trivy-results.sarif atlas:v0.6-base
```

> **注意**: Release job 不包含自动安全扫描。建议在本地运行 Trivy 或配置 nightly workflow 进行定期扫描。

### Vulnerability Management / 漏洞管理

- **HIGH/CRITICAL**: 在下一个版本修复
- **MEDIUM**: 定期审查和更新
- **LOW**: 记录并监控

查看安全报告：**Security → Code scanning alerts**

## Health Check Mechanism / 健康检查机制

### Docker HEALTHCHECK / Docker 健康检查

镜像内置健康检查命令：

```dockerfile
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=2 \
  CMD python -c "import os, sys, importlib.util; \
enabled = os.getenv('ATLAS_HEALTHCHECK_ENABLED','1').lower() not in ('0','false','no','off'); \
if not enabled: \
    print('Healthcheck disabled'); \
    sys.exit(0); \
require_cuda = os.getenv('ATLAS_HEALTHCHECK_REQUIRE_CUDA','1').lower() not in ('0','false','no','off'); \
spec = importlib.util.find_spec('torch'); \
if spec is None: \
    print('Torch import failed: module not found'); \
    sys.exit(2); \
import torch; \
ok = torch.cuda.is_available(); \
print(f'PyTorch {torch.__version__}, CUDA: {ok}'); \
sys.exit(0 if (ok or not require_cuda) else 1)"
```

**Exit Codes / 退出码**：
- `0`: CUDA available / CUDA 可用
- `1`: CUDA unavailable (when required) / CUDA 不可用（且要求 CUDA）
- `2`: torch import failed / torch 导入失败

**Environment Overrides / 环境变量覆盖**：
- `ATLAS_HEALTHCHECK_ENABLED=0`: disable health check / 禁用健康检查
- `ATLAS_HEALTHCHECK_REQUIRE_CUDA=0`: allow CPU-only / 允许 CPU-only

### Testing Health Check / 测试健康检查

```bash
# Start container with health check / 启动带健康检查的容器
docker run -d --name test-health --gpus all atlas:v0.6-base sleep infinity

# Wait for health check / 等待健康检查
sleep 35

# Check health status / 检查健康状态
docker inspect test-health | jq '.[0].State.Health.Status'
# Expected: "healthy"

# View health check logs / 查看健康检查日志
docker inspect test-health | jq '.[0].State.Health.Log'

# Clean up / 清理
docker stop test-health
docker rm test-health
```

## Branch Protection / 分支保护

Main 分支配置了分支保护规则（enforce_admins=false 允许管理员绕过）：

```json
{
  "required_checks": ["lint"],
  "strict_mode": true,
  "enforce_admins": false,
  "force_push_allowed": false,
  "deletion_allowed": false
}
```

> **Note**: 由于 `enforce_admins=false`，管理员可以在紧急情况下绕过检查直接推送。
> 这在个人项目中很有用，但团队协作时建议设为 `true`。

**要求**：
- 所有 PR 必须通过 `lint` 检查
- PR 必须基于最新的 main 分支（strict mode）
- 禁止强制推送和删除 main 分支

## Troubleshooting CI Issues / CI 故障排除

### Issue: No space left on device / 磁盘空间不足

CI 工作流已包含磁盘清理步骤：

```bash
# Free up ~12GB / 释放约 12GB
rm -rf /usr/share/dotnet
rm -rf /usr/local/lib/android
rm -rf /opt/ghc
sudo apt-get clean
```

如果仍然失败，考虑：
- 减小镜像层数
- 使用多阶段构建
- 使用自托管 runner

### Issue: Test timeouts / 测试超时

```bash
# Increase timeout in workflow / 增加工作流超时
timeout-minutes: 60  # Default is 360
```

### Issue: Flaky tests / 不稳定测试

```bash
# Run tests multiple times / 多次运行测试
for i in {1..5}; do
  echo "Run $i"
  ./tests/test_healthcheck.sh || exit 1
done
```

### Issue: GitHub Actions cache / GitHub Actions 缓存

```bash
# Clear cache via gh CLI / 通过 gh CLI 清除缓存
gh cache list
gh cache delete <cache-id>
```

## Performance Metrics / 性能指标

### CI Performance Targets / CI 性能目标

| Metric / 指标 | Target / 目标 | Current / 当前 |
|--------------|--------------|---------------|
| Lint job | < 2 min | ~1 min ✅ |
| Build tier 0 | < 20 min | ~15 min ✅ |
| Build tier 1 | < 25 min | ~18 min ✅ |
| Full tests | < 5 min | ~3 min ✅ |
| Nightly total | < 40 min | ~30 min ✅ |

### Test Coverage / 测试覆盖率

当前测试覆盖：
- ✅ 包导入验证（100+ packages）
- ✅ 健康检查机制
- ✅ 容器启动和停止
- ✅ GPU 可用性检测
- ✅ 安全漏洞扫描
- 🚧 集成测试（计划中）
- 🚧 性能基准测试（计划中）

## Best Practices / 最佳实践

### For Contributors / 贡献者

1. **本地运行测试** - 提交 PR 前运行 `./tests/run_all_tests.sh`
2. **遵循命名规范** - 测试文件命名为 `test_*.py` 或 `test_*.sh`
3. **添加测试** - 新功能必须包含对应测试
4. **更新文档** - CI 变更需同步更新此文档

### For Maintainers / 维护者

1. **监控 nightly builds** - 每天检查 nightly 构建状态
2. **及时处理 Dependabot** - 每周审查依赖更新 PR
3. **安全漏洞响应** - HIGH/CRITICAL 漏洞 48 小时内响应
4. **性能监控** - CI 时间超过目标值需优化

## See Also / 相关文档

- [CONTRIBUTING.md](../../../CONTRIBUTING.md) - 贡献指南（包括测试要求）
- [SECURITY.md](../../../SECURITY.md) - 安全策略和漏洞报告流程
- [tests/README.md](../tests/README.md) - 测试套件详细说明
- [GitHub Actions Workflows](../../../.github/workflows/) - 工作流源文件
