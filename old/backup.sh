#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-09-23T12:39:15+0200

# color variables
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

destination_root="$HOME/Backup/"
destination_config="$HOME/Backup/.config/"

# home/folders
source_object="
#$HOME/.jameica
#$HOME/.newsboat
#$HOME/.ssh
"
# home/files
source_object="$source_object
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
source_object="$source_object
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
source_object="$source_object
#$HOME/.config/libinput-gestures.conf
"

# backup
printf "[%sbackup%s] folder & files\n" "${magenta}" "${reset}"
for dir in $source_object; do
    case "${dir}" in
    "$HOME"/.newsboat)
        rsync -acqPh --delete --exclude="cache.db" "${dir}" "$destination_root"
        ;;
    "$HOME"/.weechat)
        rsync -acqPh --delete --exclude="weechat.log" --exclude="logs" "${dir}" "$destination_root"
        ;;
    "$HOME"/.config/*)
        rsync -acqPh --delete "${dir}" "$destination_config"
        ;;
    "$HOME"/*)
        rsync -acqPh --delete "${dir}" "$destination_root"
        ;;
    esac
    printf "[%ssource_object%s] %s" "${cyan}" "${reset}" "${dir}"
done

# backup size
printf "[%sbackup%s] size" "%{blue}" "%{reset}"
du -sh "$HOME/Backup/"
notify-send \
    -u low \
    "Backup complete" \
    "$(du -sh "$HOME/Backup/")"
