#!/bin/sh

# code adapted from GNU autoconf v2.72
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
    set -o posix > /dev/null 2>&1
    ;;
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
for _st_val in BASH_ENV ENV MAIL MAILPATH CDPATH
do
  if eval "test \${${_st_val}+y}"
  then { ( (unset "${_st_val}") || exit 1) >/dev/null 2>&1 && unset "${_st_val}"; } || :
  else :
  fi
done
{ ( (unset '_st_val') || exit 1) >/dev/null 2>&1 && unset '_st_val'; } || :

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

# Find who we are.  Look in the path if we contain no directory separator.
_st_myself=
case "${0}" in
  *[\\/]* ) _st_myself="${0}" ;;
  *)
    _st_ifs_backup="${IFS}"
    IFS="${PATH_SEPARATOR}"
    # shellcheck disable=SC2031
    for _st_val in ${PATH}
    do
      IFS="${_st_ifs_backup}"
      case "${_st_val}" in
        '') _st_val='./' ;;
        */) ;;
        *) _st_val="${_st_val}/" ;;
      esac
      test -r "${_st_val}${0}" && _st_myself="${_st_val}${0}" && break
    done
    IFS="${_st_ifs_backup}";
    _st_val=;unset '_st_val';
    _st_ifs_backup=;unset '_st_ifs_backup';
    ;;
esac

# We did not find ourselves, most probably we were run as 'sh COMMAND'
# in which case we are not to be found in the path.
test "x${_st_myself}" != 'x' || _st_myself="${0}"
test -f "${_st_myself}" || { printf "%s\n" "${_st_myself}: error: cannot find myself; rerun with an absolute file name" >&2; exit 1; };

# Temporary disable shell features which may cause troubles
# shellcheck disable=SC2006

_st_val="${_st_opts:-}"
_st_val="${_st_val%%"${nl}"*}"
if test x"${_st_val}" != "x#${_st_myself}" && (set -o) > /dev/null 2>&1
then
  _st_opts="#${_st_myself}"
  for v in H=histexpand x=xtrace v=verbose f=noglob e=errexit u=nounset; do
    _st_opt_letter="${v%%[=]*}"
    _st_opt_name="${v#*[=]}"
    case $- in
      *"${_st_opt_letter}"*)
        _st_opts="${_st_opts}${nl}set -${_st_opt_letter}" ;;
      *)
        case `(set -o) 2> /dev/null` in
          *"${_st_opt_name}"*) _st_opts="${_st_opts}${nl}set +${_st_opt_letter}" ;;
          *) continue ;;
        esac ;;
    esac
    case "${_st_opt_letter}" in
      *v*|*x*) continue ;;
      *) set "+${_st_opt_letter}" ;;
    esac
  done
  test "x${_st_opts}" = 'x' || export _st_opts
  # shellcheck disable=SC3040
  case `(set -o) 2> /dev/null` in *pipefail*) set -o pipefail ;; *) : ;; esac;

  # cleanup
  { ( (unset _st_opt_name) || exit 1) >/dev/null 2>&1 && unset _st_opt_name; } || :
  { ( (unset _st_opt_letter) || exit 1) >/dev/null 2>&1 && unset _st_opt_letter; } || :
else :
fi

# Use a proper internal environment variable to ensure we don't fall
# into an infinite loop, continuously re-executing ourselves.
# shellcheck disable=SC2268
if test x"${_st_can_reexec:=}" != xno && test "x${CONFIG_SHELL:=}" != x; then
  _st_can_reexec=no; export _st_can_reexec;

  # We cannot yet assume a decent shell, so we have to provide a
  # neutralization value for shells without unset; and this also
  # works around shells that cannot unset nonexistent variables.
  # Preserve -v and -x to the replacement shell.
  BASH_ENV=/dev/null
  ENV=/dev/null
  (unset BASH_ENV) >/dev/null 2>&1 && unset BASH_ENV ENV
  case $- in # ((((
    *v*x* | *x*v* ) as_opts=-vx ;;
    *v* ) as_opts=-v ;;
    *x* ) as_opts=-x ;;
    * ) as_opts= ;;
  esac
  # shellcheck disable=SC2248
  exec ${CONFIG_SHELL} ${as_opts} "${_st_myself}" ${1+"$@"}
  # Admittedly, this is quite paranoid, since all the known shells bail
  # out after a failed 'exec'.
  printf "%s\n" "${0}: could not re-execute WITH ${CONFIG_SHELL}" >&2
  exit 255
fi
# We don't want this to propagate to other subprocesses.
{ _st_can_reexec=; unset _st_can_reexec; }

# shellcheck disable=SC2268
if test "x${CONFIG_SHELL}" = x; then
  as_bourne_compatible="if test \${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1;
