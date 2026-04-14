# Portable Shell Scripts

Collection of reusable portable shell scripts.

## Why?
Automating things is the most important task a system administrator has to take care of, but there are many flavors of shell, and their differences are a big concern when you have a heterogeneous environment and want to run the same script with the same result on every machine (that’s what any sane person would expect).  
Writing [portable shell script](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Portable-Shell.html) is hard, most scripts you will find online actually uses some `bash` or `zsh` specific feature.  
| OS                   | Default Shell  | Bourne Shell `/bin/sh` |
| :---                 |    :----:      |          ---:          |
| **Ubuntu / Debian**  | `bash v5.2.37` | `dash v0.5.12`         |
| **MacOS Tahoe**      | `zsh 5.9`      | `bash v3.2.57`         |
| **Alpine Linux**     | [busybox ash](https://github.com/mirror/busybox/blob/1_36_1/shell/ash.c) | [busybox ash](https://github.com/mirror/busybox/blob/1_36_1/shell/ash.c) |
| **DragonFlyBSD**     | [csh](https://github.com/DragonFlyBSD/DragonFlyBSD/tree/master/bin/csh) | [mksh](https://github.com/DragonFlyBSD/DragonFlyBSD/blob/master/bin/sh/sh.1)       |
| **Solaris**          | [ksh93](https://github.com/kofemann/opensolaris/tree/master/usr/src/cmd/ksh) | [sun bourne shell](https://github.com/kofemann/opensolaris/tree/master/usr/src/cmd/sh)  |
| **Windows**          | | [Git Bash](https://git-scm.com/install/windows), [Cygwin](https://cygwin.com/), [MSYS2](https://www.msys2.org/), [win-bash](https://win-bash.sourceforge.net/) |

## Project Goals
- **Portable:** All scripts must work consistently in any shell compatible with [Posix Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) such as `sh`, `bash`, `dash`, `busybox ash`, `ksh`, `zsh`, `pdksh`, `mksh` etc...
- **Compatible**: Don't rely on any non-portable builtins, by default use portable code known to work in any modern posix shell, usage of environemnt specific features or commands are allowed only when there's an equivalent portable alternative (probably slower).
- **System Agnostic:** Must work in any posix compliant operating system, including **Linux**, **MacOS**, **Windows WSL**, etc...

## Common mistakes
Most developers interact with shell every day, you may never had to write a single shell script, but I bet you probably use shell for things like `npm install`, `python main.py`, `ssh <user>:<server>`, `docker run -p 8080:8080 <image>`, etc... is not hard to find scripts like this in open-source projects:
```shell
# bad
docker run -it -v $PWD:/source debian:trixie echo hello
# also bad
docker run -it -v $(pwd):/source debian:trixie echo hello
```
Did you spotted the issue? it only breaks when any directory in `$PWD` contain spaces (or any character in `IFS` actually), quickly you find you need to use double quotes, what option below do you think is correct?
```shell
docker run -it -v "$PWD":/source debian:trixie           # Option A
docker run -it -v "$PWD:/sou"rce debian:trixie           # Option B
"docker" "run" "-it" "-v" "$PWD:/source" "debian:trixie" # Option C
docker run -it -v "$PWD":"/"s"o"u"r"c"e" debian:trixie   # Option D
```
Who have experience in modern programming languages find the options `B` and `D` suspect, uglyness aside they are actually all equivalent, there's no difference between `A`, `B`, `C` or `D`, you can verify it yourself: 
```shell
echo docker run -it -v "$PWD":/source debian:trixie           # Option A
echo docker run -it -v "$PWD:/sou"rce debian:trixie           # Option B
echo "docker" "run" "-it" "-v" "$PWD:/source" "debian:trixie" # Option C
echo docker run -it -v "$PWD":"/"s"o"u"r"c"e" debian:trixie   # Option A
```
Whoever they aren't exactly equivalent when you consider shell `alias` in the mix, all the commands above can be substituted by aliases, except `Option C` which have everything quoted:
```shell
alias docker='echo blue #'

docker run --rm -it -v "$PWD:/source" debian:trixie echo red
# OUTPUT: blue

"docker" "run" "--rm" "-it" "-v" "$PWD:/source" "debian:trixie" "echo" "red"
# OUTPUT: red
```
in the **MacOS** `ls` is actually an alias for `ls -G`, and in **Ubuntu 24.04** it is an alias for `ls --color=auto`, this is the most common usage of aliases.  
Whoever an alias is not like a C macro, it cannot substitute a parameter, only commands:
```shell
alias say='echo bye'
echo say goodbye # OUTPUT: say goodbye
say goodbye      # OUTPUT: bye goodbye
```

## Code Style Guidelines

### Functions 
A script must define functions with the same name as the script file, the script code must never rely on the name of function to be unchanged, the `build.sh` replaces function names when it creates the `shell-tools.sh`, the user can change function names freely to avoid collisions with existing functions, variables or commands.  
The `local` keyword isn't defined in [POSIX-V3 Shell Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) standard, but is supported by [almost all shells](https://github.com/jaalto/project--shell-script-performance-and-portability/tree/master?tab=readme-ov-file#43-writing-portable-shell-scrips) (only exception is ksh). I notice the `local` most of the time can be replaced by `set x <value>`, and in cases where `set` is inconvenient the [locals.sh](./scripts/locals.sh) is a portable and more flexible alternative, because it allows you to define locals and unshadow globals inside functions (see [scripts/locals.sh](./scripts/locals.sh)).


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
 - [Shell script performance and portability](https://github.com/jaalto/project--shell-script-performance-and-portability)
 - [For rooting out Bash-specific idiosyncrasies in scripts](https://mywiki.wooledge.org/Bashism)

## LICENSE
MIT
