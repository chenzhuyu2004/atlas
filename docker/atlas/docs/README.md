# ATLAS Documentation / 文档中心

Complete documentation for the ATLAS Docker Image project.
ATLAS Docker 镜像项目的完整文档。

## Table of Contents / 目录

### [BUILD.md](BUILD.md) - 构建指南
- 构建选项与环境变量
- 构建层级 (tier 0/1/2)
- 材料科学工具包集成
- 常见构建问题与故障排除

### [RUN.md](RUN.md) - 运行指南
- Docker 运行参数与 GPU 配置
- JupyterLab 启动与端口映射
- 工作目录挂载与权限管理
- 健康检查机制说明

### [TESTS.md](TESTS.md) - 测试与 CI
- 本地测试套件使用
- CI/CD 工作流策略
- 健康检查与包导入测试
- 安全扫描说明

### [FAQ.md](FAQ.md) - 常见问题
- 构建问题（OOM、磁盘空间、vLLM 兼容性）
- 运行时问题（CUDA 不可用、权限错误）
- CI/CD 问题排查

### [ARCHITECTURE.md](ARCHITECTURE.md) - 架构概览
- 构建与运行结构
- CI 流程与权衡

### [API.md](API.md) - 接口与配置
- 脚本接口
- 环境变量
- 容器默认行为

## Other Resources / 其他资源

- [CHANGELOG.md](../../CHANGELOG.md) - 版本历史和变更记录
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - 贡献指南和开发规范
- [SECURITY.md](../../SECURITY.md) - 安全策略和漏洞报告
- [THIRD_PARTY_NOTICES.md](../../THIRD_PARTY_NOTICES.md) - 第三方组件许可声明
- [examples/](../../examples/) - 示例项目和配置模板

## Quick Links / 快速链接

- GitHub Repository: https://github.com/chenzhuyu2004/atlas
- CI/CD Status: https://github.com/chenzhuyu2004/atlas/actions
- Container Registry: https://github.com/chenzhuyu2004/atlas/pkgs/container/atlas

## Document Maintenance / 文档维护

文档更新原则：
- README.md 保持简洁，仅包含核心信息和快速开始
- docs/ 目录存放详细技术文档
- examples/ 包含可运行的示例代码和配置
- 变更同步：更新功能时必须同步更新相关文档

如发现文档过时或错误，请提交 Issue 或 PR。
