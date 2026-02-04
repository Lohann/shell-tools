#!/bin/sh

# valid_varname <STRING>
# ----------------------
# Check if <STRING> is a valid shell varname
test_varname ()
{
  test $# -gt 0 || return 127;
  while :; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    test $# -gt 1 || return 0;
    shift 2> /dev/null || return 127;
  done
}
