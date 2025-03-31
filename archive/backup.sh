#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-03-31T06:55:49+0200

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

# color variables
reset="\033[0m"
magenta="\033[35m"
cyan="\033[36m"
blue="\033[94m"

# backup
printf "[%bbackup%b] folder & files\n" "$magenta" "$reset"
for folder in $source_object; do
    case "$folder" in
    "$HOME"/.newsboat)
        rsync -acqPh --delete --exclude="cache.db" \
            "$folder" "$destination_root"
        ;;
    "$HOME"/.weechat)
        rsync -acqPh --delete --exclude="weechat.log" --exclude="logs" \
            "$folder" "$destination_root"
        ;;
    "$HOME"/.config/*)
        rsync -acqPh --delete \
            "$folder" "$destination_config"
        ;;
    "$HOME"/*)
        rsync -acqPh --delete \
            "$folder" "$destination_root"
        ;;
    esac
    printf "[%bsource_object%b] %s" "$cyan" "$reset" "$folder"
done

# backup size
printf "[%bbackup%b] size" "$blue" "$reset"
du -sh "$HOME/Backup/"
notify-send \
    -u low \
    "Backup complete" \
    "$(du -sh "$HOME/Backup/")"
