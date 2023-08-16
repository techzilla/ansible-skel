#!/bin/sh
set -eu

SCRIPT_PATH="$0"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_PATH="$(dirname "$( cd -- "$SCRIPT_DIR" >/dev/null 2>&1 && pwd )")"

G_OPTS=''
F_FLAG=''
while getopts f name
do
    case $name in
    f)   F_FLAG=1;;
    ?)   exit 1
    esac
done
shift $((OPTIND - 1))

if [ -n "$F_FLAG" ]; then
    G_OPTS="-f"
fi

yaml_nempty(){
if ! grep -qEv '(^[[:space:]]*#|^---|^\.\.\.|^[[:space:]]*$)' "$1"; then
  return 1
fi
}

R1_PATH="$PROJECT_PATH/requirements.yml"
RR_PATH="$PROJECT_PATH/roles/requirements.yml"
RC_PATH="$PROJECT_PATH/collections/requirements.yml"

if [ -f "$R1_PATH" ]; then
  if yaml_nempty "$R1_PATH"; then

    if grep -q "collections:" "$R1_PATH"; then


      ansible-galaxy collection install --ignore-errors -r "$R1_PATH" $G_OPTS
    fi

    ansible-galaxy install --ignore-errors -r "$R1_PATH" $G_OPTS
  fi

else
  if [ -f "$RR_PATH" ]; then
    if yaml_nempty "$RR_PATH"; then

      ansible-galaxy install --ignore-errors -r "$RR_PATH" $G_OPTS
    fi
  fi

  if [ -f "$RC_PATH" ]; then
    if yaml_nempty "$RC_PATH"; then

      ansible-galaxy collection install --ignore-errors -r "$RC_PATH" $G_OPTS
    fi
  fi

fi
