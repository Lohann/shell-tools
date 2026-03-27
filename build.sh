#!/bin/sh

# build.sh [--import VARNAME] [--output OUTPUT]
#
# Default values
# VARNAME=st_import
# OUTPUT=./shell-tools.sh
# ---------------------
# Merge all scripts at `./scripts` directory in one 'shell-tools.sh'

# 1. Find 'build.sh' file, assuming it is located at shell-tools's base directory.
{ test "${0}" && test -f "${0}"; } ||
{ echo "file name \$0 is not defined, cannot find script root directory" >&2; exit 1; }

# 2. Find $0 base directory
_st_basedir=''
{ (st_dir=`dirname -- /` && test "X$st_dir" = X/) >/dev/null 2>&1 &&
  _st_basedir=`dirname -- "${0}" 2> /dev/null`; } ||
{ expr a : '\(a\)' >/dev/null 2>&1 &&
  test "X`expr 00001 : '.*\(...\)'`" = X001 &&
  _st_basedir=`expr X"${0}" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
	  X"${0}" : 'X\(//\)[^/]' \| \
	  X"${0}" : 'X\(//\)$' \| \
	  X"${0}" : 'X\(/\)' \| . 2>/dev/null`; } ||
{ _st_basedir=`printf '%s\n' X"${0}" |
  sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
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
	s/.*/./; q'`; } ||
{ echo "base directory not found '${0}'" >&2; exit 1; }

# 3. Make sure we are in shell-tools's base directory
{ test x"${_st_basedir}" != x && test -d "${_st_basedir}"; } ||
{ printf %s\\n "directory '${_st_basedir}' not found" >&2; exit 1; }
test -f "${_st_basedir}/build.sh" ||
{ printf %s\\n "'${_st_basedir}/build.sh' not found, rerun with an absolute file name" >&2; exit 1; }
cd "${_st_basedir}" ||
{ printf %s\\n "change to directory '${_st_basedir}' failed $?" >&2; exit 1; };
test -d './scripts' ||
{ printf %s\\n "directory 'scripts' not found" >&2; exit 1; }
test -f './build.sh' ||
{ printf %s\\n "'./build.sh' not found, rerun with an absolute file name" >&2; exit 1; }

# 4. Load required shell scripts.
_scripts='./scripts/bourne_compatible.sh
./scripts/shell_sanity_check.sh
./scripts/append.sh
./scripts/quote.sh
./scripts/sh_escape.sh
./scripts/map.sh
./scripts/test_varname.sh
./scripts/basename.sh
./scripts/pushvar.sh
./scripts/popvar.sh'
for v in ${_scripts}
do test -f "${v}" \
  || { printf %s\\n "file not found '${v}'" >&2; exit 1; }
  . "${v}"
done
set -eu

# 5. Find script basenames
for v in ${_scripts}
do _st_name=`basename -- "${v}"` ||
{ printf %s\\n "'basename' failed for '${v}'" >&2; exit 1; }
_st_name=`expr "X${_st_name}" ':' 'X\([^/][^/]*\)\.sh$'` ||
{ printf %s\\n "'expr' failed for '${v}'" >&2; exit 1; }
test_varname "${_st_name}" ||
{ printf %s\\n "invalid varname '${_st_name}' for '${v}'" >&2; exit 1; }
_st_name="${_st_name}=${v}"
pushvar '_st_name'
done

# 6. Format script list
_scripts=''
v=0
while test ${v} -lt ${_st_name_level}
do eval "_st_name=\${_st_name_${v}}"
  v=`expr '1' '+' "${v}"`
  if test ${v} -lt ${_st_name_level}
  then append '_scripts' "${_st_name}${nl}"
  else append '_scripts' "${_st_name}"
  fi
done
while popvar '_st_name'
do continue
done
v=''; unset 'v'
_st_name=''; unset '_st_name'
_st_name_level=''; unset '_st_name_level'

####################
## HELPER METHODS ##
####################

