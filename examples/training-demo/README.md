# PyTorch Training Demo / PyTorch 训练演示

Simple image classification example using CIFAR-10.
使用 CIFAR-10 的简单图像分类示例。

## Requirements / 要求

- ATLAS v0.6-base or higher / ATLAS v0.6-base 或更高版本
- GPU recommended / 推荐使用 GPU

## Quick Start / 快速开始

### Run with Docker / 使用 Docker 运行

```bash
# CPU only / 仅 CPU
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  atlas:v0.6-base \
  python train_cifar10.py

# With GPU / 使用 GPU
docker run --gpus all --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  atlas:v0.6-base \
  python train_cifar10.py
```

### Run Locally / 本地运行

```bash
python train_cifar10.py
```

## Script Details / 脚本详情

The script:
脚本功能：

1. Downloads CIFAR-10 dataset / 下载 CIFAR-10 数据集
2. Trains a simple CNN / 训练简单 CNN
3. Evaluates on test set / 在测试集上评估
4. Saves the model / 保存模型

## Customization / 自定义

Edit `train_cifar10.py` to modify:
编辑 `train_cifar10.py` 修改：

- `EPOCHS`: Number of training epochs / 训练轮数
- `BATCH_SIZE`: Batch size / 批次大小
- `LEARNING_RATE`: Learning rate / 学习率

## Output / 输出

- Trained model: `cifar10_cnn.pth`
- Training logs in console / 控制台中的训练日志
- Test accuracy / 测试准确率

## Expected Results / 预期结果

- Training time: ~5-10 min on GPU / GPU 上约 5-10 分钟
- Test accuracy: ~70% after 10 epochs / 10 轮后准确率约 70%

## Related Docs / 相关文档

- `../README.md` - Examples overview / 示例总览
- `../../docs/README.md` - Repository docs index / 仓库文档索引
- `../../docker/atlas/docs/RUN.md` - Runtime guide / 运行指南
