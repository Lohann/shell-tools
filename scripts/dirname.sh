#!/bin/sh
# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1037-L1079

# dirname <PATH>
# ---------------------
# Polyfill for the command 'dirname FILE-NAME'. Not all systems have
# dirname.
if (st_dir=`dirname -- /` && test "X$st_dir" = X/) >/dev/null 2>&1;
then :
else :
dirname ()
{
  test $# -gt 0 || { echo 'dirname: missing operand' >&2; return 127; };
  if test x"${1}" = 'x--'
  then
    shift > /dev/null || { echo 'dirname: shift failed' >&2; return 127; };
    test $# -gt 0 || { echo 'dirname: missing operand' >&2; return 127; };
  else :
  fi

  # Prefer `expr` to `printf|sed`, since expr is usually faster and it handles
  # backslashes and newlines correctly.  However, older expr
  # implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
  # a silly length limit that causes `expr` to fail if the matched
  # substring is longer than 120 bytes.  So fall back on `printf|sed` if
  # `expr` fails.
  {
    expr a : '\(a\)' >/dev/null 2>&1 &&
    test "X`expr 00001 : '.*\(...\)'`" = X001 >/dev/null 2>&1 &&
    expr X"${1}" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
	  X"${1}" : 'X\(//\)[^/]' \| \
	  X"${1}" : 'X\(//\)$' \| \
	  X"${1}" : 'X\(/\)' \| . 2>/dev/null;
  } || {
    printf '%s\n' X"${1}" | sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
	    s//\1/
	    q
	  }
	  /^X\(\/\/\)[^/].*/{
	    s//\1/
	    q
	  }
	  /^X\(\/\/\)$/{
	    s//\1/
	    q
	  }
	  /^X\(\/\).*/{
	    s//\1/
	    q
	  }
	  s/.*/./; q';
  };
}
fi
