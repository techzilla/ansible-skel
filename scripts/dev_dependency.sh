#!/bin/sh
set -eu

SCRIPT_PATH="$0"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
#PROJECT_PATH="$(dirname "$( cd -- "$SCRIPT_DIR" >/dev/null 2>&1 && pwd )")"

DIRECTORY="${1:-}"
REPOSITORY="${2:-}"

repository_valid(){
  if ! git ls-remote -h "$1" > /dev/null 2>&1; then
    return 1
  fi
}

if [ -z "$DIRECTORY" ]; then
  echo "usage: $(basename "$SCRIPT_PATH") <directory> <repository>"
  exit 1
fi

if [ -d "$DIRECTORY" ]; then
_dirpath=$(cd -- "$DIRECTORY" && pwd)
_gitpath=$(cd -- "$DIRECTORY" && git rev-parse --show-toplevel)

  if [ "$_dirpath" = "$_gitpath" ];then
    rm -rf "$DIRECTORY"
    "$SCRIPT_DIR/init_requirements.sh"
    exit 0
  fi
fi


if repository_valid "$REPOSITORY"; then
  rm -rf "$DIRECTORY"
  git clone "$REPOSITORY" "$DIRECTORY"
else
  echo "repository invalid or inaccessable"
  exit 1
fi
