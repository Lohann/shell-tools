#!/bin/sh

# pushvar <VAR>
# ----------------------
# push a value into the stack <VAR>, if the stack doesn't exists, create one.
pushvar ()
{
  while test "$#" -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '${1}'" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \${${1}+y}" 2> /dev/null ||
        { printf %s\\n "'${1}' is undefined" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '${1}'" >&2; return 127 ;;
    esac
    # check stack level
    eval "test \"\${${1}_level:=0}\" -ge 0" 2> /dev/null ||
    { printf %s\\n "invalid '${1}_level': not an integer" >&2; return 127; }
    # assign value to stack
    eval "eval \"${1}_\${${1}_level}=\\\"\\\${${1}}\\\"\"" || return 125
    # increment stack level
    eval "${1}_level=\$(( 1 + \${${1}_level} ))" || return 125
    test "$#" -gt 1 || return 0
    shift 2> /dev/null || return 125
  done
}
