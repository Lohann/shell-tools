# Shell Utils

Collection of portable shell scripts.

## Design Goals
- **Portable:** Works in any [posix compliant shell](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html) such as `sh`, `bash`, `dash`, `ksh`, `zsh`, `ash`, etc...
- **Compatible**: Don't make use of implementation specific features, probe the system to use only portable features.
- **System Agnostic:** Works in any posix compliant system, including **Linux**, **MacOS**, **Windows WSL**, etc...
