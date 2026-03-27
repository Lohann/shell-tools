#!/bin/sh

# quote <STRING>
# ----------------------
# wraps the string in single quotes.
quote () 
{
  printf x%sx "$*" | sed "{
    1s/^x//
    \$s/x\$//
    s/[^']*[^']/\\n&\\n/g
    \$!s/\\n\$//
    \$!s/'\$/'\\n/
    1!s/^\\n//
    1!s/^'/\\n'/
    s/'/\\\\&/g
    s/\\n/'/g
    /^\$/{
      1s/^/'/
      \$s/\$/'/
    }
  }"
}
