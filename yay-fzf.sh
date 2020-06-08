#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/yay-fzf.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T13:24:33+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to install/remove packages with yay and fzf
  Usage:
    $script [-S/-R/-Re]

  Settings:
    [-S]    = install packages from pacman or aur
    [-R]    = remove installed packages from pacman or aur
    [-Re]   = remove explicit installed packages from pacman or aur

  Examples:
    $script -S
    $script -R
    $script -Re"

execute() {
    search_options="$1"
    process_options="$2"
    yay -"$search_options" \
        | fzf -m -e -i --preview "cat <(yay -Si {1}) <(yay -Fl {1} \
            | awk \"{print \$2}\")" \
        | xargs -ro yay -"$process_options"
}

case "$1" in
    -S)
        execute "Slq" "S"
        ;;
    -R)
        execute "Qq" "Rsn"
        ;;
    -Re)
        execute "Qqe" "Rsn"
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
        ;;
esac
