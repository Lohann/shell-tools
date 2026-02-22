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
if (eval 'st_time=`date "+%s"` && test "$st_time" -gt 1000000000') 2> /dev/null
then eval "
unix_timestamp ()
{
  date '+%s' 
}"
elif (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null
then eval '
unix_timestamp ()
{
printf %s\\n $((`TZ=GMT0 LANGUAGE=C LC_ALL=C date \
'\''+((%Y-1600)*365+(%Y-1600)/4-(%Y-1600)/100+(%Y-1600)/400+1%j-1000-135140)*86400+(1%H-100)*3600+(1%M-100)*60+(1%S-100)'\''`))
}'
else eval '
unix_timestamp () 
{ 
(d=`TZ=GMT0 LANGUAGE=C LC_ALL=C date '\''+y=%Y;j=1%j;h=1%H;m=1%M;s=1%S'\'' 2> /dev/null` && \
eval "${d}" 2> /dev/null && \
expr \( \( $y \- 1600 \) \* 365 \+ \( $y \- 1600 \) \/ 4 \- \( $y \- 1600 \) \/ 100 \+ \( $y \- 1600 \) \/ 400 \+ $j \- 1000 \- 135140 \) \* 86400 \+ \( $h \- 100 \) \* 3600 \+ \( $m \- 100 \) \* 60 \+ \( $s \- 100 \))
}'
fi # unix_timestamp
