#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/old/backup.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-22T16:41:28+0200

# color variables
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

destroot="$HOME/Backup/"
destconf="$HOME/Backup/.config/"

# home/folders
src="
#$HOME/.conky
#$HOME/.jameica
#$HOME/.newsboat
#$HOME/.ssh
#$HOME/.weechat
"
# home/files
src="$src
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
src="$src
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
src="$src
#$HOME/.config/libinput-gestures.conf
"

# backup
printf "[%sbackup%s] folder & files\n" "${magenta}" "${reset}"
for dir in $src; do
    case "${dir}" in
    $HOME/.newsboat)
        rsync --delete -acqP --exclude="cache.db" "${dir}" "$destroot"
        ;;
    $HOME/.weechat)
        rsync --delete -acqP --exclude="weechat.log" --exclude="logs" "${dir}" "$destroot"
        ;;
    $HOME/.config/*)
        rsync --delete -acqP "${dir}" "$destconf"
        ;;
    $HOME/*)
        rsync --delete -acqP "${dir}" "$destroot"
        ;;
    esac
    printf "[%ssource%s] %s" "${cyan}" "${reset}" "${dir}"
done

# backup size
printf "[%sbackup%s] size" "%{blue}" "%{reset}"
du -sh "$HOME/Backup/"
notify-send "Backup complete" "$(du -sh "$HOME/Backup/")"
