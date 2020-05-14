#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/yay-fzf.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:45:17+0200

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

proc() {
    srch_args="$1"
    proc_args="$2"
    yay -"$srch_args" \
        | fzf -m -e -i --preview "cat <(yay -Si {1}) <(yay -Fl {1} \
            | awk \"{print \$2}\")" \
        | xargs -ro yay -"$proc_args"
}

case "$1" in
    -S)
        proc "Slq" "S"
        ;;
    -R)
        proc "Qq" "Rsn"
        ;;
    -Re)
        proc "Qqe" "Rsn"
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
        ;;
esac
