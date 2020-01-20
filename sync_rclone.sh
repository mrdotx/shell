#!/bin/sh

# path:       ~/projects/shell/sync_rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-20T17:54:23+0100

# color variables
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
#magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

script=$(basename "$0")
help="$script [-h/--help] -- script to copy/sync from/to cloud with rclone
  Usage:
    $script [option]

  Setting:
    [option]     = check, copy or sync
      -check     = check
      -copy      = copy
      -sync_to   = sync to destination
      -sync_from = sync from destination

  Example:
    $script -check
    $script -copy
    $script -sync_to
    $script -sync_from"

rc_dir="$HOME/cloud"
rc_cfg="
web.de;       $rc_dir/webde/;       webde:/;       $rc_dir/webde/.filter
GMX;          $rc_dir/gmx/;         gmx:/;         $rc_dir/gmx/.filter
Google Drive; $rc_dir/googledrive/; googledrive:/; $rc_dir/googledrive/.filter
OneDrive;     $rc_dir/onedrive/;    onedrive:/;    $rc_dir/onedrive/.filter
Dropbox;      $rc_dir/dropbox/;     dropbox:/;     $rc_dir/dropbox/.filter
"

rc_vars() {
    title=$(echo "$1" | cut -d ";" -f1 | tr -d ' ')
    src=$(echo "$1" | cut -d ";" -f2 | tr -d ' ')
    dest=$(echo "$1" | cut -d ";" -f3 | tr -d ' ')
    filter=$(echo "$1" | cut -d ";" -f4 | tr -d ' ')
}

rc_check() {
    echo "[${yellow}$1${reset}] <- $2"
    rclone check -l -P "$2" "$3" --filter-from="$4"
}

rc_copy() {
    echo "[${yellow}$1${reset}] <- $2"
    rclone copy -l -P "$2" "$3" --filter-from="$4"
    echo "[${yellow}$1${reset}] -> $2"
    rclone copy -l -P "$3" "$2" --filter-from="$4"
}

rc_sync_to() {
    echo "[${yellow}$1${reset}] <- $2"
    rclone sync -l -P "$2" "$3" --filter-from="$4"
}

rc_sync_from() {
    echo "[${yellow}$1${reset}] -> $2"
    rclone sync -l -P "$3" "$2" --filter-from="$4"
}

rc_exec() {
    printf "%s\n" "$rc_cfg" | {
        while IFS= read -r line
        do
            if [ -n "$line" ]; then
                rc_vars "$line"
                $1 "$title" "$src" "$dest" "$filter"
            fi
        done
    }
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
elif [ "$1" = "-check" ]; then
    rc_exec "rc_check"
elif [ "$1" = "-copy" ]; then
    rc_exec "rc_copy"
elif [ "$1" = "-sync_to" ]; then
    rc_exec "rc_sync_to"
elif [ "$1" = "-sync_from" ]; then
    rc_exec "rc_sync_from"
fi
