#!/bin/sh

# quote <STRING>
# ----------------------
# wraps the string in single quotes.
quote ()
{
  printf %s "x${*}x" | sed -e "s/'/'\\\\''/g" -e "1s/^x/'/" -e '$s/x$/'\''/'
}
