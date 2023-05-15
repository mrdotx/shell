#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/sync_notes.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-05-15T08:28:27+0200

source_folder="$HOME/Documents/Notes/html/"
destination_folder="/srv/http/wiki"

sync_to() {
    rsync -acLvh --delete \
        --exclude prinzipal.html \
        "$source_folder" "$1":$destination_folder
}

# sync to webserver
sync_to "m625q"
