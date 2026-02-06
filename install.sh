#!/bin/sh

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
for _st_val in BASH_ENV ENV MAIL MAILPATH CDPATH
do
  if eval "test \${${_st_val}+y}"
  then { ( (unset "${_st_val}") || exit 1) >/dev/null 2>&1 && unset "${_st_val}"; } || :
  else :
  fi
done

# Enable features we need and disable problematic ones.
if _st_opts=`(set -o) 2>/dev/null`;
then
  for _st_code in H a x v m f e u C B pipefail; do
    case ${_st_code} in 
      H) _st_name=histexpand;  _st_enabled=no  ;; # history expansion [disabled]
      a) _st_name=allexport;   _st_enabled=no  ;; # export all variables assigned to [disabled]
      x) _st_name=xtrace;      continue        ;; # xtrace  [keep default]
      v) _st_name=verbose;     continue        ;; # verbose [keep default]
      m) _st_name=monitor;     _st_enabled=no  ;; # monitor [disabled]
      f) _st_name=noglob;      _st_enabled=yes ;; # disable pathname expansion [enabled]
      e) _st_name=errexit;     _st_enabled=no  ;; # exit on error [disable]
      u) _st_name=nounset;     _st_enabled=no  ;; # no unset [disable]
      C) _st_name=noclobber;   _st_enabled=yes ;; # no clobber [enabled]
      B) _st_name=braceexpand; _st_enabled=no  ;; # brace expansion [disable]
      pipelfail) _st_name=pipefail;               # pipefail [enabled]
                 _st_enabled=yes ;; 
      *) continue ;;
    esac

    case "$-" in
      *"${_st_code}"*)
        # option enabled
        test x"${_st_enabled}" = xyes || {
          set +o ${_st_name} 2> /dev/null ||
            set +${_st_code} || :;
        };
        continue ;;
      *) : ;;
    esac
    case "${_st_opts}" in
      *"${_st_name}"*)
        # option disabled
        test x"${_st_enabled}" = xno || {
          set -o ${_st_name} 2> /dev/null ||
            set -${_st_code} || :;
        } ;;
      *)
        # option not supported
        continue ;;
    esac
  done
else :
fi

# cleanup possibly unwanted exported variables if 'set -a' was enabled.
{ test ${_st_val+y} && ( (unset '_st_val') || exit 1) >/dev/null 2>&1 && unset '_st_val'; } || :
{ test ${_st_code+y} && ( (unset '_st_code') || exit 1) >/dev/null 2>&1 && unset '_st_code'; } || :
{ test ${_st_opts+y} && ( (unset '_st_opts') || exit 1) >/dev/null 2>&1 && unset '_st_opts'; } || :
{ test ${_st_name+y} && ( (unset '_st_name') || exit 1) >/dev/null 2>&1 && unset '_st_name'; } || :
{ test ${_st_enabled+y} && ( (unset '_st_enabled') || exit 1) >/dev/null 2>&1 && unset '_st_enabled'; } || :

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
_st_myself=''
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
      if test -r "${_st_val}${0}"
      then _st_myself="${_st_val}${0}" && break;
      else continue;
      fi
    done
    IFS="${_st_ifs_backup}";
    { test ${_st_val+y} && ( (unset '_st_val') || exit 1) >/dev/null 2>&1 && unset '_st_val'; } || :
    { test ${_st_ifs_backup+y} && ( (unset '_st_ifs_backup') || exit 1) >/dev/null 2>&1 && unset '_st_ifs_backup'; } || :
    ;;
esac

# Use a proper internal environment variable to ensure we don't fall
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
  # out after a failed 'exec'.
  printf "%s\n" "${0}: could not re-execute WITH ${CONFIG_SHELL}" >&2
  exit 255
fi
# We don't want this to propagate to other subprocesses.
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

  _st_suggested='  _st_lineno_1='
  _st_suggested=${_st_suggested}${LINENO:-}
  _st_suggested=${_st_suggested}" _st_lineno_1a=\$LINENO
