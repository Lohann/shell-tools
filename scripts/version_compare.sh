#!/bin/sh

# code adapted from GNU autoconf v2.72
# original code:
# https://github.com/autotools-mirror/autoconf/blob/v2.72/lib/m4sugar/m4sh.m4#L1742-L1805

# version_compare <VERSION_1> <OP> <VERSION_2>
# ----------------------------------------------------------------------------
# Compare two strings possibly containing shell variables as version strings.
# Valid operator <OP> includes
#  -        LESS THAN: '-lt' '<' 
#  -    LESS OR EQUAL: '-le' '<=' 
#  -            EQUAL: '-eq' '=' '==' 
#  - GREATER OR EQUAL: '-ge' '>=' 
#  -     GREATER THAN: '-gt' '>' 
#
# This usage is portable even to ancient awk,
# so don't worry about finding a "nice" awk version.
version_compare ()
{
  test $# -eq 3 || return 127;
  case "${2}" in
    -lt|'<') : ;;
    -le|'<=') : ;;
    -eq|'='|'==') : ;;
    -ge|'>=') : ;;
    -gt|'>') : ;;
    *) printf %s\\n "unknown operator '${2}'" >&2; return 127 ;;
  esac
  
  # test AWK
  ( { awk 'BEGIN { exit 0 }' && awk 'BEGIN { exit 123 }'; }; test $? -eq 123; ) > /dev/null 2>&1 || return 127;

  # execute awk in a `if` statement, so it doesn't exit when errexit `-e` is enabled.
  if awk '# Use only awk features that work with 7th edition Unix awk (1978).
  # My, what an old awk you have, Mr. Solaris!
  END {
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
	    exit 1
	  }
	} else {
	  if (d2 ~ /^0/) {
	    # An integer is greater than a fraction.
	    exit 2
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
      if (d1 < d2) exit 1
      if (d1 > d2) exit 2
    }
    # Beware Solaris 11 /usr/xgp4/bin/awk, which mishandles some
    # comparisons of empty strings to integers.  For example,
    # LC_ALL=C /usr/xpg4/bin/awk "BEGIN {if (-1 < \"\") print \"a\"}"
    # prints "a".
    if (length(v2)) exit 1
    if (length(v1)) exit 2
  }
'  v1="${1}" v2="${3}" /dev/null
  then :
  else
    # else body cannot be empty, we can't use ':' because it would trash the value of $?.
    # Instead we use 'case e in e) <BODY> ;; esac' which is valid even when <BODY> is empty.
    case e in e) ;; esac;
  fi
  # exit status 1 means $v1 < $v2
  # exit status 0 means $v1 = $v2
  # exit status 2 means $v1 > $v2
  case $? in
    1) case "$2" in -lt|-le|'<'|'<=') return 0 ;; *) return 1 ;; esac ;;
    0) case "$2" in -eq|-le|-ge|'='|'=='|'>='|'<=') return 0 ;; *) return 1 ;; esac ;;
    2) case "$2" in -gt|-ge|'>'|'>=') return 0 ;; *) return 2 ;; esac ;;
    *) return 127; ;;
  esac
}
