#!/bin/sh
## DESCRIPTION: Ansible Idempotant
## AUTHOR:  J. M. Becker

[ "$1" ] || {
    echo "idempotant N/A:"
    exit 0
}

T_PYML="$1"
! grep docker /proc/1/cgroup -qa && {
    echo "idempotant N/A: not containerized"
    exit 0
}

## Create Temp File
T_FILE="$(mktemp tfile.XXXXX)"
trap 'rm -f $T_FILE' 0 1 2 3 15


ansible-playbook -i tests/inventory --skip-tags skip_docker -e @tests/extra_vars.yml "$T_PYML" || {
    echo "idempotant fail: first execution failed"
    exit 1
}

ansible-playbook -i tests/inventory --skip-tags skip_docker -e @tests/extra_vars.yml "$T_PYML" > "$T_FILE"

tail "$T_FILE" | grep -q 'changed=0.*failed=0' || {
    echo "idempotant fail: second execution changed"
    exit 1
}

echo "idempotant pass:"
exit 0
