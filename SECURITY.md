# Security Policy / 安全策略

## Supported Versions / 支持的版本

We currently provide security updates for the following versions:
我们目前为以下版本提供安全更新：

| Version / 版本 | Supported / 支持状态 |
|----------------|----------------------|
| 0.6.x          | ✅ Active support / 活跃支持 |
| 0.5.x          | ⚠️ Limited support / 有限支持 |
| < 0.5          | ❌ Not supported / 不再支持 |

## Reporting a Vulnerability / 报告漏洞

We take the security of ATLAS seriously. If you discover a security vulnerability, please follow these steps:
我们非常重视 ATLAS 的安全性。如果您发现安全漏洞，请遵循以下步骤：

### 1. Do Not Disclose Publicly / 不要公开披露

Please **do not** create a public GitHub issue for security vulnerabilities.
请**不要**为安全漏洞创建公开的 GitHub issue。

### 2. Report Privately / 私下报告

Send a detailed report to the repository owner via GitHub Security Advisories:
通过 GitHub Security Advisories 向仓库所有者发送详细报告：

1. Go to the [Security tab](https://github.com/chenzhuyu2004/atlas/security)
2. Click "Report a vulnerability" / 点击 "Report a vulnerability"
3. Provide details about the vulnerability / 提供漏洞详情

Alternatively, you can open a confidential issue for security inquiries.
或者，您可以为安全询问开启一个保密 issue。

### 3. What to Include / 应包含的内容

Please include the following information in your report:
请在报告中包含以下信息：

- Description of the vulnerability / 漏洞描述
- Steps to reproduce the issue / 重现步骤
- Potential impact / 潜在影响
- Suggested fix (if any) / 建议的修复方法（如有）
- Your contact information / 您的联系方式

### 4. Response Timeline / 响应时间表

- **Initial Response / 初步响应**: Within 48 hours / 48小时内
- **Status Update / 状态更新**: Within 7 days / 7天内
- **Fix Timeline / 修复时间**: Depends on severity, typically 14-30 days / 取决于严重程度，通常14-30天

## Security Best Practices / 安全最佳实践

When using ATLAS Docker images:
使用 ATLAS Docker 镜像时：

### Container Security / 容器安全

- **Run as Non-Root User / 以非 root 用户运行**: Add a non-root user in your derived images
  在派生镜像中添加非 root 用户
- **Limit Capabilities / 限制权限**: Use `--cap-drop=ALL` and only add required capabilities
  使用 `--cap-drop=ALL` 并仅添加所需权限
- **Read-Only Filesystem / 只读文件系统**: Mount root filesystem as read-only where possible
  在可能的情况下将根文件系统挂载为只读
- **Resource Limits / 资源限制**: Set memory and CPU limits
  设置内存和 CPU 限制

```bash
# Example secure run / 安全运行示例
docker run --gpus all \
  --user 1000:1000 \
  --cap-drop=ALL \
  --read-only \
  --tmpfs /tmp \
  --memory=8g \
  --cpus=4 \
  -v $(pwd):/workspace:ro \
  atlas:v0.6-base
```

### Network Security / 网络安全

- **Disable Network / 禁用网络**: Use `--network=none` if network is not needed
  如果不需要网络，使用 `--network=none`
- **Restrict Ports / 限制端口**: Only expose necessary ports
  仅暴露必要的端口
- **Use Firewall Rules / 使用防火墙规则**: Implement proper firewall rules
  实施适当的防火墙规则

### Secret Management / 密钥管理

- **Never Hardcode Secrets / 永不硬编码密钥**: Use environment variables or secret management tools
  使用环境变量或密钥管理工具
- **Use Docker Secrets / 使用 Docker Secrets**: For Docker Swarm deployments
  用于 Docker Swarm 部署
- **Rotate Credentials / 轮换凭证**: Regularly rotate API keys and tokens
  定期轮换 API 密钥和令牌

### Supply Chain Security / 供应链安全

- **Verify Image Integrity / 验证镜像完整性**: Check image digests
  检查镜像摘要
- **Scan for Vulnerabilities / 扫描漏洞**: Use tools like Trivy or Snyk
  使用 Trivy 或 Snyk 等工具
- **Pin Dependencies / 固定依赖**: All Python packages are pinned in requirements files
  所有 Python 包在 requirements 文件中已固定版本

## Dependency and Image Scanning / 依赖与镜像扫描

We recommend running vulnerability scans before release:
建议在发布前运行漏洞扫描：

```bash
# Container image scan / 容器镜像扫描
trivy image atlas:v0.6-base

# Python dependency scan (optional) / Python 依赖扫描（可选）
pip install pip-audit
pip-audit -r docker/atlas/requirements.txt
```

## CVE Tracking / CVE 追踪

We track CVEs and dependency alerts via:
我们通过以下方式追踪 CVE 和依赖告警：

- GitHub Security tab (Dependabot alerts) / GitHub 安全中心（Dependabot 告警）
- Weekly security workflow (`.github/workflows/security.yml`) / 每周安全扫描工作流
- Nightly Trivy image scans (`nightly-build.yml`) / 夜间 Trivy 镜像扫描

If you see a CVE alert, please open a tracking issue or security advisory.
如发现 CVE 告警，请提交跟踪 issue 或安全通告。

## Known Issues / 已知问题

### CVEs in Base Image / 基础镜像中的 CVE

We base on official `pytorch/pytorch` images. Any CVEs in the base image should be reported to:
我们基于官方 `pytorch/pytorch` 镜像。基础镜像中的任何 CVE 应报告至：
- PyTorch: https://github.com/pytorch/pytorch/security

### vLLM Compatibility / vLLM 兼容性

- BUILD_TIER=2 currently has compatibility issues with PyTorch 2.10.0
- BUILD_TIER=2 当前与 PyTorch 2.10.0 存在兼容性问题
- See [README.md](README.md#build-tiers--构建层级) for details
  详见 [README.md](README.md#build-tiers--构建层级)

## Security Updates / 安全更新

Security patches will be released as soon as possible after verification:
安全补丁将在验证后尽快发布：

- **Critical / 严重**: Within 24-48 hours / 24-48小时内
- **High / 高危**: Within 7 days / 7天内
- **Medium / 中危**: Within 30 days / 30天内
- **Low / 低危**: Next regular release / 下次常规发布

Updates will be announced via:
更新将通过以下方式公告：
- GitHub Security Advisories
- Release notes in [CHANGELOG.md](CHANGELOG.md)
- GitHub Releases

## Acknowledgments / 致谢

We appreciate the security community's efforts in making ATLAS more secure. Security researchers who responsibly disclose vulnerabilities will be acknowledged (with permission) in our release notes.
我们感谢安全社区为使 ATLAS 更加安全所做的努力。负责任地披露漏洞的安全研究人员将（经许可）在我们的发布说明中得到致谢。

---

Last Updated / 最后更新: 2026-02-09
