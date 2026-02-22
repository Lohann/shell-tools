#!/bin/sh

##################
## SCRIPT START ##
##################
test x"${st_import:-}" != 'x' || st_import='bourne_compatible
shell_sanitize
append
quote
map
test_varname
basename
clean_dir
dirname
popvar
pushvar
sh_escape
str_to_varname
trim
unix_timestamp
version_compare
'

# Remove whitespaces
st_import="$(
LC_ALL=C LANGUAGE=C tr '[\000-\040\176-\377]' '\n' 2>&1 <<EOL
${st_import}
EOL
)" || { printf '%s\n' "[ERROR] tr failed '${st_import}'" >&2; exit 1; }

# Parse options
st_import="$(
LC_ALL=C LANGUAGE=C  sed -n \
  -e "/^\n*$/b end" \
  -e 's/^\([A-Za-z_][A-Za-z0-9_]*\)$/\1=\1/; t ok' \
  -e "/^[A-Za-z_][A-Za-z0-9_]*=[A-Za-z_][A-Za-z0-9_]*$/b ok" \
  -e "s/'/'\\\\''/g" \
  -e "s/^/'/" \
  -e "s/$/'/" \
  -e ':ok' \
  -e 'p' \
  -e ':end' 2>&1 <<EOL
${st_import}
EOL
)" || { printf '%s\n' "[ERROR] sed failed '${st_import}'" >&2; exit 1; }

if test -z "${st_import}"
then exit 0;
else :
fi

# Validate options
(
_imports="${st_import}"
_st_error='';
nl='
';
st_test='['\'']*'
for v in ${_imports};
do
case "${v}" in 
  $st_test ) eval "_st_error=\"\${_st_error}invalid option \"${v}'${nl}'"; continue ;;
  *=* ) a="${v%%[=]*}" ;;
  * ) a="${v}" ;;
esac
case "${a}" in
  bourne_compatible ) : ;;
  shell_sanitize ) : ;;
  append ) : ;;
  quote ) : ;;
  map ) : ;;
  test_varname ) : ;;
  basename ) : ;;
  clean_dir ) : ;;
  dirname ) : ;;
  popvar ) : ;;
  pushvar ) : ;;
  sh_escape ) : ;;
  str_to_varname ) : ;;
  trim ) : ;;
  unix_timestamp ) : ;;
  version_compare ) : ;;
  *) _st_error="${_st_error}unknown option '${a}'${nl}" ;;
esac;
done
test x"${_st_error}" = x || { printf '%s\n%s' '[ERROR] invalid options:' "${_st_error}" >&2; exit 1; }
) || exit $?;
printf "%s\n\n" '#!/bin/sh'
printf '%s\n' '# THIS FILE WAS AUTO-GENERATED USING SHELL-TOOLS v0.1.0-20260222'
printf '%s\n' "#   DATE: `date '+%Y-%m-%d'`"
printf '%s\n' '# SOURCE: https://github.com/Lohann/shell-tools'
printf '%s\n' '# COMMIT: e5b84b296a2f3653333bb2d0c44d748ad79c7b9c'
printf '\n'
printf '%s\n' '# IMPORTED MODULES #'
printf '%s=' "st_import"
# display imports
sed -e "1s/^/'/" -e '$s/$/'\''/' <<EOL
${st_import}
EOL
printf '\n'

## bourne_compatible ##
if grep '^bourne_compatible' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
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
for _st_val in BASH_ENV ENV MAIL MAILPATH CDPATH
do eval "test \${${_st_val}+y}" && \
( (unset "${_st_val}") || exit 1) >/dev/null 2>&1 && unset "${_st_val}" || :
done

# Ensure that fds 0, 1, and 2 are open.
if (exec 3>&0) 2>/dev/null; then :; else exec 0</dev/null; fi
if (exec 3>&1) 2>/dev/null; then :; else exec 1>/dev/null; fi
if (exec 3>&2)            ; then :; else exec 2>/dev/null; fi

