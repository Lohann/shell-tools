#!/bin/sh

# valid_varname <STRING>
# ----------------------
# Check all arguments, check if <STRING> is a valid shell varname
test_varname ()
{
  test $# -gt 0 || return 127
  while :; do
    # https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Special-Shell-Variables.html
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) return 1 ;;
      [a-zA-Z_]* ) test $# -gt 1 || return 0 ;;
      * ) return 1 ;;
    esac
    shift 2> /dev/null || return 127
  done
}
