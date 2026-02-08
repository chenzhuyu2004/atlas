#!/usr/bin/env bash
# ==============================================================================
# ATLAS Dependency Update Checker / 依赖更新检查脚本
# Check for newer versions of Python packages
# 检查 Python 包的新版本
# ==============================================================================

set -e

# Colors / 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo -e "${BLUE}=== ATLAS Dependency Update Check ===${NC}"
echo -e "${BLUE}=== ATLAS 依赖更新检查 ===${NC}"
echo ""

# Check each requirements file / 检查每个依赖文件
check_file() {
    local file="$1"
    local name="$2"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${YELLOW}⚠ $name not found${NC}"
        return
    fi
    
    echo -e "${GREEN}=== $name ===${NC}"
    
    # Extract package names and versions / 提取包名和版本
    grep -E "^[a-zA-Z].*==" "$file" | while read -r line; do
        pkg=$(echo "$line" | cut -d'=' -f1 | tr -d ' ')
        current=$(echo "$line" | grep -oP '==\K[0-9.]+')
        
        # Get latest version from PyPI / 从 PyPI 获取最新版本
        latest=$(curl -s "https://pypi.org/pypi/${pkg}/json" 2>/dev/null | \
                 python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('info',{}).get('version','?'))" 2>/dev/null || echo "?")
        
        if [[ "$latest" == "?" ]]; then
            echo -e "  ${pkg}: ${current} -> ${YELLOW}(cannot check)${NC}"
        elif [[ "$current" == "$latest" ]]; then
            echo -e "  ${pkg}: ${current} ${GREEN}✓${NC}"
        else
            echo -e "  ${pkg}: ${current} -> ${YELLOW}${latest}${NC} ${RED}(update available)${NC}"
        fi
    done
    echo ""
}

# Check all files / 检查所有文件
check_file "${SCRIPT_DIR}/requirements.txt" "Core Data Science"
check_file "${SCRIPT_DIR}/requirements-llm.txt" "LLM Stack"
check_file "${SCRIPT_DIR}/requirements-accel.txt" "LLM Acceleration"
check_file "${SCRIPT_DIR}/requirements-materials.txt" "Materials Science"

echo -e "${BLUE}=== Check Complete ===${NC}"
echo ""
echo "To update a package / 更新包:"
echo "  1. Edit requirements-*.txt"
echo "  2. Rebuild: make build"
echo "  3. Test: docker run --rm atlas:v0.6-base python -c 'import <package>'"
