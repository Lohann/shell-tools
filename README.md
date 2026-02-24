# Shell Utils

Collection of portable shell scripts, 

## Project Goals
- **Portable:** All scripts must work consistently in any [posix compliant shell](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) such as `sh`, `bash`, `dash`, `ksh`, `zsh`, `ash`, etc...
- **Compatible**: Don't rely on any non-portable builtins, by default use portable code known to work in any modern posix shell, usage of environemnt specific features or commands are allowed only when there's an equivalent portable alternative (probably slower).
- **System Agnostic:** Must work in any posix compliant operating system, including **Linux**, **MacOS**, **Windows WSL**, etc...

## Code Style Guidelines

### Functions 
A script must define functions with the same name as the script file, the script code must never rely on the name of function to be unchanged, the `build.sh` replaces function names when it creates the `shell-tools.sh`, the user can change function names freely to avoid collisions with existing functions, variables or commands.

### Variables
Variable names should be in lowercase prefixed with `_st_` namespace, parameter expansions must always be enclosed by `{` `}`, it makes easier for tools like `sed` to find and process them.

### Error Handling
All commands are assumed to fail, a command must exit with status 0 or have an error handler, to ignore errors use  `command || :` as this prevents the script from exit unexpectedly when the shell option `set -e` is enabled.  
All explicitly non-zero `exit` declarations outside a subshell must be preceded by an error message, that's why `command || { printf ... >&2; exit 1; }` and `command || return $?` are used everywhere in this codebase.

### Non-portable Grammas
Non portable grammas such as substitution `$(command)`, arithmetic expansion `$(( 1 + 2 ))`, or `zsh` and `bash` specific expansions like `${name::=word}`, `${name:offset:length}`, `${(S)foo//${~sub}/$rep}`, are not portable and must be avoided, if you wish to use them after detect their support in the current shell, they must be escaped and executed using `eval` otherwise shells that don't support them may parse the script wrongly or crash.

### No side effects
When possible prefer to write a pure script, unless when expected, a script must have no sides-effects besides changing the last command status `$?` or output some value, it cannot modify the shell or system environment, modify/create files, modify global variables, export, unset, etc..., examples of pure scripts include the functions defined at `basename.sh`, `dirname.sh`, `quote.sh`, `trim.sh` and `map.sh`. Sadly because the `local` keyword is not portable we must assume all variables are global, consequently to be pure it cannot declare variables outside a subshell, this come with drawbacks, but the benifit is that the caller and other functions don't need to worry about variable name collisions, it also prevents some bugs when a function may indirectly call itself. Some scripts also expects the environment to be untouched, example: A script that uses `set` to capture variables modified before and after execute another script.

## References
 - [GNU Portable Shell Programming](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Portable-Shell.html)
 - [Posix Shell Language Specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
 - [Rich’s sh (POSIX shell) tricks](https://www.etalabs.net/sh_tricks.html)

## LICENSE
MIT
