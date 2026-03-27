#!/bin/sh
# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L551-L564

# shell_sanity_check
# -----------------
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly. It is based on the m4sh.at Autotest testcases.
(eval 'fn_return () { (exit $1); }
fn_success () { fn_return 0; }
fn_failure () { fn_return 1; }
fn_ret_success () { return 0; }
fn_ret_failure () { return 1; }

exitcode=0
fn_success || { exitcode=1; echo fn_success failed.; }
fn_failure && { exitcode=1; echo fn_failure succeeded.; }
fn_ret_success || { exitcode=1; echo fn_ret_success failed.; }
fn_ret_failure && { exitcode=1; echo fn_ret_failure succeeded.; }
( set x; fn_ret_success y && test x = "$1" ) ||
{ exitcode=1; echo positional parameters were not saved.; }
test x$exitcode = x0 || exit 1') >&2 ||
{ echo "shell doesn't support functions correctly" >&2; exit 1; }

# This is a spy to detect "in the wild" shells that do not support
# the newer $(...) form of command substitutions.
(eval 'blah=$(echo $(echo blah))
test x"$blah" = xblah') > /dev/null 2>&1 ||
{ echo "shell doesn't support newer substitutions '\$(...)'" >&2; exit 1; }

# Succeed if the currently executing shell supports 'test -x'
(eval "test -x / || exit 1") > /dev/null 2>&1 ||
{ echo "shell doesn't support 'test -x <file>'" >&2; exit 1; }

# Succeed if the currently executing shell supports LINENO.
(v="a=";v=$v$LINENO;v=$v"
b=";v=$v$LINENO;v=$v'
test "x$a" != "x$b" && test "x`expr $a + 1`" = "x$b" && exit 0
exit 1';eval "$v") 2>/dev/null ||
{ echo "shell doesn't support LINENO" >&2; exit 1; }
