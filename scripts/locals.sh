#!/bin/sh

# locals_declare <VAR1> <VAR2> ... <VARN>
# ----------------------
# polyfill for 'local <varname>', for shells that don't support
# local builtin, it saves the provided variable values and names
# in a stack prefixed with `_st_locals$NUMBER`, then unset their values,
# remember to call `locals_release` to restore previous variable values.
# IMPORTANT: variables with prefix `_st_local` can't be used as local as 
# they are reserved exclusively to `locals_declare` and `locals_release`
# methods.
locals_declare ()
{
  test "$#" -gt 0 ||
  { printf "%s\n" "[ERROR] locals_declare: no variables provided" >&2; return 127; }
  test "${__st_locals=0}" -ge 0 2> /dev/null ||
  { printf "%s\n" "[ERROR] locals_declare: '__st_locals' isn't an integer" >&2; return 127; }
  if test "$__st_locals" -gt 0
  then
    set x "$__st_locals" "$@" && shift || return 125
    __st_locals=`expr "1" "+" "$__st_locals" || test "$?" -eq 1` || return 125
    eval "__st_locals${__st_locals}='__st_locals=${1};unset \"__st_locals${__st_locals}\"'" && shift || return 125
  else
    eval "__st_locals${__st_locals}='unset \"__st_locals\" \"__st_locals${__st_locals}\"'" || return 125
  fi
  while test "$#" -gt 0
  do
    if eval "test \${$1+y}" 2>/dev/null
    then
      test "x$__st_locals" != "x__st_locals" || { shift || return 125; continue; }
      { set x "$__st_locals" "$@" && shift; } || return 125
      __st_locals=`expr "1" "+" "$__st_locals" || test "$?" -eq 1` || return 125
      eval "__st_locals${__st_locals}=\"${2}=\\\$__st_locals${1};\$__st_locals${1} \\\"__st_locals${__st_locals}\\\"\" &&
      __st_locals${1}=\$${2} &&
      unset '${2}'" || return 125
      { shift && shift; } || return 125
    else
      eval "__st_locals${__st_locals}=\"\$__st_locals${__st_locals} \\\"${1}\\\"\"" && shift || return 125
    fi
  done
}

# locals_release [STATUS_CODE]
# ----------------------
# Restore previous variable values, optionally accepts a
# status code as parameter, if provided it returns that
# status, except in case of error, which may happen if
# `locals_release` is called without a corresponding
# `locals_declare`, or when `_st_locals` is invalid.
locals_release ()
{
  { test "${__st_locals+y}" = y && test "x$__st_locals" != x; } ||
  { printf "%s\n" "[ERROR] locals_release: no corresponding 'locals_declare'" >&2; return 127; }
  eval "eval \"\${__st_locals${__st_locals}}\"" || return 127
  test "$#" -eq 0 || return "$1"
}
__st_locals=
unset "__st_locals"
