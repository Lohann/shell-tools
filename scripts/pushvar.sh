#!/bin/sh

# pushvar <VAR>
# ----------------------
# decrement <VAR>_LEVEL and assign <VAR>_<LEVEL> to <VAR>
pushvar ()
{
  while test $# -gt 0; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    eval "test \${${1}+x} && \\
test \"\${${1}_level:=0}\" -ge 0 && \\
eval \"${1}_\${${1}_level}=\\\"\\\${${1}}\\\"\" && \\
${1}_level=\$((\${${1}_level}+1))" || return $?;
    shift 2> /dev/null || return $?;
  done
}
