# FAQ / 常见问题

Common questions and solutions for ATLAS Docker Image.

ATLAS Docker 镜像的常见问题与解决方案。

## 📦 Build Issues / 构建问题

### Q: Build fails with "No space left on device"
### 问：构建失败，提示"磁盘空间不足"

**A**: Docker 镜像构建需要大量临时空间。

```bash
# Clean up Docker / 清理 Docker
docker system prune -a --volumes

# Check available space / 检查可用空间
df -h /var/lib/docker

# Free up at least 50GB for full build / 至少释放 50GB 用于完整构建
```

---

### Q: Build fails with OOM (Out of Memory)
### 问：构建时内存不足（OOM）

**A**: 16GB RAM 笔记本构建优化：

```bash
# Option 1: Reduce parallelism / 选项 1：降低并发
MAX_JOBS=1 ./build.sh

# Option 2: Build tier by tier / 选项 2：分层构建
./build.sh                    # tier 0 first
BUILD_TIER=1 ./build.sh       # then tier 1

# Option 3: Close other apps / 选项 3：关闭其他应用
# Close browsers, IDEs, etc. / 关闭浏览器、IDE 等
```

---

### Q: vLLM/DeepSpeed (BUILD_TIER=2) build fails
### 问：vLLM/DeepSpeed（BUILD_TIER=2）构建失败

**A**: **Known Issue** / **已知问题**

vLLM 0.15.1 requires PyTorch 2.9.1 + CUDA 12.8, but ATLAS uses PyTorch 2.10.0 + CUDA 13.0.

vLLM 0.15.1 需要 PyTorch 2.9.1 + CUDA 12.8，但 ATLAS 使用 PyTorch 2.10.0 + CUDA 13.0。

**Workaround / 解决方法**:
```bash
# Use tier 1 instead (includes transformers + bitsandbytes)
# 使用 tier 1（包含 transformers + bitsandbytes）
BUILD_TIER=1 ./build.sh

# For vLLM support, wait for vLLM to support PyTorch 2.10
# 需要 vLLM 支持，请等待 vLLM 更新以支持 PyTorch 2.10
```

---

### Q: Package installation times out / packages.txt download fails
### 问：包安装超时 / packages.txt 下载失败

**A**: Use pip mirrors / 使用 pip 镜像：

```bash
# Temporary (in Dockerfile)
pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple <package>

# Or use domestic mirrors in requirements
# 或在 requirements 中使用国内镜像
```

---

## 🐳 Runtime Issues / 运行问题

### Q: "CUDA not available" inside container
### 问：容器内"CUDA 不可用"

**Checklist / 检查清单**:

```bash
# 1. Check host GPU / 检查宿主机 GPU
nvidia-smi

# 2. Check Docker runtime / 检查 Docker 运行时
docker run --gpus all nvidia/cuda:13.0-base-ubuntu22.04 nvidia-smi

# 3. Check daemon config / 检查 daemon 配置
cat /etc/docker/daemon.json
# Should have: "default-runtime": "nvidia"

# 4. Restart Docker / 重启 Docker
sudo systemctl restart docker

# 5. Try explicit GPU flag / 尝试显式 GPU 标志
docker run --gpus all --rm atlas:v0.6-base python -c "import torch; print(torch.cuda.is_available())"
```

---

### Q: Container exits immediately / Health check fails
### 问：容器立即退出 / 健康检查失败

**A**: Check health status / 检查健康状态：

```bash
# Start container with logs / 启动容器并查看日志
docker run --gpus all --name test atlas:v0.6-base sleep 60

# Check health / 检查健康
docker inspect test | jq '.[0].State.Health'

# Check logs / 查看日志
docker logs test

# Clean up / 清理
docker rm -f test
```

**Exit codes / 退出码**:
- `0`: Healthy (CUDA available) / 健康（CUDA 可用）
- `1`: CUDA unavailable (GPU not visible) / CUDA 不可用
- `2`: torch import failed / torch 导入失败

---

### Q: Permission denied when accessing mounted volumes
### 问：访问挂载卷时权限被拒绝

**A**: Run as current user / 以当前用户运行：

```bash
docker run --gpus all -it --rm \
  --user $(id -u):$(id -g) \
  -v $(pwd):/workspace \
  atlas:v0.6-base
```

---

### Q: JupyterLab token not found / cannot access notebook
### 问：找不到 JupyterLab token / 无法访问 notebook

**A**: Check container logs for token / 查看容器日志获取 token：

```bash
# Check logs / 查看日志
docker logs <container-name>

# Or set custom token / 或设置自定义 token
docker run --gpus all -p 8888:8888 \
  -e JUPYTER_TOKEN=mytoken \
  atlas:v0.6-base \
  jupyter lab --ip=0.0.0.0 --allow-root --no-browser

# Then access / 然后访问: http://localhost:8888/?token=mytoken
```

---

## 🔧 Configuration / 配置问题

### Q: How to use different Python packages versions?
### 问：如何使用不同版本的 Python 包？

