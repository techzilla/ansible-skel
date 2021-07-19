#!/bin/sh
## DESCRIPTION: Ansible Lint
## AUTHOR:  J. M. Becker

[ "$1" ] || {
    echo "lint N/A:"
    exit 0
}

ansible-lint "$@" || {
    echo "lint fail:"
    exit 1
}

echo "lint pass:"
exit 0