# _st_quote_file <ALIAS> <METHOD> <FILE>
# ----------------------
# quote a <FILE> then rename function <METHOD> to <ALIAS>
_st_quote_file()
{
  test $# -eq 3 ||
  { printf %s\\n "expect 1 values, provided $#" >&2; exit 1; }
  test_varname "${1}" ||
  { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  test_varname "${2}" ||
  { printf %s\\n "invalid variable name '${2}'" >&2; exit 1; }
  test -f "${3}" ||
  { printf %s\\n "file not found '${3}'" >&2; exit 1; }
  sed \
    -e "{
      1d
      s/[^']*[^']/\\n&\\n/g
      \$!s/\\n\$//
      \$!s/'\$/'\\n/
      2!s/^\\n//
      2!s/^'/\\n'/
      s/'/\\\\&/g
      s/\\n/'/g
      /^\$/{
        2s/^/'/
        \$s/\$/'/
      }
      /${2}/{
        /^[ ]*\\#/!{
          s/${2}/'\"\$\\{${1}\\}\"'/g
        }
      }
    }" < "${3}" || { printf %s\\n "sed failed $?" >&2; exit 1; }
  # quote < "${3}"
  # sed \
  #   -e '1d' \
  #   -e "s/'/'\\\\''/g" \
  #   -e "s/${2}/'\"\$\\{${1}\\}\"'/" \
  #   -e "2s/^/'/" \
  #   -e "\$s/\$/'/" \
  #   -e "s#^'\\([-[:alnum:]_,./:]*\\)=\\(.*\\)\$#\\1='\\2#" < "${3}" ||
  # { printf %s\\n "sed failed $?" >&2; exit 1; }
}

# _st_import <ALIAS> <METHOD> <FILE>
# ----------------------
# print the item <FILE>, renames function <METHOD> to <ALIAS>
_st_import()
{
  test $# -eq 3 ||
  { printf %s\\n "expect 3 values, provided $#" >&2; exit 1; }
  test_varname "${1}" ||
  { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  test_varname "${2}" ||
  { printf %s\\n "invalid variable name '${2}'" >&2; exit 1; }
  test -f "${3}" || { printf %s\\n "file not found '${3}'" >&2; exit 1; }
  append "${1}" "\

## ${2} ##
echo \"\${${1}}\" | grep '^${2}' >/dev/null 2>&1 &&
(eval \"\${${1}}\"; printf '%s\n' `_st_quote_file "${2}" "${2}" "${3}" 2>&1`) || :
"
}

# _st_header <VARNAME> <SCRIPTS>
# ----------------------
# print the 'shell-tools.sh' script header, replace '${1}' by <VARNAME>
_st_header()
{
v=''
# map 'append v "${1%%=*}${nl}"' ${_scripts}
map 'append v "$(expr "X$1" : '\''X\([^=]*\)=.*'\'')"
test $# -eq 1 || append v "${nl}"' ${_scripts}

v="$(quote "${v}")${nl}"

sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
##################
## SCRIPT START ##
##################
test \${\${1}+y} &&
test x"\${\${1}}" != 'x' || \${1}=${v}
EOF


# ${1}=`printf '%s\n' "${${1}}" | LC_ALL=C LANGUAGE=C tr '[\000-\040\176-\377]' '
# '` || { printf '%s\n' "[ERROR] tr failed '${${1}}'" >&2; exit 1; }

sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<'EOF'
# Remove whitespaces
case `printf '%bX%b' '\141' '\x61' 2> /dev/null` in
  aX*) :
    { ${1}=`printf '%s\n' "${${1}}" | LC_ALL=C LANGUAGE=C tr '[\001-\040\176-\377]' "
"` || printf '%s\n' "[ERROR] tr failed '${${1}}'" >&2; exit 1; } ;;
  *Xa) :
    { ${1}=`printf '%s\n' "${${1}}" | LC_ALL=C LANGUAGE=C tr '[\x01-\x20\x76\xfe]' "
"` || printf '%s\n' "[ERROR] tr failed '${${1}}'" >&2; exit 1; } ;;
  *) :
    { ${1}=`printf '%s\n' "${${1}}" | LC_ALL=C LANGUAGE=C tr " ""	
" "
"` || printf '%s\n' "[ERROR] tr failed '${${1}}'" >&2; exit 1; } ;;
esac

# Parse options
${1}=`printf '%s\n' "${${1}}" | LC_ALL=C LANGUAGE=C sed -n \
  -e "/^\n*$/b end" \
  -e 's/^\([A-Za-z_][A-Za-z0-9_]*\)$/\1=\1/; t ok' \
  -e "/^[A-Za-z_][A-Za-z0-9_]*=[A-Za-z_][A-Za-z0-9_]*$/b ok" \
  -e "s/'/'\\\\''/g" \
  -e "s/^/'/" \
  -e "s/$/'/" \
  -e ':ok' \
  -e 'p' \
  -e ':end'` ||
{ printf '%s\n' "[ERROR] sed failed '${${1}}'" >&2; exit 1; }

