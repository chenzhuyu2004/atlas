#!/bin/bash
# Wrapper script for backward compatibility
# 向后兼容性 wrapper 脚本
exec "$(dirname "$0")/scripts/check-updates.sh" "$@"
