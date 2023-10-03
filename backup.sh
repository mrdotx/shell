#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-10-02T17:55:32+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
user_home="$HOME"

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
backup_label="/dev/disk/by-label/backup"
local_hostname="$(hostname)"

# helper functions
mount_usb() {
    mnt="/mnt/$local_hostname"

    printf ":: create and mount backup folder %s\n" "$mnt"
    $auth mkdir -p "$mnt"
    $auth mount "$1" "$mnt"
}

unmount_usb() {
    mnt="/mnt/$local_hostname"

    printf "\n:: unmount and delete backup folder %s\n" "$mnt"
    $auth umount "$mnt"
    $auth find "$mnt" -empty -type d -delete
}

backup_local() {
    dest="/mnt/$local_hostname/hosts/$local_hostname"

    printf "\n:: create folder and backup / to %s\n" "$dest"
    $auth mkdir -p "$dest"
    eval "$auth rsync $rsync_options / $dest"
}

backup_remote() {
    dest="/mnt/$local_hostname/hosts/$1"

    # set remote location and rsync options by hostname
    case "$1" in
        m625q)
            src="$1:/"
            options="$rsync_options \
                --exclude='/srv/http/download' \
                --rsync-path='$auth rsync'"
            ;;
        mi)
            src="$1:/"
            options="$rsync_options \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$src" "$dest"
    $auth mkdir -p "$dest"
    ssh -q "$1" exit
    case $? in
        0)
            eval "$auth rsync $options $src $dest"
            ;;
        *)
            printf "connect to %s failed, please check if ssh is enabled!\n" \
                "$1"
            ;;
    esac
}

# main
[ -h "$backup_label" ] \
    && mount_usb "$backup_label" \
    && backup_local \
    && backup_remote "m625q" \
    && backup_remote "mi" \
    && unmount_usb \
    && exit 0

printf "please connect the following device to backup to:\n%s\n" \
    "$backup_label"