test "X${${1}}" != X || exit 0

# Validate options
EOF

v="_imports=\"\${\${1}}\"
_st_error=""
st_case='['\'']*'
for v in \${_imports}
do case \${v} in
  \$st_case ) eval \"_st_error=\\\"\\\${_st_error}invalid option \\\"\${v}'
'\"; continue ;;
  *=* ) a=\"\${v%%[=]*}\" ;;
  * ) a=\"\${v}\" ;;
esac
case \"\${a}\" in
"
map "append v \"  \`expr \"X\${1}\" ':' '.\\([^=][^=]*\\)=.*$'\` ) : ;;
\"" ${_scripts}

append 'v' '  * ) _st_error="${_st_error}unknown option '\''${a}'\''
" ;;
esac
done
test "X${_st_error}" = X || { printf "%s\n%s" "[ERROR] invalid options:" "${_st_error}" >&2; exit 1; }'

v=`quote "${v}"`
v="(eval ${v}) || exit \$?"
sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
${v} 

EOF

eval "v=\"\${${1}_version}\""
sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
# display file header
cat <<EOLHEADER
#!/bin/sh
# THIS FILE WAS AUTO-GENERATED USING SHELL-TOOLS ${v}
#   DATE: \`TZ=GMT0 LANGUAGE=C LC_ALL=C date '+%Y-%m-%d'\`
# SOURCE: https://github.com/Lohann/shell-tools
# SHA256: \${${1}_hash}

EOLHEADER

EOF

sed -e "s/'/'\\\\''/g" -e "\$s/\$/'/" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<'EOF'
# display imports
printf '%s\n' '# IMPORTED MODULES #'
printf '%s\n' "${1}='${${1}}'"

EOF
}

_st_try_eval ()
{
  eval "$@" || { s=$?; printf '%s\n%s\n' "[ERROR] eval failed ${s}:" "$*" >&2; exit 1; }
}

