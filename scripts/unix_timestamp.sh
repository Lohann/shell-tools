#!/bin/sh

# Sadly `date +%s` is not portable.
# The only magic number in here is 135140, the number of days between
# 1600-01-01 and 1970-01-01 treating both as Gregorian dates. 1600 is
# used as the multiple-of-400 epoch here instead of 2000 since C-style
# division behaves badly with negative dividends.
#
# Original code:
# https://www.etalabs.net/sh_tricks.html

# unix_timestamp
# ---------------------
# Prints the unix timestamp, which is seconds passed since January 1st, 1970 at UTC
if (eval 'st_time=`TZ=UTC0 LANG=C LC_ALL=C date "+%s"` && test "$st_time" -gt 1000000000') 2> /dev/null
then unix_timestamp ()
{
  TZ=UTC0 LANG=C LC_ALL=C date '+%s' 
}
elif (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null
then eval 'unix_timestamp ()
{
  eval "set x `TZ=UTC0 LANG=C LC_ALL=C date '+%Y 1%j 1%H 1%M 1%S' 2>/dev/null`" && test "$#" -eq 6 || return 125
  printf %s\\n $((`TZ=UTC0 LANG=C LC_ALL=C date '\''+((%Y-1600)*365+(%Y-1600)/4-(%Y-1600)/100+(%Y-1600)/400+1%j-1000-135140)*86400+(1%H-100)*3600+(1%M-100)*60+(1%S-100)'\''`))
}'
else unix_timestamp ()
{
  eval "set x `TZ=UTC0 LANG=C LC_ALL=C date '+%Y 1%j 1%H 1%M 1%S' 2>/dev/null`" && test "$#" -eq 6 || return 125
  eval "set x \"\`eval 'LC_ALL=C expr \"$2\" \"-\" \"1600\" 2>&1 || test \"\$?\" -eq 1'\`\" $3 $4 $5 $6" || return 125
  eval "set x \"\`eval 'LC_ALL=C expr \"$2\" \"*\" 365 \"+\" \"$2\" \"/\" 4 \"-\" \"$2\" \"/\" 100 \"+\" \"$2\" \"/\" 400 \"+\" \"$3\" \"-\" 1000 \"-\" 135140 2>&1 || test \"\$?\" -eq 1'\`\" $4 $5 $6" || return 125
  LC_ALL=C expr "$2" "*" 86400 "+" "(" "$3" "-" 100 ")" "*" 3600 "+" "(" "$4" "-" 100 ")" "*" 60 "+" "(" "$5" "-" 100 ")" || test "$?" -eq 1
}
fi # unix_timestamp
