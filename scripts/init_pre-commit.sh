#!/bin/sh
set -eu

SCRIPT_PATH="$0"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_PATH="$(dirname "$( cd -- "$SCRIPT_DIR" >/dev/null 2>&1 && pwd )")"

if [ -f "$PROJECT_PATH/.pre-commit-config.yaml" ]; then
  ( cd "$PROJECT_PATH" && pre-commit install -f --install-hooks )
fi