# _st_build <VARNAME>
# ----------------------
# build the 'shell-tools.sh' and assign it to <VARNAME>
_st_build()
{
  set -eu
  test_varname "${1}" ||
  { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  eval "${1}_rev=\`git rev-parse --short HEAD\`"
  eval "${1}_version=\"v0.1.0-\${${1}_rev}\""
  eval "${1}_date=\`TZ=GMT0 LANGUAGE=C LC_ALL=C date '+%Y-%m-%d'\`"
  eval "${1}_cmd=''"
  append "${1}_cmd" "`sh_escape "${_st_myself}" "--import=${1}" "--output=${_st_output}"`"

  eval "${1}=''"
  eval "append '${1}' `_st_header "${1}"`"
  map '_st_import '"'${1}'"' `expr "X${1}" ":" '\''.\([^=][^=]*\)=.*$'\''` `expr "X${1}" ":" '\''.[^=][^=]*=\(.*\)$'\''`' ${_scripts}

  append "${1}" "
# cleanup
${1}=''; unset '${1}';
"

  eval "${1}_hash=\`printf %s \"\${${1}}\" | sha256\`"
  eval "${1}_header='#!/bin/sh

'"
  eval "append '${1}_header' \"# FILE AUTO-GENERATED USING SHELL-TOOLS \${${1}_version}
\""
  eval "append '${1}_header' \"# COMMAND: \${${1}_cmd}
\""
  eval "append '${1}_header' \"#    DATE: \${${1}_date}
\""
  eval "append '${1}_header' \"#  SOURCE: https://github.com/Lohann/shell-tools
\""
  eval "append '${1}_header' \"#  SHA256: \${${1}_hash}
\""
  eval "append '${1}_header' \"
\${${1}}\""
  eval "${1}=\`printf %s \"\${${1}_header}\" | sed \
    -e 's/\\\${${1}_hash}/'\"\${${1}_hash}\"'/g'\`"
  eval "unset '${1}_header'"
}

# show_help
# ----------------------
# display help message
show_help()
{
  cat<<EOL
${_st_myself} merges all files at '${_st_basedir}/scripts' in a single reusable script.
Usage: ${0} [--import NAME] [--output FILE]

Configuration:
  -h, --help            print this help, then exit.
  -o, --output=OUTPUT   path to the output file or '-' to print to stdout
                        [./shell-tools.sh]
  -i, --import=IMPORT   name of the environment variable used to select imports
                        in the OUTPUT script.
                        [st_import]
EOL
}

##################
## BEGIN SCRIPT ##
##################

# 5. Find 'git' and 'date' commands
command -v 'git' > /dev/null ||
{ printf %s\\n "command 'git' not found" >&2; exit 1; }
command -v 'date' > /dev/null ||
{ printf %s\\n "command 'date' not found" >&2; exit 1; }

# 7. validate arguments.
_st_import='st_import'
_st_output='./shell-tools.sh'
_st_prev=
_st_optarg=
for _st_option
do
  # If the previous option needs an argument, assign it.
  if test -n "${_st_prev}"; then
    eval "_st_${_st_prev}=\"\${_st_option}\""
    _st_prev=
    continue
  else :
  fi

  case "${_st_option}" in
    *=?*) _st_optarg=`expr "X${_st_option}" : '[^=]*=\(.*\)'` ;;
    *=)   _st_optarg= ;;
    *)    _st_optarg=yes ;;
  esac

  case "${_st_option}" in
    -h | --help)
      show_help;
      exit 0 ;;
    --import | -i )
      _st_prev='import' ;;
    --import=* | -i=* )
      _st_varname="${_st_optarg}" ;;
    --output | --out | -o )
      _st_prev='output' ;;
    --output=* | --out=* | -o=* )
      _st_output="${_st_optarg}" ;;
    *)
      printf '%s\n\n' "[ERROR] unknown option '${_st_option}'" >&2;
      show_help;
      exit 1 ;;
  esac
done

case "${_st_prev}" in
  '') : ;;
  output) _st_output='' ;;
  *)
    _st_option="--$(echo "${_st_prev}" | sed 's/_/-/g')"
    printf '%s\n\n' "[ERROR] missing argument to ${_st_option}" >&2;
    exit 1;
    ;;
esac
if test -n "${_st_prev}";
then :
else :
fi

# Verify --import=IMPORT
if test_varname "${_st_import}"
then :
else :
  printf '%s\n\n' "[ERROR] invalid variable name:${nl}    --import='${_st_import}'" >&2;
  exit 1;
fi

# Verify --output=OUTPUT
case "${_st_output}" in
  '') _st_output='-' ;;
  [-]) : ;;
  [-]?*)
    printf '%s\n' "[ERROR] invalid output value --output='${_st_output}' " >&2;
    exit 1;
    ;;
  *)
    test x"${_st_output}" != 'x' || {
      printf '%s\n' "[ERROR] '--output' cannot be empty" >&2;
      exit 1;
    };
    _st_dir="$(dirname -- "${_st_output}")" || {
      printf '%s\n' "[ERROR] cannot determine directory of '${_st_output}'" >&2;
      exit 1;
    };
    test -d "${_st_dir}" || {
      printf '%s\n' "[ERROR] output directory not found '${_st_dir}'" >&2;
      exit 1;
    };
    if test x"${_st_output}" = x"${_st_dir}" || test -d "${_st_output}"
    then :
      printf '%s\n' "[ERROR] Cannot write to file '${_st_output}'" >&2;
      exit 1;
    else :
    fi
    ;;
esac

# 8. List scripts in './scripts' directory.
fn_list_scripts ()
{
  { printf %s "${_scripts}" | grep "${1}" >/dev/null 2>&1 && return 0; } ||
  v=`basename -- "${1}"` &&
  v=`expr "X${v}" ":" 'X\([^/][^/]*\)\.sh$'` &&
  test_varname "${v}" &&
  append '_scripts' "${nl}${v}=${1}";
}
set +f
map 'fn_list_scripts "${1}"' ./scripts/*
set -f
v=''; unset 'v'

# 9. Merge all scripts
_st_body="$(eval "_st_build '${_st_import}' >&2 && printf '%s\n' \"\${${_st_import}}\"")"


# 10. Write to var `_st_body` to output.
case "${_st_output}" in
  '-') printf '%s\n' "${_st_body}" ;;
  *) :
    { printf '%s\n' "${_st_body}" > "${_st_output}"; } ||
    { printf '%s\n' "Cannot write to file '${_st_output}'" >&2; exit 1; }
    chmod +x "${_st_output}" ||
    { printf '%s\n' "Cannot make file executable '${_st_output}'" >&2; exit 1; }
    ;;
esac
