#!/bin/sh

##################
## SCRIPT START ##
##################
test x"${st_import:-}" != 'x' || st_import='append
bourne_compatible
map
popvar
pushvar
quote
sh_sanitize
test_varname
version_compare'

# Remove whitespaces
st_import="$(
LC_ALL=C LANGUAGE=C tr '[\000-\040\176-\377]' '\n' 2>&1 <<EOL
${st_import}
EOL
)" || { printf '%s' "tr failed '${st_import}'" >&2; exit 1; }

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
)" || { printf '%s' "sed failed '${st_import}'" >&2; exit 1; }

if test -z "${st_import}"
then exit 0;
else :
fi

# Validate options
(
_imports="${st_import}"
is_valid=:
for v in ${_imports};
do
case "${v}" in 
  \'*) is_valid=false; eval "printf \"invalid option '%s'\n\" ${v}"; continue ;;
  *=*) a="${v%%[=]*}" ;;
  *) a="${v}" ;;
esac
case "\${a}" in  'append') ;;
  'bourne_compatible') ;;
  'map') ;;
  'popvar') ;;
  'pushvar') ;;
  'quote') ;;
  'sh_sanitize') ;;
  'test_varname') ;;
  'version_compare') ;;
  *) is_valid=false; printf "unknown option %s\n" "${a}" ;;esac;
done
${is_valid} || exit 1;
) || exit $?;

# display imports
tr '\n' ' ' <<EOL
st_import='${st_import}'
EOL
printf '\n'

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
if (eval "as_var=1; as_var+=2; test x\$as_var = x12") 2>/dev/null
then
'"${append}"' ()
{
  eval "${1}+=\"\${2}\""
}
else
'"${append}"' ()
{
  eval "${1}=\"\${${1}}\${2}\""
}
fi'
)
else :
fi

## bourne_compatible ##
if grep '^bourne_compatible' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
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
    set -o posix > /dev/null 2>&1
    ;;
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
do
  if eval "test \${${_st_val}+y}"
  then { ( (unset "${_st_val}") || exit 1) >/dev/null 2>&1 && unset "${_st_val}"; } || :
  else :
  fi
done
{ ( (unset '\''_st_val'\'') || exit 1) >/dev/null 2>&1 && unset '\''_st_val'\''; } || :

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
        '\'''\'') _st_val='\''./'\'' ;;
        */) ;;
        *) _st_val="${_st_val}/" ;;
      esac
      test -r "${_st_val}${0}" && _st_myself="${_st_val}${0}" && break
    done
    IFS="${_st_ifs_backup}";
    _st_val=;unset '\''_st_val'\'';
    _st_ifs_backup=;unset '\''_st_ifs_backup'\'';
    ;;
esac

# We did not find ourselves, most probably we were run as '\''sh COMMAND'\''
# in which case we are not to be found in the path.
test "x${_st_myself}" != '\''x'\'' || _st_myself="${0}"
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
  test "x${_st_opts}" = '\''x'\'' || export _st_opts
  # shellcheck disable=SC3040
  case `(set -o) 2> /dev/null` in *pipefail*) set -o pipefail ;; *) : ;; esac;

  # cleanup
  { ( (unset _st_opt_name) || exit 1) >/dev/null 2>&1 && unset _st_opt_name; } || :
  { ( (unset _st_opt_letter) || exit 1) >/dev/null 2>&1 && unset _st_opt_letter; } || :
else :
fi

# Use a proper internal environment variable to ensure we don'\''t fall
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
  # out after a failed '\''exec'\''.
  printf "%s\n" "${0}: could not re-execute WITH ${CONFIG_SHELL}" >&2
  exit 255
fi
# We don'\''t want this to propagate to other subprocesses.
{ _st_can_reexec=; unset _st_can_reexec; }

# shellcheck disable=SC2268
if test "x${CONFIG_SHELL}" = x; then
  as_bourne_compatible="if test \${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1;
