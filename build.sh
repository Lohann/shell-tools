#!/bin/sh

####################
### START SCRIPT ###
####################

# 1. Find 'scripts' directory, assuming this script is the root directory.
{ test "${0}" && test -f "${0}"; } || {
  echo "file name \$0 is not defined, cannot find script root directory" >&2;
  exit 1;
};

# 2. Check if $0 is an absolute or relative path.
case "${0}" in
  *[\/]*) _basedir="$(dirname "${0}")" || exit $? ;;
  *)      _basedir='.' || exit $? ;;
esac

# 3. Make sure we are in "${0}" directory
test -f "${_basedir}/build.sh" || {
  printf %s\\n "'${_basedir}/build.sh' not found, rerun with an absolute file name" >&2;
  exit 1;
};

# 4. find 'scripts/bourne_compatible.sh' script.
cd "${_basedir}" || exit $?
test -f "${_basedir}/scripts/bourne_compatible.sh" || {
  printf %s\\n "file not found '${_basedir}/scripts/bourne_compatible.sh'" >&2;
  exit 1;
}

# 5. load dependencies.
. "${_basedir}/scripts/bourne_compatible.sh"
. "${_basedir}/scripts/append.sh"
. "${_basedir}/scripts/quote.sh"
. "${_basedir}/scripts/map.sh"

# 6. list scripts
_scripts=''
set +f
map '
v="${1##*'/'}";
v="${v%'.sh'}";
append _scripts "${v}=${1}${nl}";
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

v='case "\${a}" in'
map 'append v "  $(quote "${1%%=*}")) ;;${nl}"' ${_scripts}
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
