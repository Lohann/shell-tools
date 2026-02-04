#!/bin/sh

# quote <STRING>
# ----------------------
# wraps the string in single quotes.
quote ()
{
  printf %s "${1}" | sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "\$s/\$/'/"
}
