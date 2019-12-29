#!/usr/bin/env bash

# path:       ~/projects/shell/sync_rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-29 14:51:28

script=$(basename "$0")
help="$script [-h/--help] -- script to copy from/to cloud with rclone
  Usage:
    $script [option]

  Setting:
    [option] = check or sync
      -c     = check
      -s     = sync

  Example:
    $script -c"

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
src=("$HOME/cloud/webde/")
dest=("webde:/")
icon=("$HOME/projects/shell/icons/web.de.png")
exclude=("")
exclude1=("")

title+=("GMX")
src+=("$HOME/cloud/gmx/")
dest+=("gmx:/")
icon+=("$HOME/projects/shell/icons/gmx.png")
exclude+=("")
exclude1+=("")

title+=("Google Drive")
src+=("$HOME/cloud/googledrive/")
dest+=("googledrive:/")
icon+=("$HOME/projects/shell/icons/google-drive.png")
exclude+=("")
exclude1+=("")

title+=("OneDrive")
src+=("$HOME/cloud/onedrive/")
dest+=("onedrive:/")
icon+=("$HOME/projects/shell/icons/onedrive.png")
exclude+=("")
exclude1+=("")

title+=("Dropbox")
src+=("$HOME/cloud/dropbox/")
dest+=("dropbox:/")
icon+=("$HOME/projects/shell/icons/dropbox.png")
exclude+=("KeePass**")
exclude1+=("Apps**")

# rclone to copy data from and to cloud
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "$help"
    exit 0
elif [[ $1 == "-c" ]]; then
    for ((i=0;i<${#title[@]};i++)); do
        echo "[${magenta}${title[i]}${reset}] <- ${src[i]}"
        rclone check -P "${src[i]}" "${dest[i]}" --exclude="${exclude[i]}" --exclude="${exclude1[i]}"
        notify-send -i "${icon[i]}" "Check ${title[i]}" "completed!"
    done
    exit 0
elif [[ $1 == "-s" ]]; then
    for ((i=0;i<${#title[@]};i++)); do
        echo "[${magenta}${title[i]}${reset}] <- ${src[i]}"
        rclone copy -P "${src[i]}" "${dest[i]}" --exclude="${exclude[i]}" --exclude="${exclude1[i]}"
        #rclone sync -P "${src[i]}" "${dest[i]}" --exclude="${exclude[i]}" --exclude="${exclude1[i]}"
        echo "[${magenta}${title[i]}${reset}] -> ${src[i]}"
        rclone copy -P "${dest[i]}" "${src[i]}" --exclude="${exclude[i]}" --exclude="${exclude1[i]}"
        #rclone sync -P "${dest[i]}" "${src[i]}" --exclude="${exclude[i]}" --exclude="${exclude1[i]}"
        notify-send -i "${icon[i]}" "Sync ${title[i]}" "completed!"
    done
    exit 0
fi
