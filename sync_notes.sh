#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/sync_notes.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-12-15T09:21:38+0100

source_folder="$HOME/Documents/Notes/html/"
destination_folder="/srv/http/wiki"

sync_to() {
    rsync -acLvh --delete \
        --exclude prinzipal.html \
        "$source_folder" "${1:+"$1:"}$destination_folder"
}

case $@ in
    "")
        printf ":: sync %s to %s\n" \
            "$source_folder" \
            "$destination_folder"
        sync_to
        ;;
    *)
        for host_name in "$@"; do
            printf ":: sync %s to %s on %s\n" \
                "$source_folder" \
                "$destination_folder" \
                "$host_name"
            sync_to "$host_name"
        done
        ;;
esac
