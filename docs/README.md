# ATLAS Documentation / 文档中心

Complete documentation for the ATLAS Docker Image project.

ATLAS Docker 镜像项目的完整文档。

## Table of Contents / 目录

### 🔨 [BUILD.md](BUILD.md) - 构建指南
**Build Guide / 构建详细说明**

- 完整构建选项和环境变量
- 三层构建系统详解 (tier 0/1/2)
- 材料科学工具包集成
- 常见构建问题与故障排除
- 硬件要求和内存优化
- 包版本说明和兼容性

**适用场景**: 需要自定义构建、故障排除、了解镜像层级差异

---

### 🚀 [RUN.md](RUN.md) - 运行指南
**Runtime Guide / 容器运行详解**

- Docker 运行参数和 GPU 配置
- JupyterLab 启动和端口映射
- 工作目录挂载和权限管理
- 健康检查机制说明
- 容器管理脚本使用 (run.sh, tag.sh, push.sh)
- 生产环境部署建议

**适用场景**: 日常使用镜像、配置 GPU、部署应用

---

### 🧪 [TESTS.md](TESTS.md) - 测试与 CI
**Testing & CI/CD / 测试和持续集成**

- 本地测试套件使用
- CI/CD 工作流策略
- 健康检查和包导入测试
- 安全扫描 (Trivy)
- Dependabot 配置
- 手动触发 nightly 构建

**适用场景**: 贡献代码、了解测试覆盖、调试 CI 问题

---

## Other Resources / 其他资源

- 📜 [CHANGELOG.md](../CHANGELOG.md) - 版本历史和变更记录
- 🤝 [CONTRIBUTING.md](../CONTRIBUTING.md) - 贡献指南和开发规范
- 🔒 [SECURITY.md](../SECURITY.md) - 安全策略和漏洞报告
- 💡 [examples/](../examples/) - 示例项目和配置模板

## Quick Links / 快速链接

- [GitHub Repository](https://github.com/chenzhuyu2004/atlas)
- [CI/CD Status](https://github.com/chenzhuyu2004/atlas/actions)
- [Container Registry](https://github.com/chenzhuyu2004/atlas/pkgs/container/atlas)

## Document Maintenance / 文档维护

文档更新原则：
- README.md 保持简洁，仅包含核心信息和快速开始
- docs/ 目录存放详细技术文档
- examples/ 包含可运行的示例代码和配置
- 变更同步：更新功能时必须同步更新相关文档

如发现文档过时或错误，请提交 Issue 或 PR。
