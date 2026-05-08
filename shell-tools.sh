#!/bin/sh

# FILE AUTO-GENERATED USING SHELL-TOOLS v0.1.0-2c2ddb0
# COMMAND: build.sh --import=st_import --output=./shell-tools.sh
#    DATE: 2026-05-08
#  SOURCE: https://github.com/Lohann/shell-tools
#  SHA256: 9ba41d17c89c22892e621ac5e80a23e37fea8dd7b33af50c52aa0b41b3ea5d47

##################
## SCRIPT START ##
##################
test ${st_import+y} &&
test x"${st_import}" != 'x' || st_import='bourne_compatible
shell_sanity_check
append
locals
quote
sh_escape
map
test_varname
basename
pushvar
popvar
bigint_add
clean_dir
dirname
printf_colors
str_to_varname
trim
unix_timestamp
version_compare'

# Remove whitespaces
case `printf '%bX%b' '\141' '\x61' 2> /dev/null` in
  aX*) :
    { st_import=`printf '%s\n' "${st_import}" | LC_ALL=C LANGUAGE=C tr '[\001-\040\176-\377]' "
"` || { printf '%s\n' "[ERROR] tr failed '${st_import}'" >&2; exit 1; }; } ;;
  *Xa) :
    { st_import=`printf '%s\n' "${st_import}" | LC_ALL=C LANGUAGE=C tr '[\x01-\x20\x76\xfe]' "
"` || { printf '%s\n' "[ERROR] tr failed '${st_import}'" >&2; exit 1; }; } ;;
  *) :
    { st_import=`printf '%s\n' "${st_import}" | LC_ALL=C LANGUAGE=C tr " ""	
" "
"` || { printf '%s\n' "[ERROR] tr failed '${st_import}'" >&2; exit 1; }; } ;;
esac

# Parse options
st_import=`printf '%s\n' "${st_import}" | LC_ALL=C LANGUAGE=C sed -n \
  -e "/^\n*$/b end" \
  -e 's/^\([A-Za-z_][A-Za-z0-9_]*\)$/\1=\1/; t ok' \
  -e "/^[A-Za-z_][A-Za-z0-9_]*=[A-Za-z_][A-Za-z0-9_]*$/b ok" \
  -e "s/'/'\\\\''/g" \
  -e "s/^/'/" \
  -e "s/$/'/" \
  -e ':ok' \
  -e 'p' \
  -e ':end'` ||
{ printf '%s\n' "[ERROR] sed failed '${st_import}'" >&2; exit 1; }

test "X${st_import}" != X || exit 0

# Validate options
(eval '_imports="${st_import}"
_st_error=
st_case='\''['\''\'\'\'']*'\''
for v in ${_imports}
do case ${v} in
  $st_case ) eval "_st_error=\"\${_st_error}invalid option \"${v}'\''
'\''"; continue ;;
  *=* ) a=`expr X$v : '\''X\([^=]*\)=.*'\''` ;;
  * ) a="${v}" ;;
esac
case "${a}" in
  bourne_compatible ) : ;;
  shell_sanity_check ) : ;;
  append ) : ;;
  locals ) : ;;
  quote ) : ;;
  sh_escape ) : ;;
  map ) : ;;
  test_varname ) : ;;
  basename ) : ;;
  pushvar ) : ;;
  popvar ) : ;;
  bigint_add ) : ;;
  clean_dir ) : ;;
  dirname ) : ;;
  printf_colors ) : ;;
  str_to_varname ) : ;;
  trim ) : ;;
  unix_timestamp ) : ;;
  version_compare ) : ;;
  * ) _st_error="${_st_error}unknown option '\''${a}'\''
" ;;
esac
done
test "X${_st_error}" = X || { printf "%s\n%s" "[ERROR] invalid options:" "${_st_error}" >&2; exit 1; }') || exit $? 

# display file header
cat <<EOLHEADER
#!/bin/sh
# THIS FILE WAS AUTO-GENERATED USING SHELL-TOOLS v0.1.0-2c2ddb0
#   DATE: `TZ=GMT0 LANGUAGE=C LC_ALL=C date '+%Y-%m-%d'`
# SOURCE: https://github.com/Lohann/shell-tools
# SHA256: 9ba41d17c89c22892e621ac5e80a23e37fea8dd7b33af50c52aa0b41b3ea5d47

EOLHEADER

# display imports
printf '%s\n' '# IMPORTED MODULES #'
printf '%s\n' "st_import='${st_import}'"

## bourne_compatible ##
echo "${st_import}" | grep '^bourne_compatible' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
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
  alias -g '\''${1+"$@"}'\''='\''"$@"'\''
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
nl='\''
'\''
export nl

