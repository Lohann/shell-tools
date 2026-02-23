# Shell Utils

Collection of portable shell scripts, 

## Project Goals
- **Portable:** All scripts must work consistently in any [posix compliant shell](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) such as `sh`, `bash`, `dash`, `ksh`, `zsh`, `ash`, etc...
- **Compatible**: Don't rely on any non-portable builtins, by default use portable code known to work in any modern posix shell, usage of environemnt specific features or commands are allowed only when there's an equivalent portable alternative (probably slower).
- **System Agnostic:** Must work in any posix compliant operating system, including **Linux**, **MacOS**, **Windows WSL**, etc...

## Shell Code Guidelines
- **Pure Scripts** A script is pure when executed it has no sides-effects besides changing the last command status `$?`. It means pure code do not modify the shell or system environment, ex: modify/create files, modify global variables, export, unset, etc..., examples of pure code include the functions defined at `basename.sh`, `dirname.sh`, `quote.sh`, `trim.sh`, `append.sh` and `map.sh`. Sadly because the `local` keyword is not portable then all variables are global, consequently a pure script cannot declare variables outside a subshell, this may sound very strict and annoying, but has real benefits, calling pure function is equivalent to execute regular command/program, the caller don't need to worry about variable name collisions, and prevents various bugs when a function like `map.sh` eval some code that executes itself. Some scripts also requires the environment to be untouched, example: A script that uses `set` to capture variables modified before and after execute another script.

## References
 - [GNU Portable Shell Programming](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Portable-Shell.html)
 - [Posix Shell Language Specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
 - [Rich’s sh (POSIX shell) tricks](https://www.etalabs.net/sh_tricks.html)

## LICENSE
MIT
