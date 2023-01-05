#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-01-05T18:56:16+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
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
        pi)
            remote="$1:/"
            options="$rsync_options \
                --exclude='/home/alarm/backup' \
                --rsync-path='$auth rsync'"
            ;;
        pi2)
            remote="$1:/"
            options="$rsync_options \
                --exclude='/home/alarm/backup' \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$remote" "$local"
    $auth mkdir -p "$local"
    eval "$auth rsync $options $remote $local"
}

backup_to_ssh() {
    # set remote location and rsync options by hostname
    case "$local_hostname" in
        m75q)
            remote="pi2:/home/alarm/backup/$local_hostname/"
            options="$rsync_options \
                --exclude='/home/klassiker/.local/share/cloud' \
                --exclude='/home/klassiker/.local/vms'"
            ;;
        mi)
            remote="pi:/home/alarm/backup/$local_hostname/"
            options="$rsync_options \
                --exclude='/home/klassiker/.local/share/cloud' \
                --exclude='/home/klassiker/.local/vms'"
            ;;
        pi)
            remote="pi2:/home/alarm/backup/$local_hostname/"
            options="$rsync_options \
                --exclude='/home/alarm/backup'"
            ;;
        pi2)
            remote="pi:/home/alarm/backup/$local_hostname/"
            options="$rsync_options \
                --exclude='/home/alarm/backup'"
            ;;
    esac

    printf "\n:: backup / to %s\n" "$remote"
    eval "$auth rsync $options / $remote"
}

# main
for device in $usb_devices; do
    [ -h "$device" ] \
        && mount_usb "$device" \
        && backup_to_usb \
        && backup_from_ssh "pi" \
        && backup_from_ssh "pi2" \
        && unmount_usb \
        && exit 0
done

backup_to_ssh
