#!/bin/sh

# bigint_add <INTEGER> <INTEGER>
# --------------------------------
# Portably adds two unsigned decimal integers of arbitrary size. Returns a
# non-zero status code when the number of parameters != 2, or if any argument
# isn't a valid unsigned decimal.
# 
# NOTE: Integer max size vary per shell, some shells mishandle large variables
# and arguments, for example, Solaris 10 dtksh and the UnixWare 7.1.1 mishandle
# braced variable expansion that crosses a 1024 or 4096-byte boundary.
# @author: Lohann Paterno Coutinho Ferreira <developer@lohann.dev>
# 
# Design Choices:
# 1. Portability over Speed: If you want speed shell is already the wrong
#    choice. Shell is mostly used to interact with heterogeneus unix systems,
#    sysadmin automations and detect system dependencies (ex: GNU Autoconf),
#    once the shell is used as first step to build other programns, is more
#    important for it be predictable (works same way anywhere) and portable
#    (works in a wide range of different systems). that's why some
#    unconventional choices were made here, like don't use of external tools
#    such as sed, awk, bc, etc. (except in some ancient shells, where "test"
#    and "echo" are actually external programns).
#
# 2. Isolation: Shell builtins like "test", "echo", "set" and "return" are
#    quoted to prevent them from being mistakenly replaced by user defined
#    aliases, whoever still breaks when builtins are disabled or renamed.
#
# 3. No Globals, No Locals: The `local` builtin is not supported in all shells
#    (Ex: ksh), also is not part of POSIX Shell Standard. Using variables
#    inside function may overwrite user global ones, to prevent global scope
#    collisions while not sacrifice portability, this method uses positional
#    parameters instead, which have performance drawback.
#
# 4. IFS Safe: Works regardless the IFS value set in the current environment,
#    all expanded arguments are double quoted, including $# and $?, otherwise
#    the code breaks when IFS contains numbers, look this example:
#    BAD:
#    bash -c 'IFS=0123456789; [ 0 -le  $# ] && echo "$# >= 0" || echo "$# < 0"'
#    output: 0 < 0
#
#    GOOD:
#    bash -c 'IFS=0123456789; [ test 0 -le "$#" ] && echo "$# >= 0" || echo "$# < 0"'
#    output: 0 >= 0
bigint_add ()
{
  # Validate parameters
  "test" "$#" -gt 0 || { "echo" "bigint_add:$LINENO: missing operands" >&2; "return" 1; }
  "test" "$#" -gt 1 || { "echo" "bigint_add:$LINENO: missing second operand" >&2; "return" 1; }
  "test" "$#" -eq 2 || { "echo" "bigint_add:$LINENO: extra operand \"$3\"" >&2; "return" 1; }

  # Initialize positional variables
  #        lhs: $1 left number
  #        rhs: $2 right number
  #      carry: $3 carry bit set to 1 or empty
  # lhs_suffix: $4 left number processed digits, used for pattern matching.
  # rhs_suffix: $5 right number computed digits, used for pattern matching.
  #  lhs_digit: $6 left number decimal digit
  #  rhs_digit: $7 right number decimal digit
  #     result: $8 result of lhs + rhs
  "set" "$1" "$2" "" "" "" 0 0 "" || "return" "$?"

  # Starts the carrying addition loop, each iteration computes one decimal digit
  while ":"
  do
    # Extract left number next digit using pattern matching.
    case $1 in
      $4)
        # All digits of the left number were processed
        if test "x$2" = "x$5"
        then "echo" "$3$8"; "return" 0
        else "set" "$2" 0 "$3" "$5" 0 0 0 "$8" && "continue" || "return" "$?"
        fi
        ;;
      *0$4) "set" "$1" "$2" "$3" "0$4" "$5" 0 "$7" "$8" || "return" "$?" ;;
      *1$4) "set" "$1" "$2" "$3" "1$4" "$5" 1 "$7" "$8" || "return" "$?" ;;
      *2$4) "set" "$1" "$2" "$3" "2$4" "$5" 2 "$7" "$8" || "return" "$?" ;;
      *3$4) "set" "$1" "$2" "$3" "3$4" "$5" 3 "$7" "$8" || "return" "$?" ;;
      *4$4) "set" "$1" "$2" "$3" "4$4" "$5" 4 "$7" "$8" || "return" "$?" ;;
      *5$4) "set" "$1" "$2" "$3" "5$4" "$5" 5 "$7" "$8" || "return" "$?" ;;
      *6$4) "set" "$1" "$2" "$3" "6$4" "$5" 6 "$7" "$8" || "return" "$?" ;;
      *7$4) "set" "$1" "$2" "$3" "7$4" "$5" 7 "$7" "$8" || "return" "$?" ;;
      *8$4) "set" "$1" "$2" "$3" "8$4" "$5" 8 "$7" "$8" || "return" "$?" ;;
      *9$4) "set" "$1" "$2" "$3" "9$4" "$5" 9 "$7" "$8" || "return" "$?" ;;
      *) "echo" "fn_add:$LINENO: invalid number \"$1\"" >&2; "return" 1 ;;
    esac

    # Extract right number next digit using pattern matching.
    case $2 in
      $5) :
        # All digits of the right number were added, whoever we are still
        # computing the left number digit + carry bit. 
        ;;
      *0$5) "set" "$1" "$2" "$3" "$4" "0$5" "$6" 0 "$8" || "return" "$?" ;;
      *1$5) "set" "$1" "$2" "$3" "$4" "1$5" "$6" 1 "$8" || "return" "$?" ;;
      *2$5) "set" "$1" "$2" "$3" "$4" "2$5" "$6" 2 "$8" || "return" "$?" ;;
      *3$5) "set" "$1" "$2" "$3" "$4" "3$5" "$6" 3 "$8" || "return" "$?" ;;
      *4$5) "set" "$1" "$2" "$3" "$4" "4$5" "$6" 4 "$8" || "return" "$?" ;;
      *5$5) "set" "$1" "$2" "$3" "$4" "5$5" "$6" 5 "$8" || "return" "$?" ;;
      *6$5) "set" "$1" "$2" "$3" "$4" "6$5" "$6" 6 "$8" || "return" "$?" ;;
      *7$5) "set" "$1" "$2" "$3" "$4" "7$5" "$6" 7 "$8" || "return" "$?" ;;
      *8$5) "set" "$1" "$2" "$3" "$4" "8$5" "$6" 8 "$8" || "return" "$?" ;;
      *9$5) "set" "$1" "$2" "$3" "$4" "9$5" "$6" 9 "$8" || "return" "$?" ;;
      *) "echo" "fn_add:$LINENO: invalid number \"$1\"" >&2; "return" 1 ;;
    esac
    
    # Swap digits if the right digit is greater than the left digit
    "test" "$6" -ge "$7" || "set" "$1" "$2" "$3" "$4" "$5" "$7" "$6" "$8"

    # Single Digit Carrying Add
    # The carrying addition is computed using exaustive pattern matching, which
    # have the downside of being very slow and the benefit of being universally
    # portable even in ancient bourne shells, notice this script prioritizes
    # portability and correctness over speed. Arithmetic Expansion is not
    # supported by some shells (most notably Solaris 10 /bin/sh).
    # 
    # The pattern matching logic below is equivalent to this:
    # if [ $carry == 1 ]; then
    #   digit=$(( ($lhs_digit + $rhs_digit + 1) % 10 ))
    #   carry=$(( ($lhs_digit + $rhs_digit + 1) / 10 ))
    # else
    #   digit=$(( ($lhs_digit + $rhs_digit) % 10 ))
    #   carry=$(( ($lhs_digit + $rhs_digit) / 10 ))
    # fi
    # Obs: Doing "$lhs_digit + $rhs_digit + $carry" has no difference here
    # because pattern matching must be exaustive, eliminate one block simply
    # means rewrite a 2x bigger 3 digit pattern matching block.
    if "test" "$3"
    then
      # Carry bit is set, so compute next digit:
      # digit = (lhs_digit + rhs_digit + 1) % 10
      # carry = (lhs_digit + rhs_digit + 1) / 10
      case $6$7 in
        00) "set" "$1" "$2" "" "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        10) "set" "$1" "$2" "" "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        11|20) "set" "$1" "$2" "" "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        30|21) "set" "$1" "$2" "" "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        40|31|22) "set" "$1" "$2" "" "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        50|41|32) "set" "$1" "$2" "" "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        60|51|42|33) "set" "$1" "$2" "" "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        70|61|52|43) "set" "$1" "$2" "" "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        80|71|62|53|44) "set" "$1" "$2" "" "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        90|81|72|63|54) "set" "$1" "$2" 1 "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        91|82|73|64|55) "set" "$1" "$2" 1 "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        92|83|74|65) "set" "$1" "$2" 1 "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        93|84|75|66) "set" "$1" "$2" 1 "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        94|85|76) "set" "$1" "$2" 1 "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        95|86|77) "set" "$1" "$2" 1 "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        96|87) "set" "$1" "$2" 1 "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        97|88) "set" "$1" "$2" 1 "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        98) "set" "$1" "$2" 1 "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        99) "set" "$1" "$2" 1 "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        *) "echo" "bigint_add: invalid digits \"$6$7\"" >&2; "return" 1 ;;
      esac
    else
      # No carry bit, compute next digit:
      # digit = (lhs_digit + rhs_digit) % 10
      # carry = (lhs_digit + rhs_digit) / 10
      case $6$7 in
        00) "set" "$1" "$2" "" "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        10) "set" "$1" "$2" "" "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        11|20) "set" "$1" "$2" "" "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        30|21) "set" "$1" "$2" "" "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        40|31|22) "set" "$1" "$2" "" "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        50|41|32) "set" "$1" "$2" "" "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        60|51|42|33) "set" "$1" "$2" "" "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        70|61|52|43) "set" "$1" "$2" "" "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        80|71|62|53|44) "set" "$1" "$2" "" "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        90|81|72|63|54) "set" "$1" "$2" "" "$4" "$5" 0 0 "9$8" || "return" "$?" ;;
        91|82|73|64|55) "set" "$1" "$2" 1 "$4" "$5" 0 0 "0$8" || "return" "$?" ;;
        92|83|74|65) "set" "$1" "$2" 1 "$4" "$5" 0 0 "1$8" || "return" "$?" ;;
        93|84|75|66) "set" "$1" "$2" 1 "$4" "$5" 0 0 "2$8" || "return" "$?" ;;
        94|85|76) "set" "$1" "$2" 1 "$4" "$5" 0 0 "3$8" || "return" "$?" ;;
        95|86|77) "set" "$1" "$2" 1 "$4" "$5" 0 0 "4$8" || "return" "$?" ;;
        96|87) "set" "$1" "$2" 1 "$4" "$5" 0 0 "5$8" || "return" "$?" ;;
        97|88) "set" "$1" "$2" 1 "$4" "$5" 0 0 "6$8" || "return" "$?" ;;
        98) "set" "$1" "$2" 1 "$4" "$5" 0 0 "7$8" || "return" "$?" ;;
        99) "set" "$1" "$2" 1 "$4" "$5" 0 0 "8$8" || "return" "$?" ;;
        *) "echo" "bigint_add: invalid digits \"$6$7\"" >&2; "return" 1 ;;
      esac
    fi
  done
  # Unreachable code: no break statement exist inside the while loop.
  "echo" "bigint_add: unrechable code executed, please report this bug" >&2
  "return" 127
} # bigint_add