# IFS needs to be set, to space, tab, and newline, in precisely that order.
# Quoting is to prevent editors from complaining about space-tab.
IFS=" ""	${nl}"
PS1='\''$ '\''
PS2='\''> '\''
PS4='\''+ '\''

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
  (PATH='\''/bin;/bin'\''; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 && {
    # shellcheck disable=SC2030,SC2034
    (PATH='\''/bin:/bin'\''; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 ||
      PATH_SEPARATOR='\'';'\''
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
        '\'\'') _st_basedir=. st_sep=/ ;;
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

# We did not find ourselves, most probably we were run as `sh COMMAND'\''
# in which case we are not to be found in the path.
test "x$_st_myself" != x || _st_myself=$0
test -f "$_st_basedir$st_sep$_st_myself" ||
{ printf "%s\n" "$_st_myself: error: cannot find myself; rerun with an absolute file name" >&2; exit 1; }
test -d "$_st_basedir" ||
{ printf "%s\n" "$_st_basedir: error: cannot find base directory; rerun with an absolute file name" >&2; exit 1; }
_st_basedir=$_st_basedir$st_sep
{ st_sep=; unset st_sep; }
{ st_prev=; unset st_prev; }
{ st_ifs=; unset st_ifs; }') || :

## shell_sanity_check ##
echo "${st_import}" | grep '^shell_sanity_check' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L551-L564

# shell_sanity_check
# -----------------
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly. It is based on the m4sh.at Autotest testcases.
(eval '\''fn_return () { (exit $1); }
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
test x$exitcode = x0 || exit 1'\'') >&2 ||
{ echo "shell doesn'\''t support functions correctly" >&2; exit 1; }

# This is a spy to detect "in the wild" shells that do not support
# the newer $(...) form of command substitutions.
(eval '\''blah=$(echo $(echo blah))
test x"$blah" = xblah'\'') > /dev/null 2>&1 ||
{ echo "shell doesn'\''t support newer substitutions '\''\$(...)'\''" >&2; exit 1; }

# Succeed if the currently executing shell supports '\''test -x'\''
(eval "test -x / || exit 1") > /dev/null 2>&1 ||
{ echo "shell doesn'\''t support '\''test -x <file>'\''" >&2; exit 1; }

# Succeed if the currently executing shell supports LINENO.
(v="a=";v=$v$LINENO;v=$v"
b=";v=$v$LINENO;v=$v'\''
test "x$a" != "x$b" && test "x`expr $a + 1`" = "x$b" && exit 0
exit 1'\'';eval "$v") 2>/dev/null ||
{ echo "shell doesn'\''t support LINENO" >&2; exit 1; }') || :

## append ##
echo "${st_import}" | grep '^append' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# append VAR VALUE
# ----------------------
# Append the text in VALUE to the end of the definition contained in VAR. Take
# advantage of any shell optimizations that allow amortized linear growth over
# repeated appends, instead of the typical quadratic growth present in naive
# implementations.
if (eval "st_var=1; st_var+=2; test x\$st_var = x12") 2>/dev/null
then eval '\'''"${append}"' ()
{
  eval "${1}+=\${2}"
}'\''
else '"${append}"' ()
{
  eval "${1}=\"\${${1}}\${2}\""
}
fi') || :

## locals ##
echo "${st_import}" | grep '^locals' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# locals_declare <VAR1> <VAR2> ... <VARN>
# ----------------------
# polyfill for '\''local <varname>'\'', for shells that don'\''t support
# local builtin, it saves the provided variable values and names
# in a stack prefixed with `_st_locals$NUMBER`, then unset their values,
# remember to call `locals_release` to restore previous variable values.
# IMPORTANT: variables with prefix `__st_local` can'\''t be used as local as 
# they are reserved exclusively to `locals_declare` and `locals_release`
# methods.
'"${locals}"'_declare ()
{
  test "$#" -gt 0 ||
  { printf "%s\n" "[ERROR] '"${locals}"'_declare: no variables provided" >&2; return 127; }
  if test "${__st_'"${locals}"'+y}" && test "${__st_'"${locals}"'}" -ge 0 2>/dev/null
  then
    set x "$__st_'"${locals}"'" "$@" && shift || return 125
    __st_'"${locals}"'=`expr "1" "+" "${__st_'"${locals}"'}" || test "$?" -eq 1` || return 125
    eval "__st_'"${locals}"'${__st_'"${locals}"'}='\''__st_'"${locals}"'=${1};unset \"__st_'"${locals}"'${__st_'"${locals}"'}\"'\''" && shift || return 125
  else
    __st_'"${locals}"'=0
    eval "__st_'"${locals}"'${__st_'"${locals}"'}='\''unset \"__st_'"${locals}"'\" \"__st_'"${locals}"'${__st_'"${locals}"'}\"'\''" || return 125
  fi
  while test "$#" -gt 0
  do
    if eval "test \${$1+y}" 2>/dev/null
    then
      test "x$__st_'"${locals}"'" != "x__st_'"${locals}"'" || { shift || return 125; continue; }
      { set x "$__st_'"${locals}"'" "$@" && shift; } || return 125
      __st_'"${locals}"'=`expr "1" "+" "$__st_'"${locals}"'" || test "$?" -eq 1` || return 125
      eval "__st_'"${locals}"'${__st_'"${locals}"'}=\"${2}=\\\${__st_'"${locals}"'${1}};\${__st_'"${locals}"'${1}} \\\"__st_'"${locals}"'${__st_'"${locals}"'}\\\"\" &&
      __st_'"${locals}"'${1}=\${${2}} &&
      unset '\''${2}'\''" || return 125
      { shift && shift; } || return 125
    else
      eval "__st_'"${locals}"'${__st_'"${locals}"'}=\"\${__st_'"${locals}"'${__st_'"${locals}"'}} \\\"${1}\\\"\"" && shift || return 125
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
'"${locals}"'_release ()
{
  { test "${__st_'"${locals}"'+y}" = y && test "x$__st_'"${locals}"'" != x; } ||
  { printf "%s\n" "[ERROR] '"${locals}"'_release: no corresponding '\'''"${locals}"'_declare'\''" >&2; return 127; }
  eval "eval \"\${__st_'"${locals}"'${__st_'"${locals}"'}}\"" || return 127
  test "$#" -eq 0 || return "$1"
}
__st_'"${locals}"'=
unset "__st_'"${locals}"'"') || :

## quote ##
echo "${st_import}" | grep '^quote' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# quote <STRING>
# ----------------------
# wraps the string in single quotes.
#
# The most common approach to escape single quotes in a string is by replace them 
# with '\''\'\'\'' (quote, slash, quote, quote), unfortunately this naive approach also
# may add lots of useless quotes if the original value has consecutive single quotes
# or begins/ends with single quotes. The logic implemented by this function
# takes that into consideration and never adds useless quotes.
#
# Example:
# naive_quote() {
#   printf %s "$1" | sed -e "s/'\''/'\''\\\\'\'\''/g" -e "1s/^/'\''/" -e '\''$s/$/'\''\'\'\''/'\''
# }
#
# original value: '\'\'\''some'\'\'\''value'\'\'\''
#   naive escape: '\'\''\'\'\'\''\'\'\'\''\'\'\''some'\''\'\'\'\''\'\'\'\''\'\'\''value'\''\'\'\'\''\'\'\'\''\'\'\'\''
#  better escape: \'\''\'\''\'\'\''some'\''\'\''\'\''\'\'\''value'\''\'\''\'\''\'\''
# 
# '\''better'\'' and '\''naive'\'' are the same value, you can verify it by running:
# a='\'\''\'\'\'\''\'\'\'\''\'\'\''some'\''\'\'\'\''\'\'\'\''\'\'\''value'\''\'\'\'\''\'\'\'\''\'\'\'\''
# b=\'\''\'\''\'\'\''some'\''\'\''\'\''\'\'\''value'\''\'\''\'\''\'\''
# test "$a" = "$b" && echo '\''A and B are equal!'\''
'"${quote}"' ()
{
  # The two x'\''s in the printf is a tricky to prevent `sed` 
  # from removing leading and trailing spaces.
  printf x%sx "$*" | LC_ALL=C sed "{
    1s/^x//
    \$s/x\$//
    s/[^'\'']*[^'\'']/\\x0a&\\x0a/g
    \$!s/\\x0a\$//
    \$!s/'\''\$/'\''\\x0a/
    1!s/^\\x0a//
    1!s/^'\''/\\x0a'\''/
    s/'\''/\\\\&/g
    s/\\x0a/'\''/g
    /^\$/{
      1s/^/'\''/
      \$s/\$/'\''/
    }
  }"
}') || :

## sh_escape ##
echo "${st_import}" | grep '^sh_escape' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# sh_escape [...ARGS]
# ----------------------
# Escape and quote the provided arguments, the printed string
# string can be safely evaluated by shell.
'"${sh_escape}"' ()
{
  while test "$#" -gt 0; do
    if tr '\''\n'\'' '\'' '\'' <<EOF | grep '\''^[-[:alnum:]_=,./:]* $'\'' >/dev/null 2>&1
${1}
EOF
    then printf %s "${1}"
    else
      printf x%sx "${1}" | \
      sed \
        -n \
        -e '\'':begin'\'' \
        -e '\''$bend'\'' \
        -e '\''N'\'' \
        -e '\''bbegin'\'' \
        -e '\'':end'\'' \
        -e "s/'\''/'\''\\\\'\'\''/g" \
        -e "s/^x/'\''/" \
        -e "s/x\$/'\''/" \
        -e "s#^'\''\\([-[:alnum:]_,./:]*\\)=\\(.*\\)\$#\\1='\''\\2#" \
        -e '\''p'\''
    fi
    test "$#" -gt 1 || return 0
    shift 2> /dev/null || return $?
    printf %s " "
  done
}') || :

## map ##
echo "${st_import}" | grep '^map' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# map <CODE> [...VALUE]
# ----------------------
# Assign each <VALUE> to $1 and eval <CODE>.
'"${map}"' ()
{
  test "$#" -gt 0 || return 1;
  eval "while test \"\$#\" -gt 1; do
  shift > /dev/null 2>&1 || return 125;
  eval `printf '\''x%sx\n'\'' "${1}" | sed -e "s/'\''/'\''\\\\\\\\'\'\''/g" -e "1s/^x/'\''/" -e '\''$s/x$/'\''\'\'\''/'\''`
done
return 0"
}') || :

## test_varname ##
echo "${st_import}" | grep '^test_varname' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# This file is part of Shell Tools
# original https://github.com/Lohann/shell-tools
# SPDX-License-Identifier: MIT

# test_varname <VARNAME>
# ----------------------
# Check if <VARNAME> is a valid shell variable name
'"${test_varname}"' ()
{
  test "$#" -gt 0 || { echo "'"${test_varname}"': no arguments" >&2; return 127; }
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
} # '"${test_varname}"'') || :

## basename ##
echo "${st_import}" | grep '^basename' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1037-L1079

# basename <PATH>
# ---------------------
# Polyfill for the command '\''basename FILE-NAME'\''. Not all systems have
# basename.
#
# Avoid Solaris 9 /usr/ucb/basename, as '\''basename /'\'' outputs an empty line.
# Also, traditional basename mishandles --
if ('\''base'\'\''name'\'' -- /) >/dev/null 2>&1 && test "X`'\''base'\'\''name'\'' -- / 2>&1`" = "X/"
then :
else :
'"${basename}"' ()
{
  test "$#" -gt 0 || { echo '\'''"${basename}"': missing operand'\'' >&2; return 127; }
  if test x"${1}" = '\''x--'\''
  then
    shift > /dev/null 2>&1 || { echo '\'''"${basename}"': shift failed'\'' >&2; return 127; }
    test "$#" -gt 0 || { echo '\'''"${basename}"': missing operand'\'' >&2; return 127; }
  else :
  fi

  # Prefer `expr` to `printf|sed`, since expr is usually faster and it handles
  # backslashes and newlines correctly.  However, older expr
  # implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
  # a silly length limit that causes `expr` to fail if the matched
  # substring is longer than 120 bytes.  So fall back on `printf|sed` if
  # `expr` fails.
  { expr a : '\''\(a\)'\'' >/dev/null 2>&1 &&
    test "X`expr 00001 : '\''.*\(...\)'\''`" = X001 >/dev/null 2>&1 &&
    expr X/"${1}" : '\''.*/\([^/][^/]*\)/*$'\'' \| \
	    X"${1}" : '\''X\(//\)$'\'' \| \
	    X"${1}" : '\''X\(/\)'\'' \| .. 2>/dev/null; } ||
  { printf '\''%s\n'\'' X/"${1}" | sed '\''/^.*\/\([^/][^/]*\)\/*$/{
	      s//\1/
	      q
	    }
	    /^X\/\(\/\/\)$/{
	      s//\1/
	      q
	    }
	    /^X\/\(\/\).*/{
	      s//\1/
	      q
	    }
	    s/.*/./; q'\''; }
}
fi') || :

## pushvar ##
echo "${st_import}" | grep '^pushvar' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# pushvar <VAR>
# ----------------------
# push a value into the stack <VAR>, if the stack doesn'\''t exists, create one.
'"${pushvar}"' ()
{
  while test "$#" -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \${${1}+y}" 2> /dev/null ||
        { printf %s\\n "'\''${1}'\'' is undefined" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
    esac
    # check stack level
    eval "test \"\${${1}_level:=0}\" -ge 0" 2> /dev/null ||
    { printf %s\\n "invalid '\''${1}_level'\'': not an integer" >&2; return 127; }
    # assign value to stack
    eval "eval \"${1}_\${${1}_level}=\\\"\\\${${1}}\\\"\"" || return 125
    # increment stack level
    eval "${1}_level=\$(( 1 + \${${1}_level} ))" || return 125
    test "$#" -gt 1 || return 0
    shift 2> /dev/null || return 125
  done
}') || :

## popvar ##
echo "${st_import}" | grep '^popvar' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# popvar <VAR>
# ----------------------
# pops a value from the stack and assign it to <VAR>
'"${popvar}"' ()
{
  while test "$#" -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \"\${${1}_level:-0}\" -ge 0" > /dev/null ||
        { printf %s\\n "not a stack '\''${1}'\''" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
    esac
    # check if the stack is empty
    eval "test \"\${${1}_level:-0}\" -gt 0" || return 1
    # decrement stack level
    eval "${1}_level=\$(( \${${1}_level} - 1 ))" || return 125
    # assign stack item to ${1}
    eval "eval \"${1}=\\\"\\\${${1}_\${${1}_level}:=}\\\"\""
    # unset stack value
    eval "unset \"${1}_\${${1}_level}\"" 2> /dev/null || :
    test "$#" -gt 1 || return 0
    shift 2> /dev/null || return 125
  done
}') || :

## bigint_add ##
echo "${st_import}" | grep '^bigint_add' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# bigint_add <INTEGER> <INTEGER>
# --------------------------------
# Portably adds two unsigned decimal integers of arbitrary size. Returns a
# non-zero status code when the number of parameters != 2, or if any argument
# isn'\''t a valid unsigned decimal.
# 
# NOTE: Integer max size vary per shell, some shells mishandle large variables
# and arguments, for example, Solaris 10 dtksh and the UnixWare 7.1.1 mishandle
# braced variable expansion that crosses a 1024 or 4096-byte boundary.
# @author: Lohann Paterno Coutinho Ferreira <developer@lohann.dev>
# 
# Design Choices:
# 1. Portability over Speed: If you want speed shell is already the wrong
#    choice. Shell is mostly used to interact with heterogeneus unix systems,
#    sysadmin automations and detect system dependencies (ex: GNU Autoconf),
#    once the shell is used as first step to build other programns, is more
#    important for it be predictable (works same way anywhere) and portable
#    (works in a wide range of different systems). that'\''s why some
#    unconventional choices were made here, like don'\''t use of external tools
#    such as sed, awk, bc, etc. (except in some ancient shells, where "test"
#    and "echo" are actually external programns).
#
# 2. Isolation: Shell builtins like "test", "echo", "set" and "return" are
#    quoted to prevent them from being mistakenly replaced by user defined
#    aliases, whoever still breaks when builtins are disabled or renamed.
#
# 3. No Globals, No Locals: The `local` builtin is not supported in all shells
#    (Ex: ksh), also is not part of POSIX Shell Standard. Using variables
#    inside function may overwrite user global ones, to prevent global scope
#    collisions while not sacrifice portability, this method uses positional
#    parameters instead, which have performance drawback.
#
# 4. IFS Safe: Works regardless the IFS value set in the current environment,
#    all expanded arguments are double quoted, including $# and $?, otherwise
#    the code breaks when IFS contains numbers, look this example:
#    BAD:
#    bash -c '\''IFS=0123456789; [ 0 -le  $# ] && echo "$# >= 0" || echo "$# < 0"'\''
#    output: 0 < 0
#
#    GOOD:
#    bash -c '\''IFS=0123456789; [ test 0 -le "$#" ] && echo "$# >= 0" || echo "$# < 0"'\''
#    output: 0 >= 0
'"${bigint_add}"' ()
{
  # Validate parameters
  "test" "$#" -gt 0 || { "echo" "'"${bigint_add}"':$LINENO: missing operands" >&2; "return" 1; }
  "test" "$#" -gt 1 || { "echo" "'"${bigint_add}"':$LINENO: missing second operand" >&2; "return" 1; }
  "test" "$#" -eq 2 || { "echo" "'"${bigint_add}"':$LINENO: extra operand \"$3\"" >&2; "return" 1; }

  # Initialize positional variables
  #        lhs: $1 left number
  #        rhs: $2 right number
  #      carry: $3 carry bit set to 1 or empty
  # lhs_suffix: $4 left number processed digits, used for pattern matching.
  # rhs_suffix: $5 right number computed digits, used for pattern matching.
  #  lhs_digit: $6 left number decimal digit
  #  rhs_digit: $7 right number decimal digit
  #     result: $8 result of lhs + rhs
  "set" "$1" "$2" "" "" "" 0 0 "" || "return" "$?"

  # Starts the carrying addition loop, each iteration computes one decimal digit
  while ":"
  do
    # Extract left number next digit using pattern matching.
    case $1 in
      $4)
        # All digits of the left number were processed
        if test "x$2" = "x$5"
        then "echo" "$3$8"; "return" 0
        else "set" "$2" 0 "$3" "$5" 0 0 0 "$8" && "continue" || "return" "$?"
        fi
        ;;
      *0$4) "set" "$1" "$2" "$3" "0$4" "$5" 0 "$7" "$8" || "return" "$?" ;;
      *1$4) "set" "$1" "$2" "$3" "1$4" "$5" 1 "$7" "$8" || "return" "$?" ;;
      *2$4) "set" "$1" "$2" "$3" "2$4" "$5" 2 "$7" "$8" || "return" "$?" ;;
      *3$4) "set" "$1" "$2" "$3" "3$4" "$5" 3 "$7" "$8" || "return" "$?" ;;
      *4$4) "set" "$1" "$2" "$3" "4$4" "$5" 4 "$7" "$8" || "return" "$?" ;;
      *5$4) "set" "$1" "$2" "$3" "5$4" "$5" 5 "$7" "$8" || "return" "$?" ;;
      *6$4) "set" "$1" "$2" "$3" "6$4" "$5" 6 "$7" "$8" || "return" "$?" ;;
      *7$4) "set" "$1" "$2" "$3" "7$4" "$5" 7 "$7" "$8" || "return" "$?" ;;
      *8$4) "set" "$1" "$2" "$3" "8$4" "$5" 8 "$7" "$8" || "return" "$?" ;;
      *9$4) "set" "$1" "$2" "$3" "9$4" "$5" 9 "$7" "$8" || "return" "$?" ;;
      *) "echo" "fn_add:$LINENO: invalid number \"$1\"" >&2; "return" 1 ;;
    esac

    # Extract right number next digit using pattern matching.
    case $2 in
      $5) :
        # All digits of the right number were added, whoever we are still
        # computing the left number digit + carry bit. 
        ;;
      *0$5) "set" "$1" "$2" "$3" "$4" "0$5" "$6" 0 "$8" || "return" "$?" ;;
      *1$5) "set" "$1" "$2" "$3" "$4" "1$5" "$6" 1 "$8" || "return" "$?" ;;
      *2$5) "set" "$1" "$2" "$3" "$4" "2$5" "$6" 2 "$8" || "return" "$?" ;;
      *3$5) "set" "$1" "$2" "$3" "$4" "3$5" "$6" 3 "$8" || "return" "$?" ;;
      *4$5) "set" "$1" "$2" "$3" "$4" "4$5" "$6" 4 "$8" || "return" "$?" ;;
      *5$5) "set" "$1" "$2" "$3" "$4" "5$5" "$6" 5 "$8" || "return" "$?" ;;
      *6$5) "set" "$1" "$2" "$3" "$4" "6$5" "$6" 6 "$8" || "return" "$?" ;;
      *7$5) "set" "$1" "$2" "$3" "$4" "7$5" "$6" 7 "$8" || "return" "$?" ;;
      *8$5) "set" "$1" "$2" "$3" "$4" "8$5" "$6" 8 "$8" || "return" "$?" ;;
      *9$5) "set" "$1" "$2" "$3" "$4" "9$5" "$6" 9 "$8" || "return" "$?" ;;
      *) "echo" "fn_add:$LINENO: invalid number \"$1\"" >&2; "return" 1 ;;
    esac
    
    # Swap digits if the right digit is greater than the left digit
    "test" "$6" -ge "$7" || "set" "$1" "$2" "$3" "$4" "$5" "$7" "$6" "$8"

    # Single Digit Carrying Add
    # The carrying addition is computed using exaustive pattern matching, which
    # have the downside of being very slow and the benefit of being universally
    # portable even in ancient bourne shells, notice this script prioritizes
    # portability and correctness over speed. Arithmetic Expansion is not
    # supported by some shells (most notably Solaris 10 /bin/sh).
    # 
    # The pattern matching logic below is equivalent to this:
    # if [ $carry == 1 ]; then
    #   digit=$(( ($lhs_digit + $rhs_digit + 1) % 10 ))
    #   carry=$(( ($lhs_digit + $rhs_digit + 1) / 10 ))
    # else
    #   digit=$(( ($lhs_digit + $rhs_digit) % 10 ))
    #   carry=$(( ($lhs_digit + $rhs_digit) / 10 ))
    # fi
    # Obs: Doing "$lhs_digit + $rhs_digit + $carry" has no difference here
    # because pattern matching must be exaustive, eliminate one block simply
    # means rewrite a 2x bigger 3 digit pattern matching block.
    if "test" "$3"
    then
      # Carry bit is set, so compute next digit:
      # digit = (lhs_digit + rhs_digit + 1) % 10
      # carry = (lhs_digit + rhs_digit + 1) / 10
      case $6$7 in
        00) "set" "$1" "$2" "" "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        10) "set" "$1" "$2" "" "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        11|20) "set" "$1" "$2" "" "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        30|21) "set" "$1" "$2" "" "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        40|31|22) "set" "$1" "$2" "" "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        50|41|32) "set" "$1" "$2" "" "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        60|51|42|33) "set" "$1" "$2" "" "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        70|61|52|43) "set" "$1" "$2" "" "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        80|71|62|53|44) "set" "$1" "$2" "" "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        90|81|72|63|54) "set" "$1" "$2" 1 "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        91|82|73|64|55) "set" "$1" "$2" 1 "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        92|83|74|65) "set" "$1" "$2" 1 "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        93|84|75|66) "set" "$1" "$2" 1 "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        94|85|76) "set" "$1" "$2" 1 "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        95|86|77) "set" "$1" "$2" 1 "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        96|87) "set" "$1" "$2" 1 "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        97|88) "set" "$1" "$2" 1 "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        98) "set" "$1" "$2" 1 "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        99) "set" "$1" "$2" 1 "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        *) "echo" "'"${bigint_add}"': invalid digits \"$6$7\"" >&2; "return" 1 ;;
      esac
    else
      # No carry bit, compute next digit:
      # digit = (lhs_digit + rhs_digit) % 10
      # carry = (lhs_digit + rhs_digit) / 10
      case $6$7 in
        00) "set" "$1" "$2" "" "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        10) "set" "$1" "$2" "" "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        11|20) "set" "$1" "$2" "" "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        30|21) "set" "$1" "$2" "" "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        40|31|22) "set" "$1" "$2" "" "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        50|41|32) "set" "$1" "$2" "" "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        60|51|42|33) "set" "$1" "$2" "" "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        70|61|52|43) "set" "$1" "$2" "" "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        80|71|62|53|44) "set" "$1" "$2" "" "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        90|81|72|63|54) "set" "$1" "$2" "" "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        91|82|73|64|55) "set" "$1" "$2" 1 "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        92|83|74|65) "set" "$1" "$2" 1 "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        93|84|75|66) "set" "$1" "$2" 1 "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        94|85|76) "set" "$1" "$2" 1 "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        95|86|77) "set" "$1" "$2" 1 "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        96|87) "set" "$1" "$2" 1 "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        97|88) "set" "$1" "$2" 1 "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        98) "set" "$1" "$2" 1 "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        99) "set" "$1" "$2" 1 "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        *) "echo" "'"${bigint_add}"': invalid digits \"$6$7\"" >&2; "return" 1 ;;
      esac
    fi
  done
  # Unreachable code: no break statement exist inside the while loop.
  "echo" "'"${bigint_add}"': unrechable code executed, please report this bug" >&2
  "return" 127
} # '"${bigint_add}"'') || :

