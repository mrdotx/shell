#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_system.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-05-31T05:48:22+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
user_home="$HOME"
local_host="$(uname -n)"
labels="backup_d backup_f"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='$user_home/Cloud' \
        --exclude='$user_home/Desktop' \
        --exclude='$user_home/Music' \
        --exclude='$user_home/Public' \
        --exclude='$user_home/Templates' \
        --exclude='$user_home/Videos' \
        --exclude='/dev' \
        --exclude='/lost+found' \
        --exclude='/mnt' \
        --exclude='/proc' \
        --exclude='/run' \
        --exclude='/sys' \
        --exclude='/tmp'"

# helper functions
backup_host() {
    dest="$mnt/hosts/$1"

    # set location and rsync options by hostname
    case "$1" in
        "$local_host")
            src="/"
            options="$rsync_options"
            ;;
        m625q)
            src="$1:/"
            options="$rsync_options \
                --exclude='/srv/http/download' \
                --rsync-path='$auth rsync'"
            ;;
        t14)
            src="$1:/"
            options="$rsync_options \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$src" "$dest"
    $auth mkdir -p "$dest"

    ([ "$1" = "$local_host" ] || ssh -q "$1" exit) \
        && eval "$auth rsync $options $src $dest" \
        && return

    printf "connect to %s failed, please check if ssh is enabled!\n" \
        "$1"
}

# main
backup() {
    for label in $labels; do
        unset mnt

        # mount
        [ -h "/dev/disk/by-label/$label" ] \
            && mnt="/mnt/$label" \
            && printf ":: create and mount backup folder %s\n" "$mnt" \
            && $auth mkdir -p "$mnt" \
            && $auth mount "/dev/disk/by-label/$label" "$mnt"

        # backup
        [ -d "$mnt" ] \
            && backup_host "$local_host" \
            && backup_host "m625q" \
            && backup_host "t14"

        # unmount
        [ -d "$mnt" ] \
            && printf "\n:: unmount and delete backup folder %s\n" "$mnt" \
            && $auth umount "$mnt" \
            && $auth find "$mnt" -empty -type d -delete \
            && return 0
    done
}

# main
backup \
    && exit 0

printf ":: please connect one of the following devices to backup to:\n"
for label in $labels; do
    printf "  -> %s\n" "$label"
done
