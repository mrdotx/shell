#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/cloudsync.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-17 11:28:44

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

title=("web.de")
title+=("GMX")
title+=("Google Drive")
title+=("Dropbox")

src=("$HOME/cloud/webde/")
src+=("$HOME/cloud/gmx/")
src+=("$HOME/cloud/googledrive/")
src+=("$HOME/cloud/dropbox/")

dest=("webde:/")
dest+=("gmx:/")
dest+=("googledrive:/")
dest+=("dropbox:/")

icon=("$HOME/coding/shell/icons/web.de.png")
icon+=("$HOME/coding/shell/icons/gmx.png")
icon+=("$HOME/coding/shell/icons/google-drive.png")
icon+=("$HOME/coding/shell/icons/dropbox.png")

# rclone to copy data from and to cloud
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "Usage:"
    echo "	cloudsync.sh [option]"
    echo
    echo "Options:"
    echo "  -c - check"
    echo "  -s - sync"
    echo
    echo "Example:"
    echo "	cloudsync.sh -c"
    exit 0
elif [[ $1 == "-c" ]]; then
    for ((i=0;i<${#title[@]};i++)); do
        echo "[${magenta}${title[i]}${reset}] <- ${src[i]}"
        rclone check -P ${src[i]} ${dest[i]}
        notify-send -i ${icon[i]} "Check ${title[i]}" "completed!"
    done
    exit 0
elif [[ $1 == "-s" ]]; then
    for ((i=0;i<${#title[@]};i++)); do
        echo "[${magenta}${title[i]}${reset}] <- ${src[i]}"
        rclone copy -P ${src[i]} ${dest[i]}
        #rclone sync -P ${src[i]} ${dest[i]}
        echo "[${magenta}${title[i]}${reset}] -> ${src[i]}"
        rclone copy -P ${dest[i]} ${src[i]}
        #rclone sync -P ${dest[i]} ${src[i]}
        notify-send -i ${icon[i]} "Sync ${title[i]}" "completed!"
    done
    exit 0
fi
