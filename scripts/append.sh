#!/bin/sh

# append VAR VALUE
# ----------------------
# Append the text in VALUE to the end of the definition contained in VAR. Take
# advantage of any shell optimizations that allow amortized linear growth over
# repeated appends, instead of the typical quadratic growth present in naive
# implementations.
if (eval "st_var=1; st_var+=2; test x\$st_var = x12") 2>/dev/null
then eval 'append ()
{
  eval "${1}+=\"\${2}\""
}'
else append ()
{
  eval "${1}=\"\${${1}}\${2}\""
}
fi
