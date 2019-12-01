#!/bin/sh

# path:       ~/coding/shell/maintenance_system.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 13:39:57

# color variables
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

# purge cache
echo "[${magenta}cache${reset}] purge all .cache files that have not been accessed in 100 days"
find "$HOME"/.cache/ -type f -atime +100 -delete

# python history
echo "[${magenta}python${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.python_history

echo "[${magenta}python${reset}] sort and remove duplicates"
sort -u "$HOME"/.python_history | sort -o "$HOME"/.python_history

# bash history
echo "[${magenta}bash${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.bash_history

echo "[${magenta}bash${reset}] sort and remove duplicates"
sort -u "$HOME"/.bash_history | sort -o "$HOME"/.bash_history

# zsh history
echo "[${magenta}zsh${reset}] remove white space from end of line"
sed -i "s/ *$//" "$HOME"/.zsh_history

echo "[${magenta}zsh${reset}] sort and remove duplicates"
sort -t ";" -k 2 -u "$HOME"/.zsh_history | sort -o "$HOME"/.zsh_history
