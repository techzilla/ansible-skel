#!/bin/sh
## DESCRIPTION: Ansible Download Requirements
## AUTHOR:  J. M. Becker

[ "$1" ] || {
    echo "requirements N/A:"
    exit 0
}

T_REQ="$1"
[ -f "$T_REQ" ] && {
    grep -qE '[[:alnum:]]' "$T_REQ" && {
        ansible-galaxy install -r "$T_REQ"
    }
}

exit 0
