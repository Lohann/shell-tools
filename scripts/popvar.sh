#!/bin/sh

# popvar <VAR>
# ----------------------
# push the value at <VAR> into stack.
popvar ()
{
  while test $# -gt 0; do
    { test -n "${1#[0-9]}" && test "x${1#*[!A-Za-z0-9_]}" = "x${1}"; } || return 1;
    eval "test \"\${${1}_level:-0}\" -gt 0 && \
${1}_level=\$((\${${1}_level}-1)) && \
eval \"${1}=\\\"\\\${${1}_\${${1}_level}:-}\\\"\" && \
unset \"${1}_\${${1}_level}\"" || return $?;
    shift 2> /dev/null || return $?;
  done
}
