#!/bin/sh
# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4


# Be more Bourne compatible
DUALCASE=1; export DUALCASE # for MKS sh
if test ${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1; then
  emulate sh
  # shellcheck disable=SC2034
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on ${1+"$@"}, which
  # is contrary to our usage.  Disable this feature.
  # shellcheck disable=SC2142
  alias -g '${1+"$@"}'='"$@"'
  setopt NO_GLOB_SUBST
else
  # shellcheck disable=SC2006
  case `(set -o) 2>/dev/null` in
    *posix*)
      # shellcheck disable=SC3040
      set -o posix > /dev/null 2>&1 ;;
    *) : ;;
  esac
fi

# Reset variables that may have inherited troublesome values from
# the environment.
nl='
'
export nl

# IFS needs to be set, to space, tab, and newline, in precisely that order.
# Quoting is to prevent editors from complaining about space-tab.
IFS=" ""	${nl}"
PS1='$ '
PS2='> '
PS4='+ '

# Ensure predictable behavior from utilities with locale-dependent output.
LC_ALL=C
export LC_ALL
LANGUAGE=C
export LANGUAGE
LANG=en_US.UTF-8
export LANG

# We cannot yet rely on "unset" to work, but we need these variables
# to be unset--not just set to an empty or harmless value--now, to
# avoid bugs in old shells (e.g. pre-3.0 UWIN ksh).  This construct
# also avoids known problems related to "unset" and subshell syntax
# in other old shells (e.g. bash 2.01 and pdksh 5.2.14).
test ${BASH_ENV+y} && ( (unset BASH_ENV) || exit 1) >/dev/null 2>&1 && unset BASH_ENV || :
test ${ENV+y} && ( (unset ENV) || exit 1) >/dev/null 2>&1 && unset ENV || :
test ${MAIL+y} && ( (unset MAIL) || exit 1) >/dev/null 2>&1 && unset MAIL || :
test ${MAILPATH+y} && ( (unset MAILPATH) || exit 1) >/dev/null 2>&1 && unset MAILPATH || :
test ${CDPATH+y} && ( (unset CDPATH) || exit 1) >/dev/null 2>&1 && unset CDPATH || :

# Unset more variables known to interfere with behavior of common tools.
test ${CLICOLOR_FORCE+y} && ( (unset CLICOLOR_FORCE) || exit 1) >/dev/null 2>&1 && unset CLICOLOR_FORCE || :
test ${GREP_OPTIONS+y} && ( (unset GREP_OPTIONS) || exit 1) >/dev/null 2>&1 && unset GREP_OPTIONS || :

# Ensure that fds 0, 1, and 2 are open.
if (exec 3>&0) 2>/dev/null; then :; else exec 0</dev/null; fi
if (exec 3>&1) 2>/dev/null; then :; else exec 1>/dev/null; fi
if (exec 3>&2)            ; then :; else exec 2>/dev/null; fi

# The user is always right.
if ${PATH_SEPARATOR+false} :; then
  PATH_SEPARATOR=:
  (PATH='/bin;/bin'; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 && {
    # shellcheck disable=SC2030,SC2034
    (PATH='/bin:/bin'; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 ||
      PATH_SEPARATOR=';'
  }
fi