# Disable shell features which may cause this script to fail
# those features are saved in st_orig_opts and restored later.
_st_opts='\'''\''
for _st_code in '\''H'\'' '\''a'\'' '\''m'\'' '\''f'\'' '\''e'\'' '\''u'\'' '\''C'\'' '\''B'\''
do
  _st_val="*[${_st_code}]*"
  case $_st_opts in $_st_val ) continue ;; * ) : ;; esac
  case $- in
    $_st_val ) _st_opts="${_st_opts}${_st_code}" ;;
    *[HamfeuCB]* ) continue ;;
    * ) break ;;
  esac
done
test x${_st_opts} = x || \
  { set +${_st_opts} && \
    { test ${st_orig_opts+y} || \
      { st_orig_opts=${_st_opts} && export st_orig_opts; }; }; }
( (unset '\''_st_val'\'') || exit 1) >/dev/null 2>&1 && unset '\''_st_val'\'' '\''_st_code'\'' '\''_st_opts'\'' || :

# The user is always right.
if ${PATH_SEPARATOR+false} :; then
  PATH_SEPARATOR=:
  (PATH='\''/bin;/bin'\''; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 && {
    # shellcheck disable=SC2030,SC2034
    (PATH='\''/bin:/bin'\''; FPATH=${PATH}; sh -c :) >/dev/null 2>&1 ||
      PATH_SEPARATOR='\'';'\''
  }
fi

# Find who we are.  Look in the path if we contain no directory separator.
_st_myself='\'''\''
case "${0}" in
  *[\\/]* ) _st_myself="${0}" ;;
  *)
    _st_ifs_backup="${IFS}"
    IFS="${PATH_SEPARATOR}"
    # shellcheck disable=SC2031
    for _st_dir in ${PATH}
    do
      IFS="${_st_ifs_backup}"
      case "${_st_dir}" in
        '\'''\'') _st_dir='\''./'\'' ;;
        */) ;;
        *) _st_dir="${_st_dir}/" ;;
      esac
      if test -r "${_st_dir}${0}"
      then _st_myself="${_st_dir}${0}"; break;
      else continue;
      fi
    done
    IFS="${_st_ifs_backup}";
    { test ${_st_dir+y} && ( (unset '\''_st_dir'\'') || exit 1) >/dev/null 2>&1 && unset '\''_st_dir'\''; } || :
    { test ${_st_ifs_backup+y} && ( (unset '\''_st_ifs_backup'\'') || exit 1) >/dev/null 2>&1 && unset '\''_st_ifs_backup'\''; } || :
    ;;
esac

# Use a proper internal environment variable to ensure we don'\''t fall
# into an infinite loop, continuously re-executing ourselves.
# shellcheck disable=SC2268
if test x"${_st_can_reexec:-}" != xno && test "x${CONFIG_SHELL:-}" != x; then
  _st_can_reexec=no; export _st_can_reexec;
  # We cannot yet assume a decent shell, so we have to provide a
  # neutralization value for shells without unset; and this also
  # works around shells that cannot unset nonexistent variables.
  # Preserve -v and -x to the replacement shell.
  BASH_ENV=/dev/null
  ENV=/dev/null
  (unset BASH_ENV) >/dev/null 2>&1 && unset BASH_ENV ENV
  case $- in # ((((
    *v*x* | *x*v* ) st_opts=-vx ;;
    *v* ) st_opts=-v ;;
    *x* ) st_opts=-x ;;
    * ) st_opts= ;;
  esac
  # shellcheck disable=SC2248
  exec ${CONFIG_SHELL} ${st_opts} "${_st_myself}" ${1+"$@"}
  # Admittedly, this is quite paranoid, since all the known shells bail
  # out after a failed '\''exec'\''.
  printf "%s\n" "${0}: could not re-execute WITH ${CONFIG_SHELL}" >&2
  exit 255
fi
# We don'\''t want this to propagate to other subprocesses.
{ _st_can_reexec=; unset _st_can_reexec; }

