#!/bin/sh

# popvar <VAR>
# ----------------------
# pops a value from the stack and assign it to <VAR>
popvar ()
{
  while test $# -gt 0; do
    # Check stack varname
    case ${1} in
      [0-9_] | [!a-zA-Z_]* | *[!a-zA-Z0-9_]* ) :
        printf %s\\n "invalid varname '${1}'" >&2; return 127 ;;
      [a-zA-Z_]* ) :
        eval "test \"\${${1}_level:-0}\" -ge 0" > /dev/null || \
        { printf %s\\n "not a stack '${1}'" >&2; return 127; } ;;
      * ) printf %s\\n "invalid varname '${1}'" >&2; return 127 ;;
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
}
