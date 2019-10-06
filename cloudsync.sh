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
# check dropbox {{{
    echo "[${magenta}Dropbox${reset}] <- $HOME/cloud/dropbox/"
    rclone check "$HOME"/cloud/dropbox/ dropbox:/
# }}}
# check googledrive {{{
    echo "[${magenta}Google Drive${reset}] <- $HOME/cloud/googledrive/"
    rclone check "$HOME"/cloud/googledrive/ googledrive:/
# }}}
# check web.de {{{
    echo "[${magenta}web.de${reset}] <- $HOME/cloud/webde/"
    rclone check "$HOME"/cloud/webde/ webde:/
# }}}
# check gmx {{{
    echo "[${magenta}GMX${reset}] <- $HOME/cloud/gmx/"
    rclone check "$HOME"/cloud/gmx/ gmx:/
# }}}
    exit 0
elif [[ $1 == "-s" ]]; then
# sync dropbox {{{
    echo "[${magenta}Dropbox${reset}] <- $HOME/cloud/dropbox/"
    rclone copy -P "$HOME"/cloud/dropbox/ dropbox:/
    #rclone sync -P "$HOME"/cloud/dropbox/ dropbox:/
    echo "[${magenta}Dropbox${reset}] -> $HOME/cloud/dropbox/"
    rclone copy -P dropbox:/ "$HOME"/cloud/dropbox/
    #rclone sync -P dropbox:/ "$HOME"/cloud/dropbox/
    notify-send "Sync Dropbox" "completed!"
# }}}
# sync googledrive {{{
    echo "[${magenta}Google Drive${reset}] <- $HOME/cloud/googledrive/"
    rclone copy -P "$HOME"/cloud/googledrive/ googledrive:/
    #rclone sync -P "$HOME"/cloud/googledrive/ googledrive:/
    echo "[${magenta}Google Drive${reset}] -> $HOME/cloud/googledrive/"
    rclone copy -P googledrive:/ "$HOME"/cloud/googledrive/
    #rclone sync -P googledrive:/ "$HOME"/cloud/googledrive/
    notify-send "Sync Google Drive" "completed!"
# }}}
# sync web.de {{{
    echo "[${magenta}web.de${reset}] <- $HOME/cloud/webde/"
    rclone copy -P "$HOME"/cloud/webde/ webde:/
    #rclone sync -P "$HOME"/cloud/webde/ webde:/
    echo "[${magenta}web.de${reset}] -> $HOME/cloud/webde/"
    rclone copy -P webde:/ "$HOME"/cloud/webde/
    #rclone sync -P webde:/ "$HOME"/cloud/webde/
    notify-send "Sync web.de" "completed!"
# }}}
# sync gmx {{{
    echo "[${magenta}GMX${reset}] <- $HOME/cloud/gmx/"
    rclone copy -P "$HOME"/cloud/gmx/ gmx:/
    #rclone sync -P "$HOME"/cloud/gmx/ gmx:/
    echo "[${magenta}GMX${reset}] -> $HOME/cloud/gmx/"
    rclone copy -P gmx:/ "$HOME"/cloud/gmx/
    #rclone sync -P gmx:/ "$HOME"/cloud/gmx/
    notify-send "Sync GMX" "completed!"
# }}}
    exit 0
fi

