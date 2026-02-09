# Runtime Guide / 运行指南

Complete guide for running ATLAS Docker containers.

ATLAS Docker 容器的完整运行说明。

> **Note**: Run commands from `docker/atlas/`.
> **Note**: Examples use `v0.6` tags. Replace with `v$(cat VERSION)` (or your current version) when you follow these commands.

## Quick Start / 快速开始

### Using run.sh / 使用运行脚本

最简单的方式是使用项目提供的 `run.sh` 脚本：

```bash
cd /path/to/atlas/docker/atlas
./run.sh
```

脚本会自动：
- 检测是否存在镜像
- 配置 GPU 访问
- 挂载当前目录
- 启动交互式 shell

## Basic Container Operations / 基础容器操作

### Interactive Shell / 交互式终端

```bash
# Basic run / 基础运行
docker run --gpus all -it --rm atlas:v0.6-base

# With workspace mount / 挂载工作目录
docker run --gpus all -it --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    atlas:v0.6-base

# Custom entrypoint / 自定义入口
docker run --gpus all -it --rm atlas:v0.6-base bash
```

### JupyterLab / 启动 JupyterLab

```bash
# Basic JupyterLab / 基础启动
docker run --gpus all -it --rm \
    -p 8888:8888 \
    atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --no-browser

# With workspace and custom port / 自定义端口和工作目录
docker run --gpus all -it --rm \
    -p 8889:8888 \
    -v $(pwd):/workspace \
    -w /workspace \
    atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --no-browser
```

访问 `http://localhost:8888` 并使用终端输出的 token 登录。

### Background Services / 后台服务

```bash
# Run JupyterLab as daemon / 后台运行 JupyterLab
docker run -d --gpus all \
    --name atlas-jupyter \
    -p 8888:8888 \
    -v $(pwd):/workspace \
    atlas:v0.6-base \
    jupyter lab --ip=0.0.0.0 --no-browser

# Check logs / 查看日志
docker logs atlas-jupyter

# Stop and remove / 停止并删除
docker stop atlas-jupyter
docker rm atlas-jupyter
```

## GPU Configuration / GPU 配置

### NVIDIA Runtime / NVIDIA 运行时

ATLAS 镜像需要 NVIDIA Container Toolkit 支持：

```bash
# Check NVIDIA runtime / 检查 NVIDIA 运行时
docker run --gpus all nvidia/cuda:13.0-base-ubuntu22.04 nvidia-smi

# Specify GPU devices / 指定 GPU 设备
docker run --gpus '"device=0"' atlas:v0.6-base  # 仅使用 GPU 0
docker run --gpus 2 atlas:v0.6-base             # 使用前 2 个 GPU
docker run --gpus all atlas:v0.6-base           # 使用所有 GPU
```

### Verify CUDA in Container / 验证容器内 CUDA

```bash
docker run --gpus all atlas:v0.6-base python -c "
import torch
print(f'PyTorch: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
print(f'CUDA version: {torch.version.cuda}')
print(f'Device count: {torch.cuda.device_count()}')
if torch.cuda.is_available():
    print(f'Device name: {torch.cuda.get_device_name(0)}')
"
```

### Troubleshooting GPU Issues / GPU 故障排除

**问题：CUDA not available**

```bash
# 1. Check nvidia-docker installation / 检查 nvidia-docker 安装
docker run --gpus all nvidia/cuda:13.0-base-ubuntu22.04 nvidia-smi

# 2. Check docker daemon config / 检查 docker daemon 配置
cat /etc/docker/daemon.json
# 应包含: "default-runtime": "nvidia"

# 3. Restart docker / 重启 docker
sudo systemctl restart docker
```

**问题：Out of memory (OOM)**

```bash
# Check GPU memory / 检查 GPU 内存
nvidia-smi

# Reduce batch size or model size in your code
# 在代码中减小 batch size 或模型大小
```

## Advanced Usage / 高级使用

### Volume Mounts / 卷挂载

```bash
# Multiple volumes / 多个卷
docker run --gpus all -it --rm \
    -v /data/datasets:/datasets:ro \     # 只读数据集
    -v /data/models:/models \            # 读写模型目录
    -v $(pwd)/outputs:/outputs \         # 输出目录
    -w /workspace \
    atlas:v0.6-base

# Named volume for persistence / 持久化命名卷
docker volume create atlas-cache
docker run --gpus all -it --rm \
    -v atlas-cache:/home/atlas/.cache \
    atlas:v0.6-base
```

### Environment Variables / 环境变量

```bash
# Set HuggingFace cache / 设置 HuggingFace 缓存
docker run --gpus all -it --rm \
    -e HF_HOME=/workspace/.cache/huggingface \
    -v $(pwd):/workspace \
    atlas:v0.6-base

# CUDA environment / CUDA 环境变量
docker run --gpus all -it --rm \
    -e CUDA_VISIBLE_DEVICES=0 \
    -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512 \
    atlas:v0.6-base

# Healthcheck behavior / 健康检查行为
docker run --gpus all -it --rm \
    -e ATLAS_HEALTHCHECK_ENABLED=0 \
    atlas:v0.6-base

docker run --gpus all -it --rm \
    -e ATLAS_HEALTHCHECK_REQUIRE_CUDA=0 \
    atlas:v0.6-base
```

