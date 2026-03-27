#!/bin/sh

# map <CODE> [...VALUE]
# ----------------------
# Assign each <VALUE> to $1 and eval <CODE>.
map ()
{
  test "$#" -gt 0 || return 1;
  eval "while test \"\$#\" -gt 1; do
  shift > /dev/null 2>&1 || return 125;
  eval `printf 'x%sx\n' "${1}" | sed -e "s/'/'\\\\\\\\''/g" -e "1s/^x/'/" -e '$s/x$/'\''/'`
done
return 0"
}