then :
  emulate sh
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on \${1+\"\$@\"}, which
  # is contrary to our usage.  Disable this feature.
  alias -g '\${1+\"\$@\"}'='\"\$@\"'
  setopt NO_GLOB_SUBST
else
  case \`(set -o) 2>/dev/null\` in
    *posix*) set -o posix > /dev/null 2>&1 ;;
    *) : ;;
  esac
fi
_st_opts='${_st_opts:-}'
"
  as_required="as_fn_return () { (exit \$1); }
as_fn_success () { as_fn_return 0; }
as_fn_failure () { as_fn_return 1; }
as_fn_ret_success () { return 0; }
as_fn_ret_failure () { return 1; }

exitcode=0
as_fn_success || { exitcode=1; echo as_fn_success failed.; }
as_fn_failure && { exitcode=1; echo as_fn_failure succeeded.; }
as_fn_ret_success || { exitcode=1; echo as_fn_ret_success failed.; }
as_fn_ret_failure && { exitcode=1; echo as_fn_ret_failure succeeded.; }
if ( set x; as_fn_ret_success y && test x = \"\$1\" )
then :

else case e in #(
  e) exitcode=1; echo positional parameters were not saved. ;;
esac
fi
test x\$exitcode = x0 || exit 1
blah=\$(echo \$(echo blah))
test x\"\$blah\" = xblah || exit 1
test -x / || exit 1"
  as_suggested='  as_lineno_1='
  as_suggested=${as_suggested}${LINENO}
  as_suggested=${as_suggested}" as_lineno_1a=\$LINENO
as_lineno_2="
  as_suggested=${as_suggested}${LINENO}
  as_suggested=${as_suggested}" as_lineno_2a=\$LINENO
eval 'test \"x\$as_lineno_1'\$as_run'\" != \"x\$as_lineno_2'\$as_run'\" &&
test \"x\`expr \$as_lineno_1'\$as_run' + 1\`\" = \"x\$as_lineno_2'\$as_run'\"' || exit 1"

  if (eval "${as_required}") 2>/dev/null
  then as_have_required=yes
  else as_have_required=no
  fi

  if test "x${as_have_required}" = xyes && (eval "${as_suggested}") 2>/dev/null
  then :
  else :
    as_found=false
    as_save_IFS="${IFS}"; IFS="${PATH_SEPARATOR}"
    # shellcheck disable=SC2031
    for as_dir in /bin${PATH_SEPARATOR}/usr/bin${PATH_SEPARATOR}${PATH}
    do
      IFS="${as_save_IFS}"
      case "${as_dir}" in
        '') as_dir='./' ;;
        */) ;;
        *) as_dir="${as_dir}/" ;;
      esac
      as_found=:
      case "${as_dir}" in
        /*)
          for as_base in sh bash ksh sh5
          do
            # Try only shells that exist, to save several forks.
            as_shell="${as_dir}${as_base}"
            if { test -f "${as_shell}" || test -f "${as_shell}.exe"; } && as_run=a "${as_shell}" -c "${as_bourne_compatible}""${as_required}" 2>/dev/null
            then :
              CONFIG_SHELL="${as_shell}"
              as_have_required=yes
              if as_run=a "${as_shell}" -c "${as_bourne_compatible}""${as_suggested}" 2>/dev/null
              then break 2;
              fi
            fi
          done
          ;;
        *) : ;;
      esac
      as_found=false
    done
    IFS="${as_save_IFS}"
    if ${as_found}
    then :
    else
      if { test -f "${SHELL}" || test -f "${SHELL}.exe"; } && as_run=a "${SHELL}" -c "${as_bourne_compatible}""${as_required}" 2>/dev/null
      then :
        CONFIG_SHELL="${SHELL}"
        as_have_required=yes
      fi
    fi

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
      # out after a failed 'exec'.
      printf "%s\n" "$0: could not re-execute WITH ${CONFIG_SHELL}" >&2
      exit 255
    fi

    if test "x${as_have_required}" = xno
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
  fi

  { st_opts=; unset 'st_opts'; }
  { as_suggested=; unset 'as_suggested'; }
  { as_bourne_compatible=; unset 'as_bourne_compatible'; }
  { as_base=; unset 'as_base'; }
  { as_dir=; unset 'as_dir'; }
  { as_save_IFS=; unset 'as_save_IFS'; }
  { as_found=; unset 'as_found'; }
  { as_have_required=; unset 'as_have_required'; }
fi

SHELL=${CONFIG_SHELL-/bin/sh}
export SHELL
# Unset more variables known to interfere with behavior of common tools.
# shellcheck disable=SC2034
CLICOLOR_FORCE='';
# shellcheck disable=SC2034
GREP_OPTIONS='';
unset 'CLICOLOR_FORCE' 'GREP_OPTIONS'

# Determine whether it's possible to make 'echo' print without a newline.
# These variables are no longer used directly by Autoconf, but are AC_SUBSTed
# for compatibility with existing Makefiles.
ECHO_C=''
ECHO_N=''
ECHO_T=''
# shellcheck disable=SC2006,SC3037
case `echo -n x` in
  -n*)
    # shellcheck disable=SC2116
    case `echo 'xy\c'` in
      *c*) ECHO_T='	';;	# ECHO_T is single tab character.
      xy)
      # shellcheck disable=SC2034
      ECHO_C='\c' ;;
      *)
      # shellcheck disable=SC2046,SC2005
      echo `echo ksh88 bug on AIX 6.1` > /dev/null
      # shellcheck disable=SC2034
      ECHO_T='	' ;;
    esac
    ;;
  *)
    # shellcheck disable=SC2034
    ECHO_N='-n' ;;
esac

# Enable shell features previously disabled
if test ${_st_opts+x}
then
  _st_val="${_st_opts%%"${nl}"*}"
  # shellcheck disable=SC2006
  if test "x${_st_val}" = "x#${_st_myself}"
  then (set -o) > /dev/null 2>&1 && eval "${_st_opts}"
  else _st_opts=; unset '_st_opts';
  fi
else :
fi