# shellcheck disable=SC2268
if test "x${CONFIG_SHELL}" = x; then
  _st_required="st_fn_return () { (exit \$1); }
st_fn_success () { st_fn_return 0; }
st_fn_failure () { st_fn_return 1; }
st_fn_ret_success () { return 0; }
st_fn_ret_failure () { return 1; }

exitcode=0
st_fn_success || { exitcode=1; echo st_fn_success failed.; }
st_fn_failure && { exitcode=1; echo st_fn_failure succeeded.; }
st_fn_ret_success || { exitcode=1; echo st_fn_ret_success failed.; }
st_fn_ret_failure && { exitcode=1; echo st_fn_ret_failure succeeded.; }
if ( set x; st_fn_ret_success y && test x = \"\$1\" )
then :

else case e in #(
  e) exitcode=1; echo positional parameters were not saved. ;;
esac
fi
test x\$exitcode = x0 || exit 1
blah=\$(echo \$(echo blah))
test x\"\$blah\" = xblah || exit 1
test -x / || exit 1"
  
  if (eval "${_st_required}") 2>/dev/null
  then _st_have_required=yes
  else _st_have_required=no
  fi

  _st_suggested='\''  _st_lineno_1='\''
  _st_suggested=${_st_suggested}${LINENO}
  _st_suggested=${_st_suggested}" _st_lineno_1a=\$LINENO
_st_lineno_2="
  _st_suggested=${_st_suggested}${LINENO}
  _st_suggested=${_st_suggested}" _st_lineno_2a=\$LINENO
