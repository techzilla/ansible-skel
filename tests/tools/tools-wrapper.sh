#!/bin/sh
## DESCRIPTION: Tools Wrapper
## AUTHOR:  J. M. Becker

USEAGE="Usage: $(basename "$0") [ -g ] [-n <regex> ] [-x <regex> ] -f <file> <path> ..."

GFLAG=0
## Parse Options
while getopts ":f:ghn:x:" OPTION; do
  case ${OPTION} in
    f) FFLAG="$OPTARG"
      ;;
    h)
        echo "$USEAGE"
        exit 0
        ;;
    g) GFLAG=1
      ;;
    n)
       NFLAG="$OPTARG"
      ;;
    x)
       XFLAG="$OPTARG"
      ;;
    \?)
        echo "Unknown option: $OPTARG" >&2
        echo "$USEAGE" >&2
        exit 1
      ;;
  esac
done

## Assert Tool
[ -x "$FFLAG" ] || {
    echo "$USEAGE"
    exit 1
}

shift $((OPTIND - 1))

## Create Temp File
T_FILE1="$(mktemp tfile.XXXXX)"
T_FILE2="$(mktemp tfile.XXXXX)"
trap 'rm -f $T_FILE1 $T_FILE2' 0 1 2 3 15

find "$@" -type f -print0 > "$T_FILE1"

[ "$NFLAG" ] && {
    grep -zZ "$NFLAG" "$T_FILE1" > "$T_FILE2"
    cp "$T_FILE2" "$T_FILE1"
}

[ "$XFLAG" ] && {
    grep -vzZ "$XFLAG" "$T_FILE1" > "$T_FILE2"
    cp "$T_FILE2" "$T_FILE1"
}

[ $GFLAG -eq 1 ] && {
    xargs -0 -a "$T_FILE1" git diff-tree -z --no-commit-id --name-only -r HEAD > "$T_FILE2"
    cp "$T_FILE2" "$T_FILE1"
}

##
xargs -0 -a "$T_FILE1" "$FFLAG"

exit $?
