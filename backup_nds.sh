#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_nds.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-10-02T17:32:00+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
auth_user="klassiker"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='*/gb/' \
        --exclude='*/gba/' \
        --exclude='*/gbc/' \
        --exclude='*/nds/' \
        --exclude='*/nes/' \
        --exclude='*/snes/'"
rsync_saves_options="-aAXvh \
        --include='*/' \
        --include='*.[Ss][Aa][Vv]' \
        --include='*.[Ss][Rr][Mm]' \
        --exclude='*'"
find_roms_options="-type f \
        ! -iname '*.sav' \
        ! -iname '*.srm'"

# helper functions
rom_list() {
    for rom_folder in "$@"; do
        roms="/mnt/$label/$rom_folder"
        [ -d "$roms" ] \
            && printf ":: create rom list for %s\n" "$rom_folder" \
            && eval "find $roms $find_roms_options" \
            | sed "s#^$roms/##g" \
            | sort > "$label/$rom_folder/list_$rom_folder"
    done

    return 0
}

backup() {
    for label in "$@"; do
        # mount
        [ -h "/dev/disk/by-label/$label" ] \
            && mnt="/mnt/$label" \
            && printf ":: create and mount backup folder %s\n" "$mnt" \
            && $auth mkdir -p "$mnt" \
            && $auth mount "/dev/disk/by-label/$label" "$mnt"

        # backup
        [ -d "$mnt" ] \
            && printf ":: create folder and backup %s to %s\n" "$mnt" "$label" \
            && eval "$auth rsync $rsync_options $mnt ." \
            && eval "$auth rsync $rsync_saves_options $mnt ." \
            && printf ":: set owner for %s to %s\n" "$label" "$auth_user" \
            && $auth chown -R "$auth_user": "$label" \
            && rom_list gb gba gbc nds nes snes \

        # unmount
        [ -d "$mnt" ] \
            && printf ":: unmount and delete mount folder %s\n" "$mnt" \
            && $auth umount "$mnt" \
            && $auth find "$mnt" -empty -type d -delete

        unset mnt
    done

    return 0
}

# main
backup DSONEI R4-SDHC R4I-SDHC
