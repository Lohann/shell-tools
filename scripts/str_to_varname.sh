#!/bin/sh

# valid_varname <STRING>
# ----------------------
# Transform <STRING> into a valid shell variable name.
str_to_varname ()
{
  test $# -eq 1 || return 127;

  # Avoid depending upon Character Ranges.
  printf '%s\n' "${1}" | sed 'y%*+%pp%;s%[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]%_%g'
}
