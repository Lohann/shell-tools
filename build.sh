#!/bin/sh

####################
### START SCRIPT ###
####################

# 1. Find 'scripts' directory, assuming this script is the root directory.
{ test "${0}" && test -f "${0}"; } || {
  echo "file name \$0 is not defined, cannot find script root directory" >&2;
  exit 1;
};

if expr a : '\(a\)' >/dev/null 2>&1 && test "X`expr 00001 : '.*\(...\)'`" = X001;
then st_expr=expr
else st_expr=false
fi

if (st_dir=`dirname -- /` && test "X$st_dir" = X/) >/dev/null 2>&1;
then st_dirname=dirname
else st_dirname=false
fi

_basedir=`${st_dirname} -- "${0}" ||
${st_expr} X"${0}" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
	 X"${0}" : 'X\(//\)[^/]' \| \
	 X"${0}" : 'X\(//\)$' \| \
	 X"${0}" : 'X\(/\)' \| . 2>/dev/null ||
printf '%s\n' X"${0}" |
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
	  s/.*/./; q'`

# 3. Make sure we are in "${0}" directory
test -d "${_basedir}" || {
  printf %s\\n "directory '${_basedir}' not found" >&2;
  exit 1;
};
test -f "${_basedir}/build.sh" || {
  printf %s\\n "'${_basedir}/build.sh' not found, rerun with an absolute file name" >&2;
  exit 1;
};
cd "${_basedir}" || {
  printf %s\\n "change to directory '${_basedir}' failed $?" >&2;
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

# 4. Preload 'scripts/bourne_compatible.sh' script.
test -f "./scripts/bourne_compatible.sh" || {
  printf %s\\n "file not found './scripts/bourne_compatible.sh'" >&2;
  exit 1;
}
. './scripts/bourne_compatible.sh'

# 5. Preload 'scripts/shell_sanitize.sh' script.
test -f "./scripts/shell_sanitize.sh" || {
  printf %s\\n "file not found './scripts/shell_sanitize.sh'" >&2;
  exit 1;
}
. './scripts/shell_sanitize.sh'

# 6. Preload other dependencies used in this script.
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
. './scripts/append.sh'
. './scripts/quote.sh'
. './scripts/map.sh'

# 6. Automatically find all scripts
_scripts="bourne_compatible=./scripts/bourne_compatible.sh
shell_sanitize=./scripts/shell_sanitize.sh
append=./scripts/append.sh
quote=./scripts/quote.sh
map=./scripts/map.sh
"

set +f
map '
v="${1##*'/'}";
v="${v%'.sh'}";
if printf %s "${_scripts}" | grep "^${v}" >/dev/null 2>&1
then :
else append _scripts "${v}=${1}${nl}";
fi
' ./scripts/*
set -f

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
)" || { printf '%s' "tr failed '${${1}}'" >&2; exit 1; }

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
)" || { printf '%s' "sed failed '${${1}}'" >&2; exit 1; }

if test -z "${${1}}"
then exit 0;
else :
fi

# Validate options
(
_imports="${${1}}"
is_valid=:
for v in ${_imports};
do
case "${v}" in 
  \'*) is_valid=false; eval "printf \"invalid option '%s'\n\" ${v}"; continue ;;
  *=*) a="${v%%[=]*}" ;;
  *) a="${v}" ;;
esac
EOF

v='case "${a}" in
'
map 'append v "  $(quote "${1%%=*}")) : ;;
"' ${_scripts}
append 'v' '  *) is_valid=false; printf "unknown option '%s'\n" "${a}" ;;'
append 'v' 'esac;'
sed -e "s/'/'\\\\''/g" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<EOF
${v}
EOF

sed -e "s/'/'\\\\''/g" -e "\$s/\$/'/" -e "s/\\\${1}/'\"\\\${1}\"'/g" <<'EOF'
done
${is_valid} || exit 1;
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

_st_build "${1:-st_import}"
eval "printf '%s\n' \"\${${1:-st_import}}\""
