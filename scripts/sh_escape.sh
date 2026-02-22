#!/bin/sh

# sh_escape [...ARGS]
# ----------------------
# Escape and quote the provided arguments, the printed string
# string can be safely evaluated by shell.
sh_escape ()
{
  while test $# -gt 0; do
    if tr '\n' ' ' <<EOF | grep '^[-[:alnum:]_=,./:]* $' >/dev/null 2>&1
${1}
EOF
    then printf %s "${1}"
    else
      printf %s "x${1}x" | \
      sed \
        -n \
        -e ':begin' \
        -e '$bend' \
        -e 'N' \
        -e 'bbegin' \
        -e ':end' \
        -e "s/'/'\\\\''/g" \
        -e "s/^x/'/" \
        -e 's/x$/'\''/' \
        -e "s#^'\([-[:alnum:]_,./:]*\)=\(.*\)\$#\1='\2#" \
        -e 'p'
    fi
    test $# -gt 1 || return 0
    shift 2> /dev/null || return $?
    printf %s ' '
  done
}