**A**: Rebuild with modified requirements / 修改 requirements 后重新构建：

```bash
# 1. Edit requirements.txt / 编辑 requirements.txt
vim requirements.txt

# 2. Rebuild / 重新构建
NO_CACHE=1 ./build.sh

# Or use pip install in running container (temporary)
# 或在运行中的容器中 pip install（临时）
docker run ... atlas:v0.6-base bash
pip install package==version
```

---

### Q: How to add custom packages?
### 问：如何添加自定义包？

**Option 1: Rebuild / 选项 1：重新构建**
```bash
# Add to requirements.txt
echo "your-package==1.0.0" >> requirements.txt
./build.sh
```

**Option 2: Install at runtime / 选项 2：运行时安装**
```bash
docker run --gpus all -it atlas:v0.6-base bash
pip install your-package
```

**Option 3: Custom Dockerfile / 选项 3：自定义 Dockerfile**
```dockerfile
FROM atlas:v0.6-base
RUN pip install your-package==1.0.0
```

---

### Q: How to use a different CUDA version?
### 问：如何使用不同的 CUDA 版本？

**A**: Modify Dockerfile base image / 修改 Dockerfile 基础镜像：

```dockerfile
# Change this line in Dockerfile
FROM nvidia/cuda:13.0-cudnn9-devel-ubuntu22.04

# To your desired version / 改为你需要的版本
FROM nvidia/cuda:12.1-cudnn8-devel-ubuntu22.04
```

⚠️ **Warning / 警告**: This may break PyTorch and other dependencies. Test thoroughly.
这可能破坏 PyTorch 和其他依赖。请充分测试。

---

## 🛠️ CI/CD Issues / CI/CD 问题

### Q: CI build fails on GitHub Actions
### 问：GitHub Actions 上 CI 构建失败

**A**: Most common causes / 最常见原因：

1. **Disk space**: Release job includes cleanup step
   **磁盘空间**：Release job 已包含清理步骤
   
2. **Timeout**: Set `timeout-minutes` in workflow
   **超时**：在工作流中设置 `timeout-minutes`
   
3. **Cache issues**: Clear GitHub Actions cache
   **缓存问题**：清除 GitHub Actions 缓存
   ```bash
   gh cache list
   gh cache delete <cache-id>
   ```

---

### Q: How to manually trigger nightly build?
### 问：如何手动触发 nightly 构建？

**A**: Via GitHub CLI or UI / 通过 GitHub CLI 或 UI：

```bash
# Via GitHub CLI
gh workflow run nightly-build.yml

# Via UI: Actions → Nightly Build → Run workflow
```

---

## 🚀 Best Practices / 最佳实践

### Q: Which tier should I use?
### 问：我应该使用哪个层级？

**Recommendation / 推荐**:

| Use Case / 用例 | Tier | Image Tag |
|------------------|------|-----------|
| Data science, CV, traditional ML / 数据科学、CV、传统 ML | 0 | v0.6-base |
| LLM fine-tuning (LoRA, QLoRA) / LLM 微调 | 1 | v0.6-llm |
| Materials science / 材料科学 | 0+materials | build with ENABLE_MATERIALS=1 |
| vLLM inference / vLLM 推理 | Wait for compatibility / 等待兼容性 | - |

---

### Q: How to reduce image size?
### 问：如何减小镜像大小？

**A**: Use multi-stage builds or remove unused packages:

```dockerfile
# In Dockerfile, remove packages after use
RUN pip install package && \
    ... && \
    pip uninstall -y package

# Or use --no-cache-dir
RUN pip install --no-cache-dir package
```

---

### Q: How to debug build failures?
### 问：如何调试构建失败？

**A**: Step-by-step debugging / 逐步调试：

```bash
# 1. Check pre-check / 检查预检查
./pre-check.sh

# 2. Build with verbose output / 详细输出构建
docker build --progress=plain --no-cache -t atlas:debug .

# 3. Debug specific layer / 调试特定层
docker build --target <stage-name> -t atlas:debug .

# 4. Inspect intermediate image / 检查中间镜像
docker run -it <image-id> bash
```

---

## 📚 More Help / 更多帮助

Still having issues? / 仍有问题？

1. **Check documentation / 查看文档**:
   - [docs/BUILD.md](BUILD.md) - Build guide / 构建指南
   - [docs/RUN.md](RUN.md) - Runtime guide / 运行指南
   - [docs/TESTS.md](TESTS.md) - Testing guide / 测试指南

2. **Search existing issues / 搜索现有 issue**:
   - [GitHub Issues](https://github.com/chenzhuyu2004/atlas/issues)

3. **Create new issue / 创建新 issue**:
   - Use [bug report template](../.github/ISSUE_TEMPLATE/bug_report.md)
   - Include environment information / 包含环境信息
   - Attach relevant logs / 附上相关日志

4. **Security issues / 安全问题**:
   - See [SECURITY.md](../SECURITY.md) for responsible disclosure
   - 查看 [SECURITY.md](../SECURITY.md) 进行负责任的披露
