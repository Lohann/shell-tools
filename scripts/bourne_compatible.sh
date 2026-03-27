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

# Find who we are. Look in the path if we contain no directory separator.
_st_basedir=
_st_myself=
st_sep=
st_prev=
st_ifs=$IFS
case $0 in
  *[\\/]* )
    st_sep= st_prev= _st_basedir= IFS=/
    for _st_myself in $0
    do
      _st_basedir=$_st_basedir$st_prev
      st_prev=$st_sep$_st_myself
      st_sep=/
    done
    IFS=$st_ifs
    test "x$_st_basedir" != x || { _st_basedir=$st_sep; st_sep=;}
    ;;
  *)
    _st_myself=
    IFS=$PATH_SEPARATOR
    for _st_basedir in $PATH
    do
      IFS=$st_ifs
      case $_st_basedir in
        '') _st_basedir=. st_sep=/ ;;
         /) st_sep= ;;
        */)
          st_prev=$_st_basedir _st_basedir= st_sep= IFS=/
          for st_prev in $st_prev
          do _st_basedir=$_st_basedir$st_sep$st_prev st_sep=/
          done
          IFS=$st_ifs ;;
        * ) st_sep=/ ;;
      esac
      { test -r "$_st_basedir$st_sep$0" && _st_myself=$0 && break; } || :
      _st_basedir=
      st_sep=
    done
    IFS=$st_ifs
    ;;
esac

# We did not find ourselves, most probably we were run as `sh COMMAND'
# in which case we are not to be found in the path.
test "x$_st_myself" != x || _st_myself=$0
test -f "$_st_basedir$st_sep$_st_myself" ||
{ printf "%s\n" "$_st_myself: error: cannot find myself; rerun with an absolute file name" >&2; exit 1; }
test -d "$_st_basedir" ||
{ printf "%s\n" "$_st_basedir: error: cannot find base directory; rerun with an absolute file name" >&2; exit 1; }
_st_basedir=$_st_basedir$st_sep
{ st_sep=; unset st_sep; }
{ st_prev=; unset st_prev; }
{ st_ifs=; unset st_ifs; }