eval '\''test \"x\$_st_lineno_1'\''\$_st_run'\''\" != \"x\$_st_lineno_2'\''\$_st_run'\''\" &&
test \"x\`expr \$_st_lineno_1'\''\$_st_run'\'' + 1\`\" = \"x\$_st_lineno_2'\''\$_st_run'\''\"'\'' || exit 1"
  if test "x${_st_have_required}" = xyes && (eval "${_st_suggested}") 2>/dev/null
  then _st_found=yes
  else _st_found=no
  fi

  if test x"${_st_found}" = '\''xno'\'';
  then :
    _st_found=false
    _st_save_IFS="${IFS}"; IFS="${PATH_SEPARATOR}"
    # shellcheck disable=SC2031
    for _st_dir in /bin${PATH_SEPARATOR}/usr/bin${PATH_SEPARATOR}${PATH}
    do
      IFS="${_st_save_IFS}"
      case "${_st_dir}" in
        '\'''\'') _st_dir='\''./'\'' ;;
        */) ;;
        *) _st_dir="${_st_dir}/" ;;
      esac
      _st_found=:
      case "${_st_dir}" in
        /*)
          for _st_base in sh bash ksh sh5
          do
            # Try only shells that exist, to save several forks.
            _st_shell="${_st_dir}${_st_base}"
            if { test -f "${_st_shell}" || test -f "${_st_shell}.exe"; } && _st_run=a "${_st_shell}" -c "${_st_bourne_compatible}""${_st_required}" 2>/dev/null
            then :
              CONFIG_SHELL="${_st_shell}"
              _st_have_required=yes
              if _st_run=a "${_st_shell}" -c "${_st_bourne_compatible}""${_st_suggested}" 2>/dev/null
              then break 2;
              fi
            fi
          done
          _st_base=;unset '\''_st_base'\'';
          _st_shell=;unset '\''_st_shell'\'';
          ;;
        *) : ;;
      esac
      _st_found=false
    done
    IFS="${_st_save_IFS}"
    _st_save_IFS=;unset '\''_st_save_IFS'\'';
    _st_dir=;unset '\''_st_dir'\'';
    
    if ${_st_found}
    then :
    elif test "${SHELL+x}"
    then :
      if { test -f "${SHELL}" || test -f "${SHELL}.exe"; } && _st_run=a "${SHELL}" -c "${_st_bourne_compatible}""${_st_required}" 2>/dev/null
      then :
        CONFIG_SHELL="${SHELL}"
        _st_have_required=yes
      fi
    else :
      printf "%s\n" "$0: shell not found";
      exit 1;
    fi
    _st_found=;unset '\''_st_found'\'';
    _st_bourne_compatible=;unset '\''_st_bourne_compatible'\'';

    if test "x${CONFIG_SHELL}" != x
    then :
      export CONFIG_SHELL
      # We cannot yet assume a decent shell, so we have to provide a
      # neutralization value for shells without unset; and this also
      # works around shells that cannot unset nonexistent variables.
      # Preserve -v and -x to the replacement shell.
      BASH_ENV=/dev/null
      ENV=/dev/null
      (unset BASH_ENV) >/dev/null 2>&1 && unset BASH_ENV ENV
      case $- in
        *v*x* | *x*v* ) st_opts=-vx ;;
        *v* ) st_opts=-v ;;
        *x* ) st_opts=-x ;;
        * ) st_opts= ;;
      esac
      # shellcheck disable=SC2248
      exec ${CONFIG_SHELL} ${st_opts} "${_st_myself}" ${1+"$@"}
      # Admittedly, this is quite paranoid, since all the known shells bail
      # out after a failed '\''exec'\''.
      printf "%s\n" "$0: could not re-execute WITH ${CONFIG_SHELL}" >&2
      exit 255
    fi

    if test "x${_st_have_required}" = xno
    then :
      printf "%s\n" "$0: This script requires a shell more modern than all"
      printf "%s\n" "$0: the shells that I found on your system."
      if test ${ZSH_VERSION+y} ; then
        printf "%s\n" "$0: In particular, zsh ${ZSH_VERSION} has bugs and should"
        printf "%s\n" "$0: be upgraded to zsh 4.3.4 or later."
      else
        printf "%s\n" "$0: Please install a modern shell, or manually run the
$0: script under such a shell if you do have one."
      fi
      exit 1
    fi
    _st_have_required=;unset '\''_st_have_required'\'';
  else :
  fi
fi

# re-enable posix compatible shell options previously disabled.
if test ${st_orig_opts+y} \
&& test "x${st_orig_opts}" != x \
&& (set -o) > /dev/null 2>&1
then
  for _st_code in '\''f'\'' '\''e'\'' '\''u'\'' '\''C'\''
  do
    _st_pat="*[${_st_code}]*"
    case $st_orig_opts in $_st_pat ) : ;; * ) continue ;; esac
    case $- in $_st_pat ) continue ;; * ) set "-${_st_code}" ;; esac
  done
else :
fi

# cleanup
st_orig_opts='\'''\''; unset '\''st_orig_opts'\''
_st_opts='\'''\''; unset '\''_st_opts'\''
_st_code='\'''\''; unset '\''_st_code'\''
_st_pat='\'''\''; unset '\''_st_pat'\'''
)
else :
fi

## shell_sanitize ##
if grep '^shell_sanitize' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L551-L564

# shell_sanitize
# -----------------
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly. It is based on the m4sh.at Autotest testcases.
if (eval '\''as_fn_return () { (exit $1); }
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
test x$exitcode = x0 || exit 1'\'') > /dev/null 2>&1
then :
else
  echo shell doesn\'\''t support functions correctly >&2;
  exit 1;
fi

# This is a spy to detect "in the wild" shells that do not support
# the newer $(...) form of command substitutions.
if (eval '\''blah=$(echo $(echo blah))
test x"$blah" = xblah'\'') > /dev/null 2>&1
then :
else
  echo command substitutions \'\'''\''$(...)'\''\'\'' not supported >&2;
  exit 2;
fi

# These days, we require that '\''test -x'\'' works.
if (eval "test -x / || exit 1") > /dev/null 2>&1
then :
else
  echo shell doesn\'\''t support '\''test -x <file>'\'' >&2;
  exit 3;
fi'
)
else :
fi

## append ##
if grep '^append' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# append VAR VALUE
# ----------------------
# Append the text in VALUE to the end of the definition contained in VAR. Take
# advantage of any shell optimizations that allow amortized linear growth over
# repeated appends, instead of the typical quadratic growth present in naive
# implementations.
if (eval "st_var=1; st_var+=2; test x\$st_var = x12") 2>/dev/null
then eval '\''
'"${append}"' ()
{
  eval "${1}+=\"\${2}\""
}'\''
else
'"${append}"' ()
{
  eval "${1}=\"\${${1}}\${2}\""
}
fi'
)
else :
fi

## quote ##
if grep '^quote' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# quote <STRING>
# ----------------------
# wraps the string in single quotes.
'"${quote}"' ()
{
  printf %s "x${*}x" | sed -e "s/'\''/'\''\\\\'\'''\''/g" -e "1s/^x/'\''/" -e '\''$s/x$/'\''\'\'''\''/'\''
}'
)
else :
fi

## map ##
if grep '^map' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# map <CODE> [...VALUE]
# ----------------------
# Assign each <VALUE> to $1 and eval <CODE>.
'"${map}"' ()
{
  test $# -gt 0 || return 1;
  eval '\''while test $# -gt 1; do
  shift > /dev/null 2>&1 || return $?;
  eval '\''"`printf %s "x${1}x" | sed -e "s/'\''/'\''\\\\\\\\'\'''\''/g" -e "1s/^x/'\''/" -e '\''$s/x$/'\''\'\'''\''/'\''`"'\''
done
return 0'\''
}'
)
else :
fi

## test_varname ##
if grep '^test_varname' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# valid_varname <STRING>
# ----------------------
# Check all arguments, check if <STRING> is a valid shell varname
'"${test_varname}"' ()
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
}'
)
else :
fi

## basename ##
if grep '^basename' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
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
if (basename -- /) >/dev/null 2>&1 && test "X`basename -- / 2>&1`" = "X/";
then :
else :
'"${basename}"' ()
{
  test $# -gt 0 || { echo '\''basename: missing operand'\'' >&2; return 127; };
  if test x"${1}" = '\''x--'\''
  then
    shift > /dev/null 2>&1 || { echo '\''basename: shift failed'\'' >&2; return 127; };
    test $# -gt 0 || { echo '\''basename: missing operand'\'' >&2; return 127; };
  else :
  fi

  # Prefer `expr` to `printf|sed`, since expr is usually faster and it handles
  # backslashes and newlines correctly.  However, older expr
  # implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
  # a silly length limit that causes `expr` to fail if the matched
  # substring is longer than 120 bytes.  So fall back on `printf|sed` if
  # `expr` fails.
  {
    expr a : '\''\(a\)'\'' >/dev/null 2>&1 && \
    test "X`expr 00001 : '\''.*\(...\)'\''`" = X001 >/dev/null 2>&1 && \
    expr X/"${1}" : '\''.*/\([^/][^/]*\)/*$'\'' \| \
	    X"${1}" : '\''X\(//\)$'\'' \| \
	    X"${1}" : '\''X\(/\)'\'' \| .. 2>/dev/null;
  } || {
    printf '\''%s\n'\'' X/"$1" | sed '\''/^.*\/\([^/][^/]*\)\/*$/{
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
	    s/.*/./; q'\'';
  };
}
fi'
)
else :
fi