_st_lineno_2="
  _st_suggested=${_st_suggested}${LINENO:-}
  _st_suggested=${_st_suggested}" _st_lineno_2a=\$LINENO
eval 'test \"x\$_st_lineno_1'\$_st_run'\" != \"x\$_st_lineno_2'\$_st_run'\" &&
test \"x\`expr \$_st_lineno_1'\$_st_run' + 1\`\" = \"x\$_st_lineno_2'\$_st_run'\"' || exit 1"
  if test "x${_st_have_required}" = xyes && (eval "${_st_suggested}") 2>/dev/null
  then _st_found=yes
  else _st_found=no
  fi

  if test x"${_st_found}" = 'xno';
  then :
    _st_found=false
    _st_save_IFS="${IFS}"; IFS="${PATH_SEPARATOR}"
    # shellcheck disable=SC2031
    for _st_dir in /bin${PATH_SEPARATOR}/usr/bin${PATH_SEPARATOR}${PATH}
    do
      IFS="${_st_save_IFS}"
      case "${_st_dir}" in
        '') _st_dir='./' ;;
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
          _st_base=;unset '_st_base';
          _st_shell=;unset '_st_shell';
          ;;
        *) : ;;
      esac
      _st_found=false
    done
    IFS="${_st_save_IFS}"
    _st_save_IFS=;unset '_st_save_IFS';
    _st_dir=;unset '_st_dir';
    
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
    _st_found=;unset '_st_found';
    _st_bourne_compatible=;unset '_st_bourne_compatible';

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
    _st_have_required=;unset '_st_have_required';
  else :
  fi
fi

if _st_opts=`(set -o) 2>/dev/null`;
then
  for _st_code in H a x v m f e u C B pipefail; do
    case ${_st_code} in 
      H) _st_name=histexpand;  _st_enabled=no  ;; # history expansion [disabled]
      a) _st_name=allexport;   _st_enabled=no  ;; # export all variables assigned to [disabled]
      x) _st_name=xtrace;      continue        ;; # xtrace  [keep default]
      v) _st_name=verbose;     continue        ;; # verbose [keep default]
      m) _st_name=monitor;     _st_enabled=no  ;; # monitor [disabled]
      f) _st_name=noglob;      _st_enabled=no  ;; # disable pathname expansion [disable]
      e) _st_name=errexit;     _st_enabled=yes ;; # exit on error [enabled]
      u) _st_name=nounset;     _st_enabled=yes ;; # no unset [enabled]
      C) _st_name=noclobber;   _st_enabled=no  ;; # no clobber [disable]
      B) _st_name=braceexpand; _st_enabled=no  ;; # brace expansion [disable]
      pipelfail) _st_name=pipefail;               # pipefail [enabled]
                 _st_enabled=yes ;; 
      *) continue ;;
    esac

    case "$-" in
      *"${_st_code}"*)
        # option enabled
        test x"${_st_enabled}" = xyes || {
          set +o ${_st_name} 2> /dev/null ||
            set +${_st_code} || :;
        };
        continue ;;
      *) : ;;
    esac
    case "${_st_opts}" in
      *"${_st_name}"*)
        # option disabled
        test x"${_st_enabled}" = xno || {
          set -o ${_st_name} 2> /dev/null ||
            set -${_st_code} || :;
        } ;;
      *)
        # option not supported
        continue ;;
    esac
  done
else :
fi

# cleanup
{ test ${_st_code+y} && ( (unset '_st_code') || exit 1) >/dev/null 2>&1 && unset '_st_code'; } || :
{ test ${_st_opts+y} && ( (unset '_st_opts') || exit 1) >/dev/null 2>&1 && unset '_st_opts'; } || :
{ test ${_st_name+y} && ( (unset '_st_name') || exit 1) >/dev/null 2>&1 && unset '_st_name'; } || :
{ test ${_st_enabled+y} && ( (unset '_st_enabled') || exit 1) >/dev/null 2>&1 && unset '_st_enabled'; } || :

printf '%s\n' "${_myself}"
printf '%s\n' "success $-"
# set
