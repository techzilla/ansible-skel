#!/bin/sh

set -eu

SCRIPT_PATH="$0"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_PATH="$(dirname "$( cd -- "$SCRIPT_DIR" >/dev/null 2>&1 && pwd )")"
VSCWRKSPC_PATH="$PROJECT_PATH/.vscode"

if [ -d "$VSCWRKSPC_PATH" ]; then
  if [ ! -f "$VSCWRKSPC_PATH/settings.json" ]; then
    if [ -f "$VSCWRKSPC_PATH/settings.default.json" ]; then

      cp "$VSCWRKSPC_PATH/settings.default.json" "$VSCWRKSPC_PATH/settings.json"
    fi
  fi
fi
