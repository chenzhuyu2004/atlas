#!/usr/bin/env bash
# Wrapper script for build tree
exec "$(dirname "$0")/docker/atlas/push.sh" "$@"
