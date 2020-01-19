#!/bin/sh

# path:       ~/projects/shell/maintenance_system.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-19T11:46:09+0100

echo "python history"
echo "  1. remove white space the from end of line"
sed -i "s/ *$//" "$HOME/.python_history"

echo "  2. sort and remove duplicates"
sort -u "$HOME/.python_history" | sort -o "$HOME/.python_history"

echo
echo "bash history"
echo "  1. remove white space from the end of line"
sed -i "s/ *$//" "$HOME/.bash_history"

echo "  2. sort and remove duplicates"
sort -u "$HOME/.bash_history" | sort -o "$HOME/.bash_history"

echo
echo "zsh history"
echo "  1. remove white space from the end of line"
sed -i "s/ *$//" "$HOME/.zsh_history"

echo "  2. sort and remove duplicates"
sort -t ";" -k 2 -u "$HOME/.zsh_history" | sort -o "$HOME/.zsh_history"

echo
echo ".cache files"
echo "  files that have not been accessed in 100 days"
while true; do
    printf "\r%s" "  press [enter] to show files or to delete cache [y]es/[n]o: " && read -r "key"
    echo
    case "$key" in
        y|Y) find "$HOME/.cache/" -type f -atime +100 -delete && exit 0;;
        n|N) exit 0;;
        *) find "$HOME/.cache/" -type f -atime +100 && echo;;
    esac
done