### Docker Compose / 使用 Docker Compose

完整示例请参考 [examples/docker-compose/](../../examples/docker-compose/)：

```bash
cd ../../examples/docker-compose
docker-compose up -d
```

## Container Management Scripts / 容器管理脚本

### run.sh

交互式容器启动脚本：

```bash
./run.sh                      # 启动 v0.6-base (默认)
./run.sh atlas:v0.6-llm       # 指定镜像标签
./run.sh atlas:v0.6-llm myname all  # 完整参数：镜像、容器名、GPU
```

### tag.sh

镜像标签管理：

```bash
# Tag current version / 标记当前版本
./tag.sh tag 1.0.0

# Tag from specific tier / 从特定层级标记
./tag.sh tag 1.0.0 v0.6-llm

# Using Makefile / 使用 Makefile
make tag TAG_VERSION=1.0.0 SOURCE=v0.6-llm
```

### push.sh

推送镜像到注册表：

```bash
# Push to GHCR / 推送到 GitHub Container Registry
./push.sh v0.6-base

# Push with custom registry / 使用自定义注册表
REGISTRY=myregistry.io ./push.sh v0.6-base
```

## Health Check / 健康检查

容器包含内置健康检查机制：

```bash
# Check container health / 检查容器健康状态
docker run -d --name atlas-test atlas:v0.6-base sleep infinity
docker inspect atlas-test | jq '.[0].State.Health'

# Manual health check / 手动健康检查
docker exec atlas-test python -c "
import sys
try:
    import torch
    if not torch.cuda.is_available():
        sys.exit(1)
except ImportError:
    sys.exit(2)
"
echo $?  # 0=OK, 1=CUDA unavailable, 2=import failed
```

**Exit Codes / 退出码**:
- `0`: CUDA available and working / CUDA 可用且正常
- `1`: CUDA unavailable (GPU not visible) / CUDA 不可用（GPU 不可见）
- `2`: torch import failed / torch 导入失败

## Production Deployment / 生产环境部署

### Resource Limits / 资源限制

```bash
# Set memory and CPU limits / 设置内存和 CPU 限制
docker run --gpus all \
    --memory=8g \
    --cpus=4 \
    atlas:v0.6-base
```

### Restart Policies / 重启策略

```bash
# Auto-restart on failure / 失败时自动重启
docker run -d --gpus all \
    --restart=unless-stopped \
    --name atlas-service \
    atlas:v0.6-base \
    python my_service.py
```

### Logging / 日志管理

```bash
# Configure logging driver / 配置日志驱动
docker run -d --gpus all \
    --log-driver=json-file \
    --log-opt max-size=10m \
    --log-opt max-file=3 \
    atlas:v0.6-base
```

## Performance Tips / 性能优化建议

1. **Use SSD for Docker storage** / 使用 SSD 存储 Docker 数据
   ```bash
   # Move docker to SSD / 迁移 docker 到 SSD
   # Edit /etc/docker/daemon.json
   {
     "data-root": "/path/to/ssd/docker"
   }
   ```

2. **Enable BuildKit** / 启用 BuildKit
   ```bash
   export DOCKER_BUILDKIT=1
   ```

3. **Layer Caching** / 层缓存
   - 镜像已经按最优顺序组织层
   - 频繁变化的层放在后面

4. **Shared Memory** / 共享内存
   ```bash
   # Increase shared memory for DataLoader / 增加共享内存用于数据加载
   docker run --gpus all --shm-size=8g atlas:v0.6-base
   ```

## Troubleshooting / 故障排除

### Container Won't Start / 容器无法启动

```bash
# Check logs / 查看日志
docker logs <container-id>

# Run with interactive shell / 使用交互式 shell 运行
docker run --gpus all -it atlas:v0.6-base bash
```

### Permission Issues / 权限问题

```bash
# Run as specific user / 以特定用户运行
docker run --gpus all -it --rm \
    --user $(id -u):$(id -g) \
    -v $(pwd):/workspace \
    atlas:v0.6-base
```

### Network Issues / 网络问题

```bash
# Use host network / 使用 host 网络
docker run --gpus all --network=host atlas:v0.6-base

# Custom DNS / 自定义 DNS
docker run --gpus all --dns=8.8.8.8 atlas:v0.6-base
```

## See Also / 相关文档

- [BUILD.md](BUILD.md) - 构建镜像的详细说明
- [TESTS.md](TESTS.md) - 测试和 CI/CD 流程
- [examples/docker-compose/](../../examples/docker-compose/) - Docker Compose 配置示例
