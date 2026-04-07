#!/bin/sh

# quote <STRING>
# ----------------------
# wraps the string in single quotes.
#
# The most common approach to escape single quotes in a string is by replace them 
# with '\'' (quote, slash, quote, quote), unfortunately this naive approach also
# may add lots of useless quotes if the original value has consecutive single quotes
# or begins/ends with single quotes. The logic implemented by this function
# takes that into consideration and never adds useless quotes.
#
# Example:
# naive_quote() {
#   printf %s "$1" | sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e '$s/$/'\''/'
# }
#
# original value: '''some'''value'''
#   naive escape: ''\'''\'''\''some'\'''\'''\''value'\'''\'''\'''
#  better escape: \'\'\''some'\'\'\''value'\'\'\'
# 
# 'better' and 'naive' are the same value, you can verify it by running:
# a=''\'''\'''\''some'\'''\'''\''value'\'''\'''\'''
# b=\'\'\''some'\'\'\''value'\'\'\'
# test "$a" = "$b" && echo 'A and B are equal!'
quote ()
{
  # The two x's in the printf is a tricky to prevent `sed` 
  # from removing leading and trailing spaces.
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
