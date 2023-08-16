#!/bin/sh
##
## FILE: venv.sh
##

VENV=".venv"
ENVSH=".env.sh"

PIPCONF=''

load_env () {
  set -a
  # shellcheck source=/dev/null
  [ -f "$ENVSH" ] && . "$ENVSH"
  set +a
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

venv_check() {
    if [ "$VIRTUAL_ENV" = '' ]; then
        return 1
    else
        return 0
    fi
}

venv_activate() {
    if [ -e "${VENV}/bin/activate" ]; then
        # shellcheck disable=SC1091
        . "${VENV}/bin/activate"
        return 0
    else
        return 1
    fi

}

load_env

if check_command python3; then
    PYTHON="python3"
elif check_command python; then
    PYTHON="python"
else
    echo "ERROR: python not found"
    return 1
fi

if check_command pip3; then
    PIP="pip3"
elif check_command pip; then
    PIP="pip"
else
    echo "ERROR: pip not found"
    return 1
fi

pkgutil_check() {
    "$PYTHON" -c "import sys, pkgutil; sys.exit(0 if pkgutil.find_loader(sys.argv[1]) else 1)" "$1"
}

venv_create() {

    if pkgutil_check venv; then
        "$PYTHON" -m venv "$VENV"
        return 0
    elif check_command virtualenv; then
        virtualenv --no-site-packages "$VENV"
        return 0
    else
        return 1
    fi
}

if ! venv_check; then

    if ! venv_activate; then

        if venv_create && venv_activate; then
            echo "$PIPCONF" > "$VENV/pip.conf"

            "$PIP" install -U pip setuptools wheel
            "$PIP" install -r requirements.txt

            if [ -n "$REQ" ]; then
                "$PIP" install -r requirements-"$REQ".txt

            fi
            echo "INFO: venv created"

        else

            echo "ERROR: venv failed"
            if [ "$(basename "$0")" = "venv.sh" ]; then
                exit 1
            else
                return 1
            fi

        fi


    fi

fi
