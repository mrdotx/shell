#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/snippets/backup.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# color variables {{{
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)
# }}}

# source {{{
DESTROOT="$HOME/Backup/"
DESTCONF="$HOME/Backup/.config/"
# home/folders
SRC="
#$HOME/.conky
#$HOME/.jameica
#$HOME/.newsboat
#$HOME/.ssh
#$HOME/.weechat
"
# home/files
SRC="$SRC
#$HOME/.bashrc
#$HOME/.gitconfig
#$HOME/.jameica.properties
#$HOME/.lynx_bookmarks.html
#$HOME/.lynxrc
#$HOME/.profile
#$HOME/.tmux.conf
#$HOME/.vimrc
"
# home/.config/folders
SRC="$SRC
#$HOME/.config/cmus
#$HOME/.config/filezilla
#$HOME/.config/htop
#$HOME/.config/kitty
#$HOME/.config/mc
#$HOME/.config/mpv
#$HOME/.config/polybar
#$HOME/.config/powerline-shell
#$HOME/.config/ranger
#$HOME/.config/rofi
#$HOME/.config/zathura
"
# home/.config/files
SRC="$SRC
#$HOME/.config/libinput-gestures.conf
"
# }}}

# backup {{{
echo "[${magenta}backup${reset}] folder & files"
for dir in $SRC; do
    case "${dir}" in
    $HOME/.newsboat)
        rsync --delete -acqP --exclude "cache.db" "${dir}" "$DESTROOT"
        ;;
    $HOME/.weechat)
        rsync --delete -acqP --exclude={weechat.log,logs} "${dir}" "$DESTROOT"
        ;;
    $HOME/.config/*)
        rsync --delete -acqP "${dir}" "$DESTCONF"
        ;;
    $HOME/*)
        rsync --delete -acqP "${dir}" "$DESTROOT"
        ;;
    esac
    echo "[${cyan}source${reset}] ${dir}"
done
# }}}

# backup size {{{
echo "[${blue}backup${reset}] size"
du -sh "$HOME"/Backup/
notify-send "Backup complete" "$(du -sh "$HOME"/Backup/)"
# }}}