then :
  emulate sh
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on \${1+\"\$@\"}, which
  # is contrary to our usage.  Disable this feature.
  alias -g '\''\${1+\"\$@\"}'\''='\''\"\$@\"'\''
  setopt NO_GLOB_SUBST
else
  case \`(set -o) 2>/dev/null\` in
    *posix*) set -o posix > /dev/null 2>&1 ;;
    *) : ;;
  esac
fi
_st_opts='\''${_st_opts:-}'\''
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
  as_suggested='\''  as_lineno_1='\''
  as_suggested=${as_suggested}${LINENO}
  as_suggested=${as_suggested}" as_lineno_1a=\$LINENO
as_lineno_2="
  as_suggested=${as_suggested}${LINENO}
  as_suggested=${as_suggested}" as_lineno_2a=\$LINENO
eval '\''test \"x\$as_lineno_1'\''\$as_run'\''\" != \"x\$as_lineno_2'\''\$as_run'\''\" &&
test \"x\`expr \$as_lineno_1'\''\$as_run'\'' + 1\`\" = \"x\$as_lineno_2'\''\$as_run'\''\"'\'' || exit 1"

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
        '\'''\'') as_dir='\''./'\'' ;;
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
      # out after a failed '\''exec'\''.
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

  { st_opts=; unset '\''st_opts'\''; }
  { as_suggested=; unset '\''as_suggested'\''; }
  { as_bourne_compatible=; unset '\''as_bourne_compatible'\''; }
  { as_base=; unset '\''as_base'\''; }
  { as_dir=; unset '\''as_dir'\''; }
  { as_save_IFS=; unset '\''as_save_IFS'\''; }
  { as_found=; unset '\''as_found'\''; }
  { as_have_required=; unset '\''as_have_required'\''; }
fi

SHELL=${CONFIG_SHELL-/bin/sh}
export SHELL
# Unset more variables known to interfere with behavior of common tools.
# shellcheck disable=SC2034
CLICOLOR_FORCE='\'''\'';
# shellcheck disable=SC2034
GREP_OPTIONS='\'''\'';
unset '\''CLICOLOR_FORCE'\'' '\''GREP_OPTIONS'\''

# Determine whether it'\''s possible to make '\''echo'\'' print without a newline.
# These variables are no longer used directly by Autoconf, but are AC_SUBSTed
# for compatibility with existing Makefiles.
ECHO_C='\'''\''
ECHO_N='\'''\''
ECHO_T='\'''\''
# shellcheck disable=SC2006,SC3037
case `echo -n x` in
  -n*)
    # shellcheck disable=SC2116
    case `echo '\''xy\c'\''` in
      *c*) ECHO_T='\''	'\'';;	# ECHO_T is single tab character.
      xy)
      # shellcheck disable=SC2034
      ECHO_C='\''\c'\'' ;;
      *)
      # shellcheck disable=SC2046,SC2005
      echo `echo ksh88 bug on AIX 6.1` > /dev/null
      # shellcheck disable=SC2034
      ECHO_T='\''	'\'' ;;
    esac
    ;;
  *)
    # shellcheck disable=SC2034
    ECHO_N='\''-n'\'' ;;
esac

# Enable shell features previously disabled
if test ${_st_opts+x}
then
  _st_val="${_st_opts%%"${nl}"*}"
  # shellcheck disable=SC2006
  if test "x${_st_val}" = "x#${_st_myself}"
  then (set -o) > /dev/null 2>&1 && eval "${_st_opts}"
  else _st_opts=; unset '\''_st_opts'\'';
  fi
else :
fi'
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
  eval "while test \$# -gt 1; do
  shift > /dev/null 2>&1 || return \$?;
  eval $(printf '\''%s'\'' "${1}" | sed -e "s/'\''/'\''\\\\'\'''\''/g" -e "1s/^/'\''/" -e "\$s/\$/'\''/") || return \$?
done"
}'
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
# push the value at <VAR> into stack.
'"${popvar}"' ()
{
  while test $# -gt 0; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    eval "test \"\${${1}_level:-0}\" -gt 0 && \
${1}_level=\$((\${${1}_level}-1)) && \
eval \"${1}=\\\"\\\${${1}_\${${1}_level}:-}\\\"\" && \
unset \"${1}_\${${1}_level}\"" || return $?;
    shift 2> /dev/null || return $?;
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
# decrement <VAR>_LEVEL and assign <VAR>_<LEVEL> to <VAR>
'"${pushvar}"' ()
{
  while test $# -gt 0; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    eval "test \${${1}+x} && \\
test \"\${${1}_level:=0}\" -ge 0 && \\
eval \"${1}_\${${1}_level}=\\\"\\\${${1}}\\\"\" && \\
${1}_level=\$((\${${1}_level}+1))" || return $?;
    shift 2> /dev/null || return $?;
  done
}'
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
# wraps the string in single quotes, escape inner single quotes.
'"${quote}"' ()
{
  printf %s "${1}" | sed -e "s/'\''/'\''\\\\'\'''\''/g" -e "1s/^/'\''/" -e "\$s/\$/'\''/"
}'
)
else :
fi

## sh_sanitize ##
if grep '^sh_sanitize' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# sh_sanitize [...ARGS]
# ----------------------
# Escape and quote the provided arguments, allowing then
# to be safely evaluated by shell.
'"${sh_sanitize}"' ()
{
  while test $# -gt 0; do
    if tr '\''\n'\'' '\'' '\'' <<EOF | grep '\''^[-[:alnum:]_=,./:]* $'\'' >/dev/null 2>&1
${1}
EOF
    then printf %s "${1}"
    else
      printf %s "${1}" | \
      sed \
        -e "s/'\''/'\''\\\\'\'''\''/g" \
        -e "1s/^/'\''/" \
        -e "\$s/\$/'\''/" \
        -e "s#^'\''\([-[:alnum:]_,./:]*\)=\(.*\)\$#\1='\''\2#"
    fi
    shift 2> /dev/null || return $?;
    test $# -eq 0 || printf %s '\'' '\''
  done
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
# Check if <STRING> is a valid shell varname
'"${test_varname}"' ()
{
  test $# -gt 0 || return 127;
  while :; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    test $# -gt 1 || return 0;
    shift 2> /dev/null || return 127;
  done
}'
)
else :
fi

## version_compare ##
if grep '^version_compare' >/dev/null 2>&1 <<EOL
${st_import}
EOL
then (
eval "${st_import}"
printf '%s\n' '
# code adapted from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1742-L1805

# version_compare <VERSION_1> <OP> <VERSION_2>
# ----------------------------------------------------------------------------
# Compare two strings possibly containing shell variables as version strings.
# Valid operator <OP> includes
#  -        LESS THAN: '\''-lt'\'' '\''<'\'' 
#  -    LESS OR EQUAL: '\''-le'\'' '\''<='\'' 
#  -            EQUAL: '\''-eq'\'' '\''='\'' '\''=='\'' 
#  - GREATER OR EQUAL: '\''-ge'\'' '\''>='\'' 
#  -     GREATER THAN: '\''-gt'\'' '\''>'\'' 
#
# This usage is portable even to ancient awk,
# so don'\''t worry about finding a "nice" awk version.
'"${version_compare}"' ()
{
  test $# -eq 3 || return 127;
  case "${2}" in
    -lt|'\''<'\'') : ;;
    -le|'\''<='\'') : ;;
    -eq|'\''='\''|'\''=='\'') : ;;
    -ge|'\''>='\'') : ;;
    -gt|'\''>'\'') : ;;
    *) printf %s\\n "unknown operator '\''${2}'\''" >&2; return 127 ;;
  esac
  
  # test AWK
  ( { awk '\''BEGIN { exit 0 }'\'' && awk '\''BEGIN { exit 123 }'\''; }; test $? -eq 123; ) > /dev/null 2>&1 || return 127;

  # execute awk in a `if` statement, so it doesn'\''t exit when errexit `-e` is enabled.
  if awk '\''# Use only awk features that work with 7th edition Unix awk (1978).
  # My, what an old awk you have, Mr. Solaris!
  END {
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
	    exit 1
	  }
	} else {
	  if (d2 ~ /^0/) {
	    # An integer is greater than a fraction.
	    exit 2
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
      if (d1 < d2) exit 1
      if (d1 > d2) exit 2
    }
    # Beware Solaris 11 /usr/xgp4/bin/awk, which mishandles some
    # comparisons of empty strings to integers.  For example,
    # LC_ALL=C /usr/xpg4/bin/awk "BEGIN {if (-1 < \"\") print \"a\"}"
    # prints "a".
    if (length(v2)) exit 1
    if (length(v1)) exit 2
  }
'\''  v1="${1}" v2="${3}" /dev/null
  then :
  else
    # else body cannot be empty, we can'\''t use '\'':'\'' because it would trash the value of $?.
    # Instead we use '\''case e in e) <BODY> ;; esac'\'' which is valid even when <BODY> is empty.
    case e in e) ;; esac;
  fi
  # exit status 1 means $v1 < $v2
  # exit status 0 means $v1 = $v2
  # exit status 2 means $v1 > $v2
  case $? in
    1) case "$2" in -lt|-le|'\''<'\''|'\''<='\'') return 0 ;; *) return 1 ;; esac ;;
    0) case "$2" in -eq|-le|-ge|'\''='\''|'\''=='\''|'\''>='\''|'\''<='\'') return 0 ;; *) return 1 ;; esac ;;
    2) case "$2" in -gt|-ge|'\''>'\''|'\''>='\'') return 0 ;; *) return 2 ;; esac ;;
    *) return 127; ;;
  esac
}'
)
else :
fi

# cleanup
st_import=; unset 'st_import';

