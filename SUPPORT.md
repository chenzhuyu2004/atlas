# Support / 支持

Docs index: [docs/README.md](docs/README.md)


Thank you for using ATLAS! This document explains how to get help and support.

感谢您使用 ATLAS！本文档说明如何获取帮助和支持。

## Getting Help / 获取帮助

### 1. Documentation / 文档

Before asking for help, please check our comprehensive documentation:

在寻求帮助之前，请查看我们的综合文档：

- **[README](README.md)** - Project overview and quick start / 项目概述和快速入门
- **[Build Guide](docker/atlas/docs/BUILD.md)** - Build instructions / 构建说明
- **[Run Guide](docker/atlas/docs/RUN.md)** - Usage instructions / 使用说明
- **[FAQ](docker/atlas/docs/FAQ.md)** - Frequently asked questions / 常见问题解答
- **[Architecture](docker/atlas/docs/ARCHITECTURE.md)** - System design / 系统设计
- **[API Reference](docker/atlas/docs/API.md)** - API documentation / API 文档

### 2. GitHub Discussions / GitHub 讨论区

For questions, ideas, and general discussions:

对于问题、想法和一般讨论：

💬 **[GitHub Discussions](https://github.com/chenzhuyu2004/atlas/discussions)**

Categories / 分类:
- **Q&A** - Ask questions / 提问
- **Ideas** - Share suggestions / 分享建议
- **Show and Tell** - Share your work / 分享您的作品
- **General** - Other discussions / 其他讨论

### 3. Issue Tracker / 问题跟踪

For bug reports and feature requests:

对于 bug 报告和功能请求：

🐛 **[Issue Tracker](https://github.com/chenzhuyu2004/atlas/issues)**

- **Bug Report** - Report bugs or issues / 报告 bug 或问题
- **Feature Request** - Suggest new features / 建议新功能

Please search existing issues before creating a new one!

请在创建新 issue 之前搜索现有的 issues！

### 4. Security Issues / 安全问题

For security vulnerabilities, please report privately:

对于安全漏洞，请私下报告：

🔒 **[Security Advisories](https://github.com/chenzhuyu2004/atlas/security/advisories/new)**

See [SECURITY.md](SECURITY.md) for our security policy.

查看 [SECURITY.md](SECURITY.md) 了解我们的安全政策。

## Response Time / 响应时间

We're a community-driven project and response times may vary:

我们是一个社区驱动的项目，响应时间可能有所不同：

| Type / 类型 | Expected Response / 预期响应时间 |
|-------------|--------------------------------|
| Questions / 问题 | 1-3 days / 1-3 天 |
| Bug reports / Bug 报告 | 1-7 days / 1-7 天 |
| Feature requests / 功能请求 | 1-14 days / 1-14 天 |
| Security issues / 安全问题 | 24-48 hours / 24-48 小时 |

## What to Include When Asking for Help / 寻求帮助时应包含的内容

To help us help you faster, please provide:

为了帮助我们更快地帮助您，请提供：

1. **Environment / 环境信息**:
   - Operating System / 操作系统 (e.g., Ubuntu 24.04, WSL2)
   - Docker version / Docker 版本
   - GPU model / GPU 型号 (if applicable / 如果适用)
   - Image tag / 镜像标签 (e.g., v0.6-base)

2. **Steps to Reproduce / 复现步骤**:
   - What commands did you run? / 您运行了什么命令？
   - What did you expect to happen? / 您期望发生什么？
   - What actually happened? / 实际发生了什么？

3. **Error Messages / 错误信息**:
   - Copy and paste complete error messages / 复制并粘贴完整的错误信息
   - Include relevant logs / 包含相关日志

4. **What You've Tried / 您尝试过什么**:
   - Have you read the documentation? / 您阅读过文档吗？
   - Have you searched existing issues? / 您搜索过现有的 issues 吗？
   - What troubleshooting steps have you taken? / 您采取了哪些故障排除步骤？

## Self-Help Resources / 自助资源

### Common Issues / 常见问题

1. **CUDA not available / CUDA 不可用**
   - Check driver version: `nvidia-smi` / 检查驱动版本
   - Ensure Docker has GPU access / 确保 Docker 有 GPU 访问权限
   - See [FAQ](docker/atlas/docs/FAQ.md#cuda-issues) / 查看常见问题解答

2. **Build fails / 构建失败**
   - Check available disk space / 检查可用磁盘空间
   - Review build logs for specific errors / 查看构建日志的具体错误
   - Try with `make build` first / 先尝试 `make build`

3. **Out of memory / 内存不足**
   - Use lighter tier (BUILD_TIER=0) / 使用较轻的层级
   - Reduce MAX_JOBS / 减少 MAX_JOBS
   - Close other applications / 关闭其他应用程序

### Useful Commands / 有用的命令

```bash
# Check system info / 检查系统信息
docker --version
nvidia-smi
df -h  # Disk space / 磁盘空间

# View container logs / 查看容器日志
docker logs <container-name>

# Check running containers / 检查运行中的容器
docker ps -a

# Clean up / 清理
make clean  # Remove images / 删除镜像
docker system prune -a  # Full cleanup / 完全清理
```

## Contributing / 贡献

Want to help improve ATLAS? See our [Contributing Guide](CONTRIBUTING.md)!

想帮助改进 ATLAS？请查看我们的[贡献指南](CONTRIBUTING.md)！

## Community Guidelines / 社区准则

Please follow our [Code of Conduct](CODE_OF_CONDUCT.md) when interacting with the community.

在与社区互动时，请遵守我们的[行为准则](CODE_OF_CONDUCT.md)。

## Contact / 联系方式

- **Maintainer / 维护者**: [@chenzhuyu2004](https://github.com/chenzhuyu2004)
- **Project**: [https://github.com/chenzhuyu2004/atlas](https://github.com/chenzhuyu2004/atlas)

---

Thank you for being part of the ATLAS community! 🚀

感谢您成为 ATLAS 社区的一员！🚀
