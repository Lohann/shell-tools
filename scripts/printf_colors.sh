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
# @n: bold
# @r: red     | @R: red + bold
# @g: green   | @G: green + bold
# @b: blue    | @B: blue + bold
# @y: yellow  | @Y: yellow + bold
# @c: cyan    | @C: cyan + bold
#
# Usage:
# - printf_colors '@R @y %s @b @Y @g @C\n' 'all' 'colors' 'mixed' 'in' 'the' 'same' 'text'
# - printf_colors '%s\n' 'normal text'
# - printf_colors '@n\n' 'bold text'
# - printf_colors '@r\n' 'red text'
# - printf_colors '@y\n' 'yellow text'
# - printf_colors '@R\n' 'red+bold'
# - printf_colors '@Y\n' 'yellow+bold'
if test -t 1 && (tput colors && colors=`tput colors` && test "x$colors" != 'x' && test 8 -le "$colors") >/dev/null 2>&1
then
  # Eval is used to hardcode the escape sequences in the function body,
  # so it doesn't need to rely on global variables for storing colors.
  # isn't possible to change the colors without redefining this function.
  eval "printf_colors ()
{
  test \"\$#\" -gt 0 || { printf; return \"\$?\"; }
  set x 'eval printf \"x%sx\" \"\$3\" | sed \"\$2\" 2>/dev/null' '{
  s/'\\''/'\\''\\\\'\\'\\''/g
  s/[\\\\\$\`\"]/\\\\&/g
  s/@[RGBYCrgbycn]/&%s\\\${7}/g
  s/@[RGBYCn]/\\\${1}&/g
  s/@n//g
  s/@[Rr]/\\\${2}/g
  s/@[Gg]/\\\${3}/g
  s/@[Bb]/\\\${4}/g
  s/@[Yy]/\\\${5}/g
  s/@[Cc]/\\\${6}/g
  s/'\\''/'\\''\\\\'\\'\\''/g
  1s/^x/shift \\&\\& shift \\&\\& shift \\&\\& set x '\\'\\\"\\''\\\\'\\'\\''/
  \$s/x\$/'\\''\\\\'\\'\\'\\\"\\'' \\\"\\\$@\\\" \\&\\& shift/
}' \"\$@\" && shift || return 125
  eval \"\`\$1\`\" || return 125
  set x '`tput bold`' '`tput setaf 1`' '`tput setaf 2`' '`tput setaf 4`' '`tput setaf 3`' '`tput setaf 6`' '`tput sgr0`' \"\$@\" && shift || return 125
  eval \"eval 'shift && shift && shift && shift && shift && shift && shift && shift && set x '\$8' \\\"\\\$@\\\" && shift'\" || return 125
  printf \"\$@\"
}" || { printf '%s\n' "failed to define function 'printf_colors' status $?" >&2; exit 1; }
else printf_colors ()
{
  # terminal doesn't support colors or tput not found, this sed
  # script simply replace all colors escape sequences with `%s`.
  set x 'eval printf "x%sx" "$3" | sed "$2" 2>/dev/null' '{
    s/[\\$`"]/\\&/g
    s/@[RGBYCrgbycn]/%s/g
    1s/^x/shift \&\& shift \&\& shift \&\& set x "/
    $s/x$/" "\$@" \&\& shift/
  }' "$@" && shift || return 125;
  eval "`$1`" || return 125
  printf "$@"
} # printf_colors
fi
