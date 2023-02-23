#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-02-23T16:56:58+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='/home/klassiker/Downloads' \
        --exclude='/home/klassiker/Music' \
        --exclude='/home/klassiker/Public' \
        --exclude='/home/klassiker/Templates' \
        --exclude='/dev' \
        --exclude='/lost+found' \
        --exclude='/mnt' \
        --exclude='/proc' \
        --exclude='/run' \
        --exclude='/sys' \
        --exclude='/tmp'"
usb_devices="
    /dev/disk/by-uuid/4ceb144a-db56-4211-96f6-147e1beab18a
    /dev/disk/by-uuid/2bdffcfb-b365-4321-a64b-5ffce2f1c211
" # 4ceb -> 3.5, 2bdf -> 2.5
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
    remote="/mnt/$local_hostname/Backup/$local_hostname"

    printf "\n:: create folder and backup / to %s\n" "$remote"
    $auth mkdir -p "$remote"
    eval "$auth rsync $rsync_options / $remote"
}

backup_from_ssh() {
    local="/mnt/$local_hostname/Backup/$1"

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
for device in $usb_devices; do
    [ -h "$device" ] \
        && mount_usb "$device" \
        && backup_to_usb \
        && backup_from_ssh "m625q" \
        && unmount_usb \
        && exit 0
done

printf "please connect one of the following devices to backup to:%s" \
    "$usb_devices"
