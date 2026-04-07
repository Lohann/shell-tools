#!/bin/sh

# printf_colors FMT ...ARGS
# ----------------------------------------
# Extend printf escape sequences to support colors.
# if available uses `tput` to detect if the current
# terminal supports colors, then query a default escape
# sequences for errors (red), warnings (yellow) and bold.
# When the terminal doesn't support colors calling this 
# function is equivalent to plain printf.
#  errors (red) and warnings (yellow),
# 
# Colors Escapes:
# @b: bold
# @e: red
# @w: yellow
# @E: red + bold
# @W: yellow + bold
#
# Usage:
# - printf_colors '%s\n' 'normal text'
# - printf_colors '@b\n' 'bold text'
# - printf_colors '@e\n' 'red text'
# - printf_colors '@w\n' 'yellow text'
# - printf_colors '@E\n' 'red+bold'
# - printf_colors '@W\n' 'yellow+bold'
# - printf_colors '@E @w %s @b @W @e @w\n' 'all' 'colors' 'mixed' 'in' 'the' 'same' 'text'
if test -t 1 && (tput colors && colors=`tput colors` && test "x$colors" != 'x' && test 8 -le "$colors") >/dev/null 2>&1
then
  # Eval is used to hardcode the escape sequences in the function body,
  # so it doesn't need to rely on global variables for storing colors.
  # isn't possible to change the colors without redefining this function.
  eval "printf_colors ()
{
  test \"\$#\" -gt 0 || { printf; return \"\$?\"; }
  set x '{
  s/\\([\\\\\$\`\"]\\)/\\\\\\1/g
  s/\\(@[EWbew]\\)/\\1%s\\\${4}/g
  s/\\(@[EWb]\\)/\\\${1}\\1/g
  s/@b//g
  s/@[Ww]/\\\${2}/g
  s/@[Ee]/\\\${3}/g
  1s/^x/x\"/
  \$s/x\$/\"x/
}' \"{
  1s/^x//
  \\\$s/x\\\$//
  s/[^']*[^']/\\\\n&\\\\n/g
  \\\$!s/\\\\n\\\$//
  \\\$!s/'\\\$/'\\\\n/
  1!s/^\\\\n//
  1!s/^'/\\\\n'/
  s/'/\\\\\\\\&/g
  s/\\\\n/'/g
  /^\\\$/{
    1s/^/'/
    \\\$s/\\\$/'/
  }
}\" \"\$@\" && shift || return 125
  eval 'shift && shift && shift && set x '\"\`eval 'printf \"x%sx\" \"\$3\" | sed -e \"\$1\" -e \"\$2\"'\`\"' \"\$@\"' && shift || return \"\$?\"
  set x '`tput bold`' '`tput setaf 3`' '`tput setaf 1`' '`tput sgr0`' \"\$@\" && shift || return \"\$?\"
  eval \"eval 'shift && shift && shift && shift && shift && set x \\\"'\$5'\\\" \\\"\\\$@\\\"'\" && shift || return \"\$?\"
  printf \"\$@\"
}" || { printf '%s\n' "failed to define function 'printf_colors' status $?" >&2; exit 1; }
else printf_colors ()
{
  # terminal doesn't support colors or tput not found, this sed
  # script simply replace all colors escape sequences with `%s`.
  set x '{
    1s/^x//
    $s/x$//
    s/\([\\#$`"]\)/\\\1/g
    s/\(@[EWbew]\)/%s/g
  }' "$@" && shift || return 125;
  (st_fmt=`printf x%sx "$2" | LC_ALL=C sed "$1" 2> /dev/null` &&
  shift &&
  shift &&
  eval "st_fmt=\"${st_fmt}\"" > /dev/null 2>&1 &&
  printf "${st_fmt}" "$@";)
} # printf_colors
fi
