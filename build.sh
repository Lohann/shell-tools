#!/bin/sh

# build.sh [--import VARNAME] [--output OUTPUT]
#
# Default values
# VARNAME=st_import
# OUTPUT=./shell-tools.sh
# ---------------------
# Merge all scripts at `./scripts` directory in one 'shell-tools.sh'

# 1. Find 'build.sh' file, assuming it is located at shell-tools's base directory.
{ test "${0}" && test -f "${0}"; } || {
  echo "file name \$0 is not defined, cannot find script root directory" >&2;
  exit 1;
};

# 2. Find $0 base directory
_st_basedir='';
{
  (st_dir=`dirname -- /` && test "X$st_dir" = X/) >/dev/null 2>&1 &&
  _st_basedir=`dirname -- "${0}" 2> /dev/null`;
} || {
  expr a : '\(a\)' >/dev/null 2>&1 &&
  test "X`expr 00001 : '.*\(...\)'`" = X001 &&
  _st_basedir=`expr X"${0}" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
	  X"${0}" : 'X\(//\)[^/]' \| \
	  X"${0}" : 'X\(//\)$' \| \
	  X"${0}" : 'X\(/\)' \| . 2>/dev/null`;
} || {
  _st_basedir=`printf '%s\n' X"${0}" |
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
	s/.*/./; q'`;
} || {
  echo "base directory not found '${0}'" >&2;
  exit 1;
};

# 3. Make sure we are in shell-tools's base directory
{ 
  test x"${_st_basedir}" != x &&
  test -d "${_st_basedir}";
} || {
  printf %s\\n "directory '${_st_basedir}' not found" >&2;
  exit 1;
};
test -f "${_st_basedir}/build.sh" || {
  printf %s\\n "'${_st_basedir}/build.sh' not found, rerun with an absolute file name" >&2;
  exit 1;
};
cd "${_st_basedir}" || {
  printf %s\\n "change to directory '${_st_basedir}' failed $?" >&2;
  exit 1;
};
test -d './scripts' || {
  printf %s\\n "directory 'scripts' not found" >&2;
  exit 1;
};
test -f './build.sh' || {
  printf %s\\n "'./build.sh' not found, rerun with an absolute file name" >&2;
  exit 1;
};

# 4. Load 'scripts/bourne_compatible.sh' script.
test -f "./scripts/bourne_compatible.sh" || {
  printf %s\\n "file not found './scripts/bourne_compatible.sh'" >&2;
  exit 1;
}
. './scripts/bourne_compatible.sh'

# 5. Load 'scripts/shell_sanitize.sh' script.
test -f "./scripts/shell_sanitize.sh" || {
  printf %s\\n "file not found './scripts/shell_sanitize.sh'" >&2;
  exit 1;
}
. './scripts/shell_sanitize.sh'

# 6. Load other dependencies used in this script.
test -f './scripts/append.sh' || {
  printf %s\\n "file not found './scripts/append.sh'" >&2;
  exit 1;
}
test -f './scripts/quote.sh' || {
  printf %s\\n "file not found './scripts/quote.sh'" >&2;
  exit 1;
}
test -f './scripts/map.sh' || {
  printf %s\\n "file not found './scripts/map.sh'" >&2;
  exit 1;
}
test -f './scripts/test_varname.sh' || {
  printf %s\\n "file not found './scripts/map.sh'" >&2;
  exit 1;
}
. './scripts/append.sh'
. './scripts/quote.sh'
. './scripts/map.sh'
. './scripts/test_varname.sh'

####################
## HELPER METHODS ##
####################

