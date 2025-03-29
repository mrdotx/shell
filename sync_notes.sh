#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/sync_notes.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-03-29T06:02:34+0100

source_folder="$HOME/Documents/Notes/html/"
destination_folder="/srv/http/wiki"

# color variables
reset="\033[0m"
bold="\033[1m"
blue="\033[94m"
cyan="\033[96m"

sync_to() {
    rsync -acLvh --delete \
        --exclude prinzipal.html \
        "$source_folder" "${1:+"$1:"}$destination_folder"
}

case $@ in
    "")
        printf "%b%b::%b %bsync%b %b%s%b %bto%b %b%s%b\n" \
            "$bold" "$blue" "$reset" "$bold" "$reset" \
            "$cyan" "$source_folder" "$reset" "$bold" "$reset" \
            "$cyan" "$destination_folder" "$reset"
        sync_to
        ;;
    *)
        for host_name in "$@"; do
            printf "%b%b::%b %bsync%b %b%s%b %bto%b %b%s%b %bon%b %b%s%b\n" \
            "$bold" "$blue" "$reset" "$bold" "$reset" \
                "$cyan" "$source_folder" "$reset" "$bold" "$reset" \
                "$cyan" "$destination_folder" "$reset" "$bold" "$reset" \
                "$cyan" "$host_name" "$reset"
            sync_to "$host_name"
        done
        ;;
esac
