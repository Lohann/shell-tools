#!/bin/sh

# clean_dir <DIR>
# ------------------
# Remove all contents from within DIR, including any unwritable
# subdirectories, but leave DIR itself untouched.
clean_dir ()
{
  test $# -eq 1 || return 127;
  test "x${1}" != x || { printf '%s\n' "directory name is empty" >&2; return 127; };
  test -d "${1}" || { printf '%s\n' "directory not found '${1}'" >&2; return 1; };

  # Check if the directory is empty
  # ref: https://www.etalabs.net/sh_tricks.html
  # (
  case "$-" in
    *f* ) printf '%s\n' "pathname expansion is disabled, please enable it 'set +f'" >&2; return 127 ;;
    * ) : ;;
  esac
  (
  cd "${1}" || return 127
  set x .[!.]* && shift || return 127
  test ! -f "${1}" || return 0
  set x ..?*  && shift || return 127
  test ! -f "${1}" || return 0
  set x * && shift || return 127
  test ! -f "${1}" || return 0
  shift || return 127
  return 7
  ) || case $? in 7 ) return 0 ;; * ) return 127 ;; esac
  
  find "${1}" -type d ! -perm -700 -exec chmod u+rwx {} \; || :
  rm -fr "${1}"* "${1}".[!.] "${1}".??*
}