## clean_dir ##
if grep '^clean_dir' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# clean_dir <DIR>
# ------------------
# Remove all contents from within DIR, including any unwritable
# subdirectories, but leave DIR itself untouched.
'"${clean_dir}"' ()
{
  test $# -eq 1 || return 127;
  test "x${1}" != x || { printf '\''%s\n'\'' "directory name is empty" >&2; return 127; };
  test -d "${1}" || { printf '\''%s\n'\'' "directory not found '\''${1}'\''" >&2; return 1; };

  # Check if the directory is empty
  # ref: https://www.etalabs.net/sh_tricks.html
  # (
  case "$-" in
    *f* ) printf '\''%s\n'\'' "pathname expansion is disabled, please enable it '\''set +f'\''" >&2; return 127 ;;
    * ) : ;;
  esac
  (
  cd "${1}" || return 127
  set x .[!.]* && shift || return 127
  test ! -f "${1}" || return 0
  set x ..?*  && shift || return 127
  test ! -f "${1}" || return 0
  set x * && shift || return 127
  test ! -f "${1}" || return 0
  shift || return 127
  return 7
  ) || case $? in 7 ) return 0 ;; * ) return 127 ;; esac
  
  find "${1}" -type d ! -perm -700 -exec chmod u+rwx {} \; || :
  rm -fr "${1}"* "${1}".[!.] "${1}".??*
}'
)
else :
fi