## clean_dir ##
echo "${st_import}" | grep '^clean_dir' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# clean_dir <DIR>
# ------------------
# Remove all contents from within DIR, including any unwritable
# subdirectories, but leave DIR itself untouched.
'"${clean_dir}"' ()
{
  test "$#" -eq 1 || return 127;
  test "x${1}" != x || { printf '\''%s\n'\'' "directory name is empty" >&2; return 127; };
  test -d "${1}" || { printf '\''%s\n'\'' "directory not found '\''${1}'\''" >&2; return 1; };

  # Check if the directory is empty
  # ref: https://www.etalabs.net/sh_tricks.html
  # (
  case $- in
    *f* ) printf '\''%s\n'\'' "pathname expansion is disabled, please enable it '\''set +f'\''" >&2; return 127 ;;
    * ) : ;;
  esac
  (cd "${1}" || return 127
  set x .[!.]* && shift || return 127
  test ! -f "${1}" || return 0
  set x ..?*  && shift || return 127
  test ! -f "${1}" || return 0
  set x * && shift || return 127
  test ! -f "${1}" || return 0
  shift || return 127
  return 7;) ||
  case $? in 7 ) return 0 ;; * ) return 127 ;; esac
  
  find "${1}" -type d ! -perm -700 -exec chmod u+rwx {} \; || :
  rm -fr "${1}"* "${1}".[!.] "${1}".??*
}') || :

