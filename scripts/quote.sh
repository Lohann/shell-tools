#!/bin/sh

# quote <STRING>
# ----------------------
# wraps the string in single quotes.
quote () 
{
  printf x%sx "$*" | LC_ALL=C sed "{
    1s/^x//
    \$s/x\$//
    s/[^']*[^']/\\x0a&\\x0a/g
    \$!s/\\x0a\$//
    \$!s/'\$/'\\x0a/
    1!s/^\\x0a//
    1!s/^'/\\x0a'/
    s/'/\\\\&/g
    s/\\x0a/'/g
    /^\$/{
      1s/^/'/
      \$s/\$/'/
    }
  }"
}