## dirname ##
if grep '^dirname' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1037-L1079

# dirname <PATH>
# ---------------------
# Polyfill for the command '\''dirname FILE-NAME'\''. Not all systems have
# dirname.
if (st_dir=`dirname -- /` && test "X$st_dir" = X/) >/dev/null 2>&1;
then :
else :
'"${dirname}"' ()
{
  test $# -gt 0 || { echo '\''dirname: missing operand'\'' >&2; return 127; };
  if test x"${1}" = '\''x--'\''
  then
    shift > /dev/null || { echo '\''dirname: shift failed'\'' >&2; return 127; };
    test $# -gt 0 || { echo '\''dirname: missing operand'\'' >&2; return 127; };
  else :
  fi

  # Prefer `expr` to `printf|sed`, since expr is usually faster and it handles
  # backslashes and newlines correctly.  However, older expr
  # implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
  # a silly length limit that causes `expr` to fail if the matched
  # substring is longer than 120 bytes.  So fall back on `printf|sed` if
  # `expr` fails.
  {
    expr a : '\''\(a\)'\'' >/dev/null 2>&1 && \
    test "X`expr 00001 : '\''.*\(...\)'\''`" = X001 >/dev/null 2>&1 && \
    expr X"${1}" : '\''X\(.*[^/]\)//*[^/][^/]*/*$'\'' \| \
	  X"${1}" : '\''X\(//\)[^/]'\'' \| \
	  X"${1}" : '\''X\(//\)$'\'' \| \
	  X"${1}" : '\''X\(/\)'\'' \| . 2>/dev/null;
  } || {
    printf '\''%s\n'\'' X"${1}" | sed '\''/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
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
	  s/.*/./; q'\'';
  };
}
fi'
)
else :
fi

## popvar ##
if grep '^popvar' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# popvar <VAR>
# ----------------------
# pops a value from the stack and assign it to <VAR>
'"${popvar}"' ()
{
  while test $# -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \"\${${1}_level:-0}\" -ge 0" > /dev/null || \
        { printf %s\\n "not a stack '\''${1}'\''" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
    esac
    # check if the stack is empty
    eval "test \"\${${1}_level:-0}\" -gt 0" || return 1
    # decrement stack level
    eval "${1}_level=\$(( \${${1}_level} - 1 ))" || return 127
    # assign stack item to ${1}
    eval "eval \"${1}=\\\"\\\${${1}_\${${1}_level}:=}\\\"\""
    # unset stack value
    eval "unset \"${1}_\${${1}_level}\"" 2> /dev/null || :
    test $# -gt 1 || return 0
    shift 2> /dev/null || return $?
  done
}'
)
else :
fi

## pushvar ##
if grep '^pushvar' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# pushvar <VAR>
# ----------------------
# push a value into the stack <VAR>, if the stack doesn'\''t exists, create one.
'"${pushvar}"' ()
{
  while test $# -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \${${1}+y}" 2> /dev/null || \
        { printf %s\\n "'\''${1}'\'' is undefined" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '\''${1}'\''" >&2; return 127 ;;
    esac
    # check stack level
    eval "test \"\${${1}_level:=0}\" -ge 0" 2> /dev/null || \
    { printf %s\\n "invalid '\''${1}_level'\'': not an integer" >&2; return 127; }
    # assign value to stack
    eval "eval \"${1}_\${${1}_level}=\\\"\\\${${1}}\\\"\"" || return 127
    # increment stack level
    eval "${1}_level=\$(( 1 + \${${1}_level} ))" || return 127
    test $# -gt 1 || return 0
    shift 2> /dev/null || return 127
  done
}'
)
else :
fi

## sh_escape ##
if grep '^sh_escape' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# sh_escape [...ARGS]
# ----------------------
# Escape and quote the provided arguments, the printed string
# string can be safely evaluated by shell.
'"${sh_escape}"' ()
{
  while test $# -gt 0; do
    if tr '\''\n'\'' '\'' '\'' <<EOF | grep '\''^[-[:alnum:]_=,./:]* $'\'' >/dev/null 2>&1
${1}
EOF
    then printf %s "${1}"
    else
      printf %s "x${1}x" | \
      sed \
        -n \
        -e '\'':begin'\'' \
        -e '\''$bend'\'' \
        -e '\''N'\'' \
        -e '\''bbegin'\'' \
        -e '\'':end'\'' \
        -e "s/'\''/'\''\\\\'\'''\''/g" \
        -e "s/^x/'\''/" \
        -e '\''s/x$/'\''\'\'''\''/'\'' \
        -e "s#^'\''\([-[:alnum:]_,./:]*\)=\(.*\)\$#\1='\''\2#" \
        -e '\''p'\''
    fi
    test $# -gt 1 || return 0
    shift 2> /dev/null || return $?
    printf %s '\'' '\''
  done
}'
)
else :
fi

