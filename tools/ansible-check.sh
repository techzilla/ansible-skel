#!/bin/sh
## DESCRIPTION: Ansible Check
## AUTHOR:  J. M. Becker

[ "$1" ] || {
    echo "check N/A:"
    exit 0
}

ansible-playbook -i tests/inventory -e @tests/extra_vars.yml --syntax-check "$@" || {
    echo "check fail:"
    exit 1
}

echo "check  pass:"
exit 0
