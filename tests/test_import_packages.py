#!/usr/bin/env python3
"""
ATLAS Package Import Test / ATLAS 包导入测试
Tests that all required packages can be imported
测试所有必需包可以导入
"""

import sys
from typing import List, Tuple

# Colors / 颜色
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'

def print_info(msg: str):
    print(f"{GREEN}[INFO]{NC} {msg}")

def print_error(msg: str):
    print(f"{RED}[ERROR]{NC} {msg}")

def print_test(msg: str):
    print(f"{BLUE}[TEST]{NC} {msg}")

def test_import(package_name: str, import_statement: str = None) -> bool:
    """Test if a package can be imported / 测试包是否可以导入"""
    try:
        if import_statement:
            exec(import_statement)
        else:
            __import__(package_name)
        return True
    except ImportError as e:
        print_error(f"Failed to import {package_name}: {e}")
        return False

def main():
    print("=" * 50)
    print("ATLAS Package Import Tests")
    print("ATLAS 包导入测试")
    print("=" * 50)
    print()
    
    test_passed = 0
    test_failed = 0
    
    # Core packages / 核心包
    print_test("Core Data Science Packages / 核心数据科学包")
    core_packages = [
        ('numpy', None),
        ('pandas', None),
        ('scipy', None),
        ('polars', None),
        ('sklearn', 'import sklearn'),
        ('matplotlib', 'import matplotlib.pyplot'),
        ('seaborn', None),
        ('IPython', None),
        ('jupyterlab', None),
        ('PIL', 'from PIL import Image'),
        ('cv2', 'import cv2'),
        ('pydantic', None),
        ('safetensors', None),
        ('h5py', None),
    ]
    
    for pkg, import_stmt in core_packages:
        if test_import(pkg, import_stmt):
            print(f"  ✓ {pkg}")
            test_passed += 1
        else:
            print(f"  ✗ {pkg}")
            test_failed += 1
    print()
    
    # PyTorch / PyTorch
    print_test("PyTorch")
    if test_import('torch'):
        import torch
        print(f"  ✓ torch {torch.__version__}")
        print(f"    CUDA available: {torch.cuda.is_available()}")
        if torch.cuda.is_available():
            print(f"    CUDA version: {torch.version.cuda}")
            print(f"    Device count: {torch.cuda.device_count()}")
        test_passed += 1
    else:
        print(f"  ✗ torch")
        test_failed += 1
    print()
    
    # LLM packages (optional) / LLM 包（可选）
    print_test("LLM Packages (optional) / LLM 包（可选）")
    llm_packages = [
        'transformers',
        'accelerate',
        'datasets',
        'peft',
        'bitsandbytes',
        'sentencepiece',
        'tiktoken',
    ]
    
    llm_available = 0
    for pkg in llm_packages:
        if test_import(pkg):
            print(f"  ✓ {pkg}")
            llm_available += 1
        else:
            print(f"  - {pkg} (not installed)")
    
    if llm_available > 0:
        print(f"  LLM packages: {llm_available}/{len(llm_packages)} available")
    print()
    
    # Materials science packages (optional) / 材料科学包（可选）
    print_test("Materials Science Packages (optional) / 材料科学包（可选）")
    materials_packages = [
        'ase',
        'pymatgen',
        'spglib',
        'mendeleev',
        'phonopy',
    ]
    
    materials_available = 0
    for pkg in materials_packages:
        if test_import(pkg):
            print(f"  ✓ {pkg}")
            materials_available += 1
        else:
            print(f"  - {pkg} (not installed)")
    
    if materials_available > 0:
        print(f"  Materials packages: {materials_available}/{len(materials_packages)} available")
    print()
    
    # Summary / 总结
    print("=" * 50)
    print("Test Summary / 测试总结")
    print("=" * 50)
    print(f"Core packages passed / 核心包通过: {test_passed}")
    print(f"Core packages failed / 核心包失败: {test_failed}")
    print(f"Optional LLM packages / 可选 LLM 包: {llm_available}/{len(llm_packages)}")
    print(f"Optional Materials packages / 可选材料科学包: {materials_available}/{len(materials_packages)}")
    print()
    
    if test_failed == 0:
        print_info("All core tests passed! / 所有核心测试通过！")
        return 0
    else:
        print_error("Some core tests failed. / 部分核心测试失败。")
        return 1

if __name__ == "__main__":
    sys.exit(main())
