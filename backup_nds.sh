#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_nds.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-10-03T05:21:33+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
backup_path="${1:-.}"
labels="DSONEI R4-SDHC R4I-GOLD R4I-SDHC ACE3DS-P"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='*/gb/' \
        --exclude='*/gba/' \
        --exclude='*/gbc/' \
        --exclude='*/gen/' \
        --exclude='*/gg/' \
        --exclude='*/nds/' \
        --exclude='*/nes/' \
        --exclude='*/ngp/' \
        --exclude='*/sms/' \
        --exclude='*/snes/'"
rsync_saves_options="-aAXvh --delete\
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
        roms="$mnt/$rom_folder"
        [ -d "$roms" ] \
            && printf ":: create rom list for %s\n" \
                "$rom_folder" \
            && eval "find $roms $find_roms_options" \
            | sed "s#^$roms/##g" \
            | sort > "$backup_path/$label/$rom_folder/list_$rom_folder"
    done
}

backup() {
    for label in $labels; do
        unset mnt

        # mount
        [ -h "/dev/disk/by-label/$label" ] \
            && printf ":: check file system on %s\n" \
                "$label" \
            && $auth fsck.fat "/dev/disk/by-label/$label" \
            && mnt="/tmp/$label" \
            && printf ":: create and mount backup folder %s\n" \
                "$mnt" \
            && mkdir -p "$mnt" \
            && $auth mount \
                -t vfat \
                "/dev/disk/by-label/$label" \
                "$mnt"

        # backup
        [ -d "$mnt" ] \
            && printf ":: create folder and backup %s to %s\n" \
                "$mnt" \
                "$backup_path/$label" \
            && eval "rsync $rsync_options $mnt $backup_path" \
            && eval "rsync $rsync_saves_options $mnt $backup_path" \
            && rom_list gb gba gbc gen gg nds nes ngp sms snes \

        # unmount
        [ -d "$mnt" ] \
            && printf ":: unmount and delete mount folder %s\n" \
                "$mnt" \
            && $auth umount "$mnt" \
            && find "$mnt" -empty -type d -delete \
            && return 0
    done
}

# main
backup \
    && exit 0

printf ":: please connect one of the following devices to backup from:\n"
for label in $labels; do
    printf "  -> %s\n" "$label"
done
