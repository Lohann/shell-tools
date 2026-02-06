#!/bin/sh
# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L551-L564

# shell_sanitize
# -----------------
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly. It is based on the m4sh.at Autotest testcases.
if (eval 'as_fn_return () { (exit $1); }
as_fn_success () { as_fn_return 0; }
as_fn_failure () { as_fn_return 1; }
as_fn_ret_success () { return 0; }
as_fn_ret_failure () { return 1; }

exitcode=0
as_fn_success || { exitcode=1; echo as_fn_success failed.; }
as_fn_failure && { exitcode=1; echo as_fn_failure succeeded.; }
as_fn_ret_success || { exitcode=1; echo as_fn_ret_success failed.; }
as_fn_ret_failure && { exitcode=1; echo as_fn_ret_failure succeeded.; }
if ( set x; as_fn_ret_success y && test x = "$1" )
then :
else
  exitcode=1;
  echo positional parameters were not saved. >&2
fi
test x$exitcode = x0 || exit 1') > /dev/null 2>&1
then :
else
  echo shell doesn\'t support functions correctly >&2;
  exit 1;
fi

# This is a spy to detect "in the wild" shells that do not support
# the newer $(...) form of command substitutions.
if (eval 'blah=$(echo $(echo blah))
test x"$blah" = xblah') > /dev/null 2>&1
then :
else
  echo command substitutions \''$(...)'\' not supported >&2;
  exit 2;
fi

# These days, we require that 'test -x' works.
if (eval "test -x / || exit 1") > /dev/null 2>&1
then :
else
  echo shell doesn\'t support 'test -x <file>' >&2;
  exit 3;
fi
