# ATLAS Usage Examples / ATLAS 使用示例

Practical examples for using ATLAS Docker images.
使用 ATLAS Docker 镜像的实用示例。

## Directory Structure / 目录结构

```
examples/
├── README.md                    # This file / 本文件
├── docker-compose/              # Docker Compose examples / Docker Compose 示例
└── training-demo/               # Model training examples / 模型训练示例
```

**Note**: Additional examples (jupyter-notebook, materials-science) are planned for future releases.
**注意**：更多示例（jupyter-notebook、materials-science）计划在未来版本中添加。

## Quick Start / 快速开始

### 1. Interactive Python / 交互式 Python

```bash
docker run --gpus all -it --rm atlas:v0.6-base python
```

```python
import torch
import numpy as np

print(f"PyTorch: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"NumPy: {np.__version__}")
```

### 2. Run a Script / 运行脚本

```bash
docker run --gpus all -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  atlas:v0.6-base \
  python your_script.py
```

### 3. JupyterLab / JupyterLab

```bash
docker run --gpus all -it --rm \
  -p 8888:8888 \
  -v $(pwd):/workspace \
  -w /workspace \
  atlas:v0.6-base \
  jupyter lab --ip=0.0.0.0 --no-browser
```

Then open: http://localhost:8888
然后打开：http://localhost:8888

## Related Docs / 相关文档

- `../docs/README.md` - Repository documentation index / 仓库文档索引
- `../docker/atlas/README.md` - Image quick start / 镜像快速开始
- `../docker/atlas/docs/RUN.md` - Runtime guide / 运行指南

## Examples by Category / 分类示例

### Data Science / 数据科学

Use JupyterLab (see Docker Compose section) for:
使用 JupyterLab（见 Docker Compose 部分）：

- Data analysis with pandas / 使用 pandas 进行数据分析
- Visualization with matplotlib / 使用 matplotlib 可视化
- Machine learning with scikit-learn / 使用 scikit-learn 进行机器学习

### Deep Learning / 深度学习

See [`training-demo/`](training-demo/) for:
查看 [`training-demo/`](training-demo/)：

- Image classification / 图像分类
- Model fine-tuning / 模型微调
- Distributed training / 分布式训练

### LLM / 大语言模型

Requires `BUILD_TIER>=1`:
需要 `BUILD_TIER>=1`：

- Text generation / 文本生成
- Model quantization / 模型量化
- Fine-tuning with PEFT / 使用 PEFT 微调

### Materials Science / 材料科学

Requires `ENABLE_MATERIALS=1`:
需要 `ENABLE_MATERIALS=1`：

Examples (planned for future release):
示例（计划在未来版本中添加）：

- Structure optimization / 结构优化
- Property calculation / 性质计算
- Molecular dynamics / 分子动力学

## Docker Compose / Docker Compose

See [`docker-compose/`](docker-compose/) for:
查看 [`docker-compose/`](docker-compose/)：

- JupyterLab with persistent storage / 带持久化存储的 JupyterLab
- Development environment / 开发环境
- Multi-container setups / 多容器设置

## Tips and Best Practices / 技巧和最佳实践

### Volume Mounting / 挂载卷

```bash
# Mount current directory / 挂载当前目录
-v $(pwd):/workspace

# Mount specific folder / 挂载特定文件夹
-v /path/to/data:/data

# Read-only mount / 只读挂载
-v $(pwd):/workspace:ro
```

### Resource Limits / 资源限制

```bash
# Limit memory / 限制内存
--memory=8g

# Limit CPUs / 限制 CPU
--cpus=4

# Specific GPU / 指定 GPU
--gpus '"device=0"'
```

### Networking / 网络

```bash
# Expose port / 暴露端口
-p 8888:8888

# Custom network / 自定义网络
--network my-network

# No network / 无网络
--network none
```

### Environment Variables / 环境变量

```bash
# Set environment variable / 设置环境变量
-e MY_VAR=value

# Load from file / 从文件加载
--env-file .env

# Jupyter token / Jupyter 令牌
-e JUPYTER_TOKEN=your_token
```

## Troubleshooting / 故障排除

### GPU Not Available / GPU 不可用

```bash
# Check NVIDIA runtime / 检查 NVIDIA 运行时
nvidia-smi

# Test GPU in container / 在容器中测试 GPU
docker run --gpus all --rm atlas:v0.6-base \
  python -c "import torch; print(torch.cuda.is_available())"
```

### Permission Issues / 权限问题

```bash
# Run as current user / 以当前用户运行
--user $(id -u):$(id -g)

# Fix permissions after / 之后修复权限
sudo chown -R $USER:$USER /path/to/workspace
```

### Out of Memory / 内存不足

```bash
# Increase shared memory / 增加共享内存
--shm-size=8g

# Limit memory / 限制内存
--memory=16g
```

## Contributing Examples / 贡献示例

If you have useful examples, please contribute!
如果您有有用的示例，请贡献！

1. Create a new directory / 创建新目录
2. Add README.md explaining the example / 添加 README.md 说明示例
3. Include all necessary files / 包含所有必要文件
4. Test thoroughly / 充分测试
5. Submit a PR / 提交 PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.
详见 [CONTRIBUTING.md](../CONTRIBUTING.md)。
