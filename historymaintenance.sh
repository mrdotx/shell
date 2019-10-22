#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/historymaintenance.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# color variables {{{
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)
# }}}

# procedure {{{
echo "[${magenta}python${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.python_history

echo "[${magenta}python${reset}] sort and remove duplicates"
sort -u "$HOME"/.python_history | sort -o "$HOME"/.python_history

echo "[${magenta}bash${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.bash_history

echo "[${magenta}bash${reset}] sort and remove duplicates"
sort -u "$HOME"/.bash_history | sort -o "$HOME"/.bash_history

echo "[${magenta}zsh${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.zsh_history

echo "[${magenta}zsh${reset}] sort and remove duplicates"
sort -t ";" -k 2 -u "$HOME"/.zsh_history | sort -o "$HOME"/.zsh_history
# }}}
