#!/bin/sh
# This file is part of Shell Tools
# original https://github.com/Lohann/shell-tools
# SPDX-License-Identifier: MIT

# test_varname <VARNAME>
# ----------------------
# Check if <VARNAME> is a valid shell variable name
test_varname ()
{
  test "$#" -gt 0 || { echo "test_varname: no arguments" >&2; return 127; }
  while :
  do
    # Avoid depending upon Character Ranges.
    # https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Special-Shell-Variables.html
    case $1 in
      _) return 1 ;;
      [_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
        LC_ALL=C expr "X${1}" ":" "X.*[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]" >/dev/null 2>/dev/null &&
        return 1 || :
        ;;
      *) return 1 ;;
    esac
    test "$#" -gt 1 || return 0
    shift 2> /dev/null || return 125
  done
} # test_varname
