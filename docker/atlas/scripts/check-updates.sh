#!/usr/bin/env bash
# ==============================================================================
# ATLAS Dependency Update Checker / 依赖更新检查脚本
# Check for newer versions of Python packages
# 检查 Python 包的新版本
# ==============================================================================

set -euo pipefail

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
    mapfile -t req_lines < <(grep -E "^[a-zA-Z0-9].*==" "$file" || true)
    if [[ ${#req_lines[@]} -eq 0 ]]; then
        echo -e "  ${YELLOW}(no pinned packages)${NC}"
        echo ""
        return
    fi

    # Fetch latest versions in parallel (Python threads) / 并发获取最新版本
    declare -A latest_versions
    while IFS=$'\t' read -r pkg latest; do
        latest_versions["$pkg"]="$latest"
    done < <(printf '%s\n' "${req_lines[@]}" | python3 - <<'PY'
import os
import sys
import json
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

jobs = int(os.environ.get("CHECK_UPDATES_JOBS", "8"))

def parse_pkg(line: str) -> str | None:
    line = line.split("#", 1)[0].strip()
    if "==" not in line:
        return None
    return line.split("==", 1)[0].strip()

pkgs = []
for raw in sys.stdin:
    pkg = parse_pkg(raw)
    if pkg:
        pkgs.append(pkg)

def fetch_latest(pkg: str) -> tuple[str, str]:
    url = f"https://pypi.org/pypi/{pkg}/json"
    try:
        with urllib.request.urlopen(url, timeout=6) as resp:
            data = json.load(resp)
            return pkg, data.get("info", {}).get("version", "?")
    except Exception:
        return pkg, "?"

with ThreadPoolExecutor(max_workers=jobs) as ex:
    futures = {ex.submit(fetch_latest, p): p for p in pkgs}
    for fut in as_completed(futures):
        pkg, latest = fut.result()
        print(f"{pkg}\\t{latest}")
PY
    )

    for line in "${req_lines[@]}"; do
        line="${line%%#*}"
        line="$(echo "$line" | tr -d '[:space:]')"
        pkg="${line%%==*}"
        current="${line##*==}"
        latest="${latest_versions[$pkg]:-?}"

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
check_file "${PROJECT_ROOT}/requirements.txt" "Core Data Science"
check_file "${PROJECT_ROOT}/requirements-llm.txt" "LLM Stack"
check_file "${PROJECT_ROOT}/requirements-accel.txt" "LLM Acceleration"
check_file "${PROJECT_ROOT}/requirements-materials.txt" "Materials Science"

echo -e "${BLUE}=== Check Complete ===${NC}"
echo ""
echo "To update a package / 更新包:"
echo "  1. Edit requirements-*.txt"
echo "  2. Rebuild: make build"
echo "  3. Test: docker run --rm atlas:v0.6-base python -c 'import <package>'"
