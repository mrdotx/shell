#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-03-15T20:35:02+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='/home/klassiker/Desktop' \
        --exclude='/home/klassiker/Downloads' \
        --exclude='/home/klassiker/Music' \
        --exclude='/home/klassiker/Public' \
        --exclude='/home/klassiker/Templates' \
        --exclude='/home/klassiker/Videos' \
        --exclude='/dev' \
        --exclude='/lost+found' \
        --exclude='/mnt' \
        --exclude='/proc' \
        --exclude='/run' \
        --exclude='/sys' \
        --exclude='/tmp'"
usb_partlabel="/dev/disk/by-partlabel/backup"
local_hostname="$(hostname)"

# helper functions
mount_usb() {
    mount_point="/mnt/$local_hostname"

    printf ":: create and mount backup folder %s\n" "$mount_point"
    $auth mkdir -p "$mount_point"
    $auth mount "$1" "$mount_point"
}

unmount_usb() {
    mount_point="/mnt/$local_hostname"

    printf "\n:: unmount and delete folder %s\n" "$mount_point"
    $auth umount "$mount_point"
    $auth find "$mount_point" -empty -type d -delete
}

backup_to_usb() {
    remote="/mnt/$local_hostname/hosts/$local_hostname"

    printf "\n:: create folder and backup / to %s\n" "$remote"
    $auth mkdir -p "$remote"
    eval "$auth rsync $rsync_options / $remote"
}

backup_from_ssh() {
    local="/mnt/$local_hostname/hosts/$1"

    # set remote location and rsync options by hostname
    case "$1" in
        m625q)
            remote="$1:/"
            options="$rsync_options \
                --exclude='/srv/http/download' \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$remote" "$local"
    $auth mkdir -p "$local"
    eval "$auth rsync $options $remote $local"
}

# main
[ -h "$usb_partlabel" ] \
    && mount_usb "$usb_partlabel" \
    && backup_to_usb \
    && backup_from_ssh "m625q" \
    && unmount_usb \
    && exit 0

printf "please connect the following device to backup to: %s\n" \
    "$usb_partlabel"