## dirname ##
echo "${st_import}" | grep '^dirname' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1037-L1079

# dirname <PATH>
# ---------------------
# Polyfill for the command '\''dirname FILE-NAME'\''. Not all systems have
# dirname.
if (st_dir=`'\''dir'\'\''name'\'' -- /` && test "X$st_dir" = X/) >/dev/null 2>&1;
then :
else '"${dirname}"' ()
{
  test "$#" -gt 0 ||
  { echo '\'''"${dirname}"': missing operand'\'' >&2; return 127; };
  if test x"${1}" = '\''x--'\''
  then
    shift > /dev/null ||
    { echo '\'''"${dirname}"': shift failed'\'' >&2; return 127; };
    test "$#" -gt 0 ||
    { echo '\'''"${dirname}"': missing operand'\'' >&2; return 127; };
  else :
  fi

  # Prefer `expr` to `printf|sed`, since expr is usually faster and it handles
  # backslashes and newlines correctly.  However, older expr
  # implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
  # a silly length limit that causes `expr` to fail if the matched
  # substring is longer than 120 bytes.  So fall back on `printf|sed` if
  # `expr` fails.
  { expr a : '\''\(a\)'\'' >/dev/null 2>&1 &&
    test "X`expr 00001 : '\''.*\(...\)'\''`" = X001 >/dev/null 2>&1 &&
    expr X"${1}" : '\''X\(.*[^/]\)//*[^/][^/]*/*$'\'' \| \
	  X"${1}" : '\''X\(//\)[^/]'\'' \| \
	  X"${1}" : '\''X\(//\)$'\'' \| \
	  X"${1}" : '\''X\(/\)'\'' \| . 2>/dev/null; } ||
  { printf '\''%s\n'\'' X"${1}" | sed '\''/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
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
	  s/.*/./; q'\''; }
}
fi') || :

## printf_colors ##
echo "${st_import}" | grep '^printf_colors' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# printf_colors FMT ...ARGS
# ----------------------------------------
# Extend printf escape sequences to support colors.
# if available uses `tput` to detect if the current
# terminal supports colors, then query a default escape
# sequences for errors (red), warnings (yellow) and bold.
# When the terminal doesn'\''t support colors calling this 
# function is equivalent to plain printf.
#  errors (red) and warnings (yellow),
# 
# Colors Escapes:
# @n: bold
# @r: red     | @R: red + bold
# @g: green   | @G: green + bold
# @b: blue    | @B: blue + bold
# @y: yellow  | @Y: yellow + bold
# @c: cyan    | @C: cyan + bold
#
# Usage:
# - printf_colors '\''@R @y %s @b @Y @g @C\n'\'' '\''all'\'' '\''colors'\'' '\''mixed'\'' '\''in'\'' '\''the'\'' '\''same'\'' '\''text'\''
# - printf_colors '\''%s\n'\'' '\''normal text'\''
# - printf_colors '\''@n\n'\'' '\''bold text'\''
# - printf_colors '\''@r\n'\'' '\''red text'\''
# - printf_colors '\''@y\n'\'' '\''yellow text'\''
# - printf_colors '\''@R\n'\'' '\''red+bold'\''
# - printf_colors '\''@Y\n'\'' '\''yellow+bold'\''
if test -t 1 && (tput colors && colors=`tput colors` && test "x$colors" != '\''x'\'' && test 8 -le "$colors") >/dev/null 2>&1
then
  # Eval is used to hardcode the escape sequences in the function body,
  # so it doesn'\''t need to rely on global variables for storing colors.
  # isn'\''t possible to change the colors without redefining this function.
  eval "'"${printf_colors}"' ()
{
  test \"\$#\" -gt 0 || { printf; return \"\$?\"; }
  set x '\''eval printf \"x%sx\" \"\$3\" | sed \"\$2\" 2>/dev/null'\'' '\''{
  s/'\''\\'\'\''/'\''\\'\'\''\\\\'\''\\'\''\\'\'\''/g
  s/[\\\\\$\`\"]/\\\\&/g
  s/@[RGBYCrgbycn]/&%s\\\${7}/g
  s/@[RGBYCn]/\\\${1}&/g
  s/@n//g
  s/@[Rr]/\\\${2}/g
  s/@[Gg]/\\\${3}/g
  s/@[Bb]/\\\${4}/g
  s/@[Yy]/\\\${5}/g
  s/@[Cc]/\\\${6}/g
  s/'\''\\'\'\''/'\''\\'\'\''\\\\'\''\\'\''\\'\'\''/g
  1s/^x/shift \\&\\& shift \\&\\& shift \\&\\& set x '\''\\'\''\\\"\\'\'\''\\\\'\''\\'\''\\'\'\''/
  \$s/x\$/'\''\\'\'\''\\\\'\''\\'\''\\'\''\\\"\\'\'\'' \\\"\\\$@\\\" \\&\\& shift/
}'\'' \"\$@\" && shift || return 125
  eval \"\`\$1\`\" || return 125
  set x '\''`tput bold`'\'' '\''`tput setaf 1`'\'' '\''`tput setaf 2`'\'' '\''`tput setaf 4`'\'' '\''`tput setaf 3`'\'' '\''`tput setaf 6`'\'' '\''`tput sgr0`'\'' \"\$@\" && shift || return 125
  eval \"eval '\''shift && shift && shift && shift && shift && shift && shift && shift && set x '\''\$8'\'' \\\"\\\$@\\\" && shift'\''\" || return 125
  printf \"\$@\"
}" || { printf '\''%s\n'\'' "failed to define function '\'''"${printf_colors}"''\'' status $?" >&2; exit 1; }
else '"${printf_colors}"' ()
{
  # terminal doesn'\''t support colors or tput not found, this sed
  # script simply replace all colors escape sequences with `%s`.
  set x '\''eval printf "x%sx" "$3" | sed "$2" 2>/dev/null'\'' '\''{
    s/[\\$`"]/\\&/g
    s/@[RGBYCrgbycn]/%s/g
    1s/^x/shift \&\& shift \&\& shift \&\& set x "/
    $s/x$/" "\$@" \&\& shift/
  }'\'' "$@" && shift || return 125;
  eval "`$1`" || return 125
  printf "$@"
} # '"${printf_colors}"'
fi') || :

## str_to_varname ##
echo "${st_import}" | grep '^str_to_varname' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# valid_varname <STRING>
# ----------------------
# Transform <STRING> into a valid shell variable name.
'"${str_to_varname}"' ()
{
  test "$#" -eq 1 || return 127;

  # Avoid depending upon Character Ranges.
  printf '\''%s\n'\'' "${1}" | sed '\''y%*+%pp%;s%[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]%_%g'\''
}') || :

## trim ##
echo "${st_import}" | grep '^trim' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# trim <STRING>
# ---------------------
# Removes blank characters [ \t\n\r\f\v] from both ends of this string
'"${trim}"' ()
{
  printf '\''%s'\'' "$*" | \
  sed \
    -n \
    -e '\'':begin'\'' \
    -e '\''$bend'\'' \
    -e '\''N'\'' \
    -e '\''bbegin'\'' \
    -e '\'':end'\'' \
    -e '\''s/^[[:space:]]*//'\'' \
    -e '\''s/[[:space:]]*$//'\'' \
    -e '\''p'\''
}') || :

## unix_timestamp ##
echo "${st_import}" | grep '^unix_timestamp' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '
# Sadly `date +%s` is not portable.
# The only magic number in here is 135140, the number of days between
# 1600-01-01 and 1970-01-01 treating both as Gregorian dates. 1600 is
# used as the multiple-of-400 epoch here instead of 2000 since C-style
# division behaves badly with negative dividends.
#
# Original code:
# https://www.etalabs.net/sh_tricks.html

# unix_timestamp
# ---------------------
# Prints the unix timestamp, which is seconds passed since January 1st, 1970 at UTC
if (eval '\''st_time=`TZ=UTC0 LANG=C LC_ALL=C date "+%s"` && test "$st_time" -gt 1000000000'\'') 2> /dev/null
then '"${unix_timestamp}"' ()
{
  TZ=UTC0 LANG=C LC_ALL=C date '\''+%s'\'' 
}
elif (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null
then eval '\'''"${unix_timestamp}"' ()
{
  eval "set x `TZ=UTC0 LANG=C LC_ALL=C date '\''+%Y 1%j 1%H 1%M 1%S'\'' 2>/dev/null`" && test "$#" -eq 6 || return 125
  printf %s\\n $((`TZ=UTC0 LANG=C LC_ALL=C date '\''\'\'\''+((%Y-1600)*365+(%Y-1600)/4-(%Y-1600)/100+(%Y-1600)/400+1%j-1000-135140)*86400+(1%H-100)*3600+(1%M-100)*60+(1%S-100)'\''\'\'\''`))
}'\''
else '"${unix_timestamp}"' ()
{
  eval "set x `TZ=UTC0 LANG=C LC_ALL=C date '\''+%Y 1%j 1%H 1%M 1%S'\'' 2>/dev/null`" && test "$#" -eq 6 || return 125
  eval "set x \"\`eval '\''LC_ALL=C expr \"$2\" \"-\" \"1600\" 2>&1 || test \"\$?\" -eq 1'\''\`\" $3 $4 $5 $6" || return 125
  eval "set x \"\`eval '\''LC_ALL=C expr \"$2\" \"*\" 365 \"+\" \"$2\" \"/\" 4 \"-\" \"$2\" \"/\" 100 \"+\" \"$2\" \"/\" 400 \"+\" \"$3\" \"-\" 1000 \"-\" 135140 2>&1 || test \"\$?\" -eq 1'\''\`\" $4 $5 $6" || return 125
  LC_ALL=C expr "$2" "*" 86400 "+" "(" "$3" "-" 100 ")" "*" 3600 "+" "(" "$4" "-" 100 ")" "*" 60 "+" "(" "$5" "-" 100 ")" || test "$?" -eq 1
}
fi # '"${unix_timestamp}"'') || :

## version_compare ##
echo "${st_import}" | grep '^version_compare' >/dev/null 2>&1 &&
(eval "${st_import}"; printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1742-L1805

# version_compare <VERSION_1> <OP> <VERSION_2>
# ----------------------------------------------------------------------------
# Compare two strings possibly containing shell variables as version strings.
# Valid operator <OP> includes
#  -        LESS THAN: '\''-lt'\'' '\''<'\'' 
#  -    LESS OR EQUAL: '\''-le'\'' '\''<='\'' 
#  -            EQUAL: '\''-eq'\'' '\''='\'' '\''=='\'' 
#  -        NOT EQUAL: '\''-ne'\'' '\''!='\''
#  - GREATER OR EQUAL: '\''-ge'\'' '\''>='\'' 
#  -     GREATER THAN: '\''-gt'\'' '\''>'\'' 
#
# This usage is portable even to ancient awk,
# so don'\''t worry about finding a "nice" awk version.
'"${version_compare}"' ()
{
  test "$#" -eq 3 || { printf '\''%s\n'\'' "usage: '"${version_compare}"' <V1> [-eq|-ne|-gt|-ge|-lt|-le] <V2>
expected 3 arguments, provided $#" >&2; return 127; }

  # Internaly all operators are converted to integers with prime factors
  # 2, 3 and 5, it reduces the amount of logic necessary to evaluate all
  # combinations of expressions and operators.
  # Each basic operator is represent as an unique prime number:
  # -lt = 2
  # -gt = 3
  # -eq = 5
  # Other operators are product of basic operators:
  # -le = -lt || -eq == 2 * 5 == 10
  # -ge = -gt || -eq == 3 * 5 == 15
  # -ne = -lt || -gt == 2 * 3 == 6
  # Then compute N by comparing v1 and v2 as follow:
  # N = 2 when v1 < v2
  # N = 3 when v1 > v2
  # N = 5 when v1 = v2
  # The exit status is OPERATOR % N, which correctly evaluates to zero
  # when the expression is true, and non-zero when the expression is false.
  LANGUAGE=C LC_ALL=C awk '\''
# Use only awk features that work with 7th edition Unix awk (1978).
# My, what an old awk you have, Mr. Solaris!
END {
  # exit status 7 if operator is invalid.
  op = 0
  if (length(v0) == 1) {
    if (v0 ~ /^</) { op = 2 }
    if (v0 ~ /^>/) { op = 3 }
    if (v0 ~ /^=/) { op = 5 }
  } else {
  if (length(v0) == 2) {
    if (v0 ~ /^==/) { op = 5 }
    if (v0 ~ /^!=/) { op = 6 }
    if (v0 ~ /^<=/) { op = 10 }
    if (v0 ~ /^>=/) { op = 15 }
  } else {
  if (length(v0) == 3) {
    if (v0 ~ /^-lt/) { op = 2 }
    if (v0 ~ /^-le/) { op = 10 }
    if (v0 ~ /^-eq/) { op = 5 }
    if (v0 ~ /^-ne/) { op = 6 }
    if (v0 ~ /^-ge/) { op = 15 }
    if (v0 ~ /^-gt/) { op = 3 }
  } else { exit 7 }}}
  if (length(v0) && op) { op += 0 } else { exit 7 }
  while (length(v1) && length(v2)) {
    # Set d1 to be the next thing to compare from v1, and likewise for d2.
    # Normally this is a single character, but if v1 and v2 contain digits,
    # compare them as integers and fractions as strverscmp does.
    if (v1 ~ /^[0-9]/ && v2 ~ /^[0-9]/) {
      # Split v1 and v2 into their leading digit string components d1 and d2,
      # and advance v1 and v2 past the leading digit strings.
      for (len1 = 1; substr(v1, len1 + 1) ~ /^[0-9]/; len1++) continue
      for (len2 = 1; substr(v2, len2 + 1) ~ /^[0-9]/; len2++) continue
      d1 = substr(v1, 1, len1); v1 = substr(v1, len1 + 1)
      d2 = substr(v2, 1, len2); v2 = substr(v2, len2 + 1)
      if (d1 ~ /^0/) {
        if (d2 ~ /^0/) {
          # Compare two fractions.
          while (d1 ~ /^0/ && d2 ~ /^0/) {
            d1 = substr(d1, 2); len1--
            d2 = substr(d2, 2); len2--
          }
          if (len1 != len2 && ! (len1 && len2 && substr(d1, 1, 1) == substr(d2, 1, 1))) {
            # The two components differ in length, and the common prefix
            # contains only leading zeros.  Consider the longer to be less.
            d1 = -len1
            d2 = -len2
          } else {
            # Otherwise, compare as strings.
            d1 = "x" d1
            d2 = "x" d2
          }
        } else {
          # A fraction is less than an integer.
          exit (op % 2)
        }
      } else {
        if (d2 ~ /^0/) {
          # An integer is greater than a fraction.
          exit (op % 3)
        } else {
          # Compare two integers.
          d1 += 0
          d2 += 0
        }
      }
    } else {
      # The normal case, without worrying about digits.
      d1 = substr(v1, 1, 1); v1 = substr(v1, 2)
      d2 = substr(v2, 1, 1); v2 = substr(v2, 2)
    }
    if (d1 < d2) { exit (op % 2) }
    if (d1 > d2) { exit (op % 3) }
  }
  # Beware Solaris 11 /usr/xgp4/bin/awk, which mishandles some
  # comparisons of empty strings to integers.  For example,
  # LC_ALL=C /usr/xpg4/bin/awk "BEGIN {if (-1 < \"\") print \"a\"}"
  # prints "a".
  if (length(v2)) { exit (op % 2) }
  if (length(v1)) { exit (op % 3) }
  exit (op % 5)
}'\'' v0="${2}" v1="${1}" v2="${3}" /dev/null || \
  case $? in
    7 ) printf %s\\n "invalid operator '\''${2}'\''" >&2; return 7 ;;
    [123456] ) return 1 ;;
    * ) return 127 ;;
  esac
}') || :

# cleanup
st_import=''; unset 'st_import';
