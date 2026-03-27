#!/bin/sh
# Copyright (C) 1992-1994, 1998, 2000-2017, 2020-2023 Free Software
# Foundation, Inc.
# ----------------------------------------------------------------------------
# This is a modified version of m4sh from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1742-L1805

# version_compare <VERSION_1> <OP> <VERSION_2>
# ----------------------------------------------------------------------------
# Compare two strings possibly containing shell variables as version strings.
# Valid operator <OP> includes
#  -        LESS THAN: '-lt' '<' 
#  -    LESS OR EQUAL: '-le' '<=' 
#  -            EQUAL: '-eq' '=' '==' 
#  -        NOT EQUAL: '-ne' '!='
#  - GREATER OR EQUAL: '-ge' '>=' 
#  -     GREATER THAN: '-gt' '>' 
#
# This usage is portable even to ancient awk,
# so don't worry about finding a "nice" awk version.
version_compare ()
{
  test "$#" -eq 3 || { printf '%s\n' "usage: version_compare <V1> [-eq|-ne|-gt|-ge|-lt|-le] <V2>
expected 3 arguments, provided $#" >&2; return 127; }

  # Internaly all operators are converted to integers with prime factors
  # 2, 3 and 5, it reduces the amount of logic necessary to evaluate all
  # combinations of expressions and operators.
  # Each basic operator is represent as an unique prime number:
  # -lt = 2
  # -gt = 3
  # -eq = 5
  # Other operators are product of basic operators:
  # -le = -lt || -eq == 2 * 5 == 10
  # -ge = -gt || -eq == 3 * 5 == 15
  # -ne = -lt || -gt == 2 * 3 == 6
  # Then compute N by comparing v1 and v2 as follow:
  # N = 2 when v1 < v2
  # N = 3 when v1 > v2
  # N = 5 when v1 = v2
  # The exit status is OPERATOR % N, which correctly evaluates to zero
  # when the expression is true, and non-zero when the expression is false.
  LANGUAGE=C LC_ALL=C awk '
# Use only awk features that work with 7th edition Unix awk (1978).
# My, what an old awk you have, Mr. Solaris!
END {
  # exit status 7 if operator is invalid.
  op = 0
  if (length(v0) == 1) {
    if (v0 ~ /^</) { op = 2 }
    if (v0 ~ /^>/) { op = 3 }
    if (v0 ~ /^=/) { op = 5 }
  } else {
  if (length(v0) == 2) {
    if (v0 ~ /^==/) { op = 5 }
    if (v0 ~ /^!=/) { op = 6 }
    if (v0 ~ /^<=/) { op = 10 }
    if (v0 ~ /^>=/) { op = 15 }
  } else {
  if (length(v0) == 3) {
    if (v0 ~ /^-lt/) { op = 2 }
    if (v0 ~ /^-le/) { op = 10 }
    if (v0 ~ /^-eq/) { op = 5 }
    if (v0 ~ /^-ne/) { op = 6 }
    if (v0 ~ /^-ge/) { op = 15 }
    if (v0 ~ /^-gt/) { op = 3 }
  } else { exit 7 }}}
  if (length(v0) && op) { op += 0 } else { exit 7 }
  while (length(v1) && length(v2)) {
    # Set d1 to be the next thing to compare from v1, and likewise for d2.
    # Normally this is a single character, but if v1 and v2 contain digits,
    # compare them as integers and fractions as strverscmp does.
    if (v1 ~ /^[0-9]/ && v2 ~ /^[0-9]/) {
      # Split v1 and v2 into their leading digit string components d1 and d2,
      # and advance v1 and v2 past the leading digit strings.
      for (len1 = 1; substr(v1, len1 + 1) ~ /^[0-9]/; len1++) continue
      for (len2 = 1; substr(v2, len2 + 1) ~ /^[0-9]/; len2++) continue
      d1 = substr(v1, 1, len1); v1 = substr(v1, len1 + 1)
      d2 = substr(v2, 1, len2); v2 = substr(v2, len2 + 1)
      if (d1 ~ /^0/) {
        if (d2 ~ /^0/) {
          # Compare two fractions.
          while (d1 ~ /^0/ && d2 ~ /^0/) {
            d1 = substr(d1, 2); len1--
            d2 = substr(d2, 2); len2--
          }
          if (len1 != len2 && ! (len1 && len2 && substr(d1, 1, 1) == substr(d2, 1, 1))) {
            # The two components differ in length, and the common prefix
            # contains only leading zeros.  Consider the longer to be less.
            d1 = -len1
            d2 = -len2
          } else {
            # Otherwise, compare as strings.
            d1 = "x" d1
            d2 = "x" d2
          }
        } else {
          # A fraction is less than an integer.
          exit (op % 2)
        }
      } else {
        if (d2 ~ /^0/) {
          # An integer is greater than a fraction.
          exit (op % 3)
        } else {
          # Compare two integers.
          d1 += 0
          d2 += 0
        }
      }
    } else {
      # The normal case, without worrying about digits.
      d1 = substr(v1, 1, 1); v1 = substr(v1, 2)
      d2 = substr(v2, 1, 1); v2 = substr(v2, 2)
    }
    if (d1 < d2) { exit (op % 2) }
    if (d1 > d2) { exit (op % 3) }
  }
  # Beware Solaris 11 /usr/xgp4/bin/awk, which mishandles some
  # comparisons of empty strings to integers.  For example,
  # LC_ALL=C /usr/xpg4/bin/awk "BEGIN {if (-1 < \"\") print \"a\"}"
  # prints "a".
  if (length(v2)) { exit (op % 2) }
  if (length(v1)) { exit (op % 3) }
  exit (op % 5)
}' v0="${2}" v1="${1}" v2="${3}" /dev/null || \
  case $? in
    7 ) printf %s\\n "invalid operator '${2}'" >&2; return 7 ;;
    [123456] ) return 1 ;;
    * ) return 127 ;;
  esac
}
