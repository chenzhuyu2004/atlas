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
- `GPU_DEVICES`: GPU selection / GPU 选择

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