# _st_quote_file <ALIAS> <METHOD> <FILE>
# ----------------------
# quote a <FILE> then rename function <METHOD> to <ALIAS>
_st_quote_file()
{
  test $# -eq 3 || { printf %s\\n "expect 1 values, provided $#" >&2; exit 1; }
  test "${1##[0-9]*}" && test "x${1}" = "x${1#*[!A-Za-z0-9_]}" || { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  test "${2##[0-9]*}" && test "x${2}" = "x${2#*[!A-Za-z0-9_]}" || { printf %s\\n "invalid variable name '${2}'" >&2; exit 1; }
  test -f "${3}" || { printf %s\\n "file not found '${3}'" >&2; exit 1; }
  sed \
    -e "s/'/'\\\\''/g" \
    -e '1d' \
    -e "s/^${2} ()$/'\"\$\{${1}\}\"' ()/" \
    -e "2s/^/'/" \
    -e "\$s/\$/'/" \
    -e "s#^'\([-[:alnum:]_,./:]*\)=\(.*\)\$#\1='\2#" < "${3}" || \
  { printf %s\\n "sed failed $?" >&2; exit 1; }
}

# _st_import <ALIAS> <METHOD> <FILE>
# ----------------------
# print the item <FILE>, renames function <METHOD> to <ALIAS>
_st_import()
{
  test $# -eq 3 || { printf %s\\n "expect 3 values, provided $#" >&2; exit 1; }
  test "${1##[0-9]*}" && test "x${1}" = "x${1#*[!A-Za-z0-9_]}" || { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  test "${2##[0-9]*}" && test "x${2}" = "x${2#*[!A-Za-z0-9_]}" || { printf %s\\n "invalid variable name '${2}'" >&2; exit 1; }
  test -f "${3}" || { printf %s\\n "file not found '${3}'" >&2; exit 1; }
  append "${1}" "\

## ${2} ##
if grep '^${2}' >/dev/null 2>&1 <<EOL
\${${1}}
EOL
then (
eval \"\${${1}}\"
printf '%s\n' $(_st_quote_file "${2}" "${2}" "${3}" 2>&1)
)
else :
fi
"
}

# _st_header <VARNAME> <SCRIPTS>
# ----------------------
# print the 'shell-tools.sh' script header, replace '${1}' by <VARNAME>
_st_header()
{
v=''
map 'append v "${1%%=*}${nl}"' ${_scripts}
v="$(quote "${v}")${nl}"

sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
##################
## SCRIPT START ##
##################
test x"\${\${1}:-}" != 'x' || \${1}=${v}
EOF

sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<'EOF'
# Remove whitespaces
${1}="$(
LC_ALL=C LANGUAGE=C tr '[\000-\040\176-\377]' '\n' 2>&1 <<EOL
${${1}}
EOL
)" || { printf '%s\n' "[ERROR] tr failed '${${1}}'" >&2; exit 1; }

# Parse options
${1}="$(
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
${${1}}
EOL
)" || { printf '%s\n' "[ERROR] sed failed '${${1}}'" >&2; exit 1; }

if test -z "${${1}}"
then exit 0;
else :
fi

# Validate options
(
_imports="${${1}}"
_st_error='';
nl='
';
for v in ${_imports};
do
case "${v}" in 
  \'*) eval "_st_error=\"\${_st_error}invalid option \"${v}'${nl}'"; continue ;;
  *=*) a="${v%%[=]*}" ;;
  *) a="${v}" ;;
esac
EOF

v='case "${a}" in
'
map 'append v "  $(quote "${1%%=*}")) : ;;
"' ${_scripts}
append 'v' '  *) _st_error="${_st_error}unknown option '\''${a}'\''${nl}" ;;
'
append 'v' 'esac;'
sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
${v}
EOF

sed -e "s/'/'\\\\''/g" -e "\$s/\$/'/" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<'EOF'
done
test x"${_st_error}" = x || { printf '%s\n%s' '[ERROR] invalid options:' "${_st_error}" >&2; exit 1; }
) || exit $?;

# display imports
tr '\n' ' ' <<EOL
${1}='${${1}}'
EOL
printf '\n'

EOF
}

# _st_build <VARNAME>
# ----------------------
# build the 'shell-tools.sh' and assign it to <VARNAME>
_st_build()
{
  test "${1##[0-9]*}" && test "x${1}" = "x${1#*[!A-Za-z0-9_]}" || { printf %s\\n "invalid variable name '${1}'" >&2; exit 1; }
  eval "${1}='#!/bin/sh

'"
  eval "append '${1}' $(_st_header)" || { printf %s\\n "eval failed" >&2; exit 1; }
  for v in ${_scripts}; do
    _st_import "${1}" "${v%%=*}" "${v#*=}"
  done
  append "${1}" "
# cleanup
${1}=; unset '${1}';
"
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
    *=?*) _st_optarg="$(expr "X${_st_option}" : '[^=]*=\(.*\)')" ;;
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

# 8. Automatically find files at './scripts' directory.
_scripts="bourne_compatible=./scripts/bourne_compatible.sh
shell_sanitize=./scripts/shell_sanitize.sh
append=./scripts/append.sh
quote=./scripts/quote.sh
map=./scripts/map.sh
test_varname=./scripts/test_varname.sh
"
set +f
map 'v="${1##*'/'}";
v="${v%'.sh'}";
if printf %s "${_scripts}" | grep "^${v}" >/dev/null 2>&1
then :
else append _scripts "${v}=${1}${nl}";
fi' ./scripts/*
set -f

# 9. Merge all scripts
_st_body="$(eval "_st_build '${_st_import}' > /dev/null 2>&1 && printf '%s\n' \"\${${_st_import}}\"")"

# 10. Write to var `_st_body` to output.
case "${_st_output}" in
  '-') printf '%s\n' "${_st_body}" ;;
  *)
    { printf '%s\n' "${_st_body}" > "${_st_output}"; } || {
      printf '%s\n' "Cannot write to file '${_st_output}'" >&2;
      exit 1;
    };
    chmod +x "${_st_output}" || {
      printf '%s\n' "Cannot make file executable '${_st_output}'" >&2;
      exit 1;
    };
    ;;
esac
