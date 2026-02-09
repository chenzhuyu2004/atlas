# Docker Compose Examples / Docker Compose 示例

Docker Compose configurations for ATLAS.
ATLAS 的 Docker Compose 配置。

## Quick Start / 快速开始

```bash
# Start JupyterLab / 启动 JupyterLab
docker-compose up jupyter

# Start development environment / 启动开发环境
docker-compose up dev

# Stop all / 停止所有
docker-compose down
```

## Available Services / 可用服务

### 1. JupyterLab

```bash
docker-compose up jupyter
```

- Access at: http://localhost:8888
- Token: `atlas` (changeable in .env)
- Persistent notebook storage in `./notebooks`

### 2. Development Environment / 开发环境

```bash
docker-compose up dev
```

- Interactive shell / 交互式 shell
- Mounted workspace / 挂载工作目录
- GPU access / GPU 访问

## Configuration / 配置

Copy `.env.example` to `.env` and customize:
复制 `.env.example` 到 `.env` 并自定义：

```bash
cp .env.example .env
```

Key variables / 关键变量：
- `ATLAS_IMAGE`: Image tag to use / 使用的镜像标签
- `JUPYTER_PORT`: JupyterLab port / JupyterLab 端口
- `JUPYTER_TOKEN`: Access token / 访问令牌
- `GPU_COUNT`: GPU count or `all` / GPU 数量或 `all`

## Custom Setups / 自定义设置

### Add More Services / 添加更多服务

Edit `docker-compose.yml` to add services like:
编辑 `docker-compose.yml` 添加服务，例如：

- TensorBoard
- MLflow
- Database containers

### Network Configuration / 网络配置

Services share a network for inter-container communication.
服务共享网络以便容器间通信。

## Troubleshooting / 故障排除

### Port Already in Use / 端口已被占用

Change `JUPYTER_PORT` in `.env`
在 `.env` 中更改 `JUPYTER_PORT`

### GPU Not Working / GPU 不工作

Ensure NVIDIA Docker runtime is installed and configured.
确保已安装和配置 NVIDIA Docker 运行时。

**Configuration / 配置方式**:
- The compose file uses both `runtime: nvidia` and `deploy.resources` for maximum compatibility
- 配置文件同时使用 `runtime: nvidia` 和 `deploy.resources` 以获得最大兼容性
- `runtime: nvidia` works with standalone docker-compose / `runtime: nvidia` 适用于独立 docker-compose
- `deploy.resources` works with Docker Swarm / `deploy.resources` 适用于 Docker Swarm
- For specific GPU IDs, edit `device_ids` manually in `docker-compose.yml`
- 如需指定 GPU ID，请手动在 `docker-compose.yml` 中设置 `device_ids`

**Verification / 验证**:
```bash
# Check GPU is accessible / 检查 GPU 是否可访问
docker-compose run --rm dev nvidia-smi
```

## Related Docs / 相关文档

- `../README.md` - Examples overview / 示例总览
- `../../docs/README.md` - Repository docs index / 仓库文档索引
- `../../docker/atlas/docs/RUN.md` - Runtime guide / 运行指南
