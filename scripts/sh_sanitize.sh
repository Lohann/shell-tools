#!/bin/sh

# sh_sanitize [...ARGS]
# ----------------------
# Escape and quote the provided arguments, allowing then
# to be safely evaluated by shell.
sh_sanitize ()
{
  while test $# -gt 0; do
    if tr '\n' ' ' <<EOF | grep '^[-[:alnum:]_=,./:]* $' >/dev/null 2>&1
${1}
EOF
    then printf %s "${1}"
    else
      printf %s "${1}" | \
      sed \
        -e "s/'/'\\\\''/g" \
        -e "1s/^/'/" \
        -e "\$s/\$/'/" \
        -e "s#^'\([-[:alnum:]_,./:]*\)=\(.*\)\$#\1='\2#"
    fi
    shift 2> /dev/null || return $?;
    test $# -eq 0 || printf %s ' '
  done
}
