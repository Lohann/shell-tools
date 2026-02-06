#!/bin/sh

# clean_dir <DIR>
# ------------------
# Remove all contents from within DIR, including any unwritable
# subdirectories, but leave DIR itself untouched.
clean_dir ()
{
  test $# -eq 1 || return 127;
  test -d "${1}" || { printf '%s\n' "directory not found '${1}'" >&2; return 1; };
  find "${1}" -type d ! -perm -700 -exec chmod u+rwx {} \; || :;
  rm -fr "${1}"* "${1}".[!.] "${1}".??*
}