## str_to_varname ##
if grep '^str_to_varname' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# valid_varname <STRING>
# ----------------------
# Transform <STRING> into a valid shell variable name.
'"${str_to_varname}"' ()
{
  test $# -eq 1 || return 127;

  # Avoid depending upon Character Ranges.
  printf '\''%s\n'\'' "${1}" | sed '\''y%*+%pp%;s%[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]%_%g'\''
}'
)
else :
fi

## trim ##
if grep '^trim' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
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
}'
)
else :
fi

## unix_timestamp ##
if grep '^unix_timestamp' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
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
if (eval '\''st_time=`date "+%s"` && test "$st_time" -gt 1000000000'\'') 2> /dev/null
then eval "
'"${unix_timestamp}"' ()
{
  date '\''+%s'\'' 
}"
elif (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null
then eval '\''
'"${unix_timestamp}"' ()
{
printf %s\\n $((`TZ=GMT0 LANGUAGE=C LC_ALL=C date \
'\''\'\'''\''+((%Y-1600)*365+(%Y-1600)/4-(%Y-1600)/100+(%Y-1600)/400+1%j-1000-135140)*86400+(1%H-100)*3600+(1%M-100)*60+(1%S-100)'\''\'\'''\''`))
}'\''
else eval '\''
unix_timestamp () 
{ 
(d=`TZ=GMT0 LANGUAGE=C LC_ALL=C date '\''\'\'''\''+y=%Y;j=1%j;h=1%H;m=1%M;s=1%S'\''\'\'''\'' 2> /dev/null` && \
eval "${d}" 2> /dev/null && \
expr \( \( $y \- 1600 \) \* 365 \+ \( $y \- 1600 \) \/ 4 \- \( $y \- 1600 \) \/ 100 \+ \( $y \- 1600 \) \/ 400 \+ $j \- 1000 \- 135140 \) \* 86400 \+ \( $h \- 100 \) \* 3600 \+ \( $m \- 100 \) \* 60 \+ \( $s \- 100 \))
}'\''
fi # unix_timestamp'
)
else :
fi

## version_compare ##
if grep '^version_compare' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
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
  test $# -eq 3 || { printf '\''%s\n'\'' "usage: version_compare <V1> [-eq|-ne|-gt|-ge|-lt|-le] <V2>
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
}'
)
else :
fi

# cleanup
st_import=; unset 'st_import';
