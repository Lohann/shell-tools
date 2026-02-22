#!/bin/sh

# trim <STRING>
# ---------------------
# Removes blank characters [ \t\n\r\f\v] from both ends of this string
trim ()
{
  printf '%s' "$*" | \
  sed \
    -n \
    -e ':begin' \
    -e '$bend' \
    -e 'N' \
    -e 'bbegin' \
    -e ':end' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]*$//' \
    -e 'p'
}
