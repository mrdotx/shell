#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/cloudsync.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# color variables {{{
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)
# }}}

# config {{{
    title=("Dropbox")
    title+=("Google Drive")
    title+=("web.de")
    title+=("GMX")

    src=("$HOME/cloud/dropbox/")
    src+=("$HOME/cloud/googledrive/")
    src+=("$HOME/cloud/webde/")
    src+=("$HOME/cloud/gmx/")

    dest=("dropbox:/")
    dest+=("googledrive:/")
    dest+=("webde:/")
    dest+=("gmx:/")
# }}}    

# procedure {{{
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "Usage:"
    echo "	cloudsync.sh [option]"
    echo
    echo "Example:"
    echo "	cloudsync.sh -c"
    echo
    echo "Options:"
    echo "  -c - check"
    echo "  -s - sync"
    exit 0
elif [[ $1 == "-c" ]]; then
    for ((i=0;i<${#title[@]};i++)); do
        echo "[${magenta}${title[i]}${reset}] <- ${src[i]}"
        rclone check -P ${src[i]} ${dest[i]}
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
        notify-send "Sync ${title[i]}" "completed!"
    done
    exit 0
fi
# }}}
