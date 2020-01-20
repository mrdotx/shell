#!/bin/sh

# path:       ~/projects/shell/maintenance_system.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-20T14:39:31+0100

readc() {
    if [ -t 0 ]; then
        saved_tty_settings=$(stty -g)
        stty -icanon min 1 time 0
    fi
    eval "$1="
    while
        c=$(dd bs=1 count=1 2> /dev/null; echo .)
        c=${c%.}
        [ -n "$c" ] &&
            eval "$1=\${$1}"'$c
                [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'; do
        continue
    done
    if [ -t 0 ]; then
        stty "$saved_tty_settings"
    fi
}

echo ":: python history"
echo " remove white space the from end of line..."
sed -i "s/ *$//" "$HOME/.python_history"

echo " sort and remove duplicates..."
sort -u "$HOME/.python_history" | sort -o "$HOME/.python_history"

echo
echo ":: bash history"
echo " remove white space from the end of line..."
sed -i "s/ *$//" "$HOME/.bash_history"

echo " sort and remove duplicates..."
sort -u "$HOME/.bash_history" | sort -o "$HOME/.bash_history"

echo
echo ":: zsh history"
echo " remove white space from the end of line..."
sed -i "s/ *$//" "$HOME/.zsh_history"

echo " sort and remove duplicates..."
sort -t ";" -k 2 -u "$HOME/.zsh_history" | sort -o "$HOME/.zsh_history"

echo
echo ":: .cache files"
echo " files that have not been accessed in 120 days..."
key=""
while true; do
    printf "\r%s" " press [enter] to show files or to delete cache [y]es/[n]o: " && readc "key"
    echo
    case "$key" in
        y|Y) find "$HOME/.cache/" -type f -atime +120 -delete && exit 0;;
        n|N) exit 0;;
        *) find "$HOME/.cache/" -type f -atime +120 && echo;;
    esac
done
