#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-09-03T16:08:33+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# config (for testing use rsync option --dry-run)
rsync_options="-aAXvh --delete \
        --exclude='/dev/*' \
        --exclude='/lost+found' \
        --exclude='/mnt/*' \
        --exclude='/proc/*' \
        --exclude='/run/*' \
        --exclude='/sys/*' \
        --exclude='/tmp/*'"
usb_device="/dev/disk/by-uuid/2bdffcfb-b365-4321-a64b-5ffce2f1c211"

backup_ssh() {
    # set remote location and rsync options by hostname
    case "$1" in
        m75q)
            remote_location="pi2:/home/alarm/backup/$1/"
            rsync_options="$rsync_options \
                --exclude='/srv/*'"
            ;;
        mi)
            remote_location="pi:/home/alarm/backup/$1/"
            rsync_options="$rsync_options \
                --exclude='/srv/*'"
            ;;
        pi)
            remote_location="pi2:/home/alarm/backup/$1/"
            rsync_options="$rsync_options \
                --exclude='/home/alarm/backup/*' \
                --exclude='/srv/http/download/*'"
            ;;
        pi2)
            remote_location="pi:/home/alarm/backup/$1/"
            rsync_options="$rsync_options \
                --exclude='/home/alarm/backup/*' \
                --exclude='/srv/http/download/*'"
            ;;
    esac

    printf "\n:: backup / to %s\n" "$remote_location"
    eval "$auth rsync $rsync_options / $remote_location"
}

backup_usb() {
    mount_point="/mnt/$1"
    remote_location="$mount_point/backup/$1"

    printf "\n:: create and mount backup folder %s\n" "$mount_point"
    $auth mkdir -p "$mount_point"
    $auth mount "$usb_device" "$mount_point"

    printf "\n:: create folder and backup / to %s\n" "$remote_location"
    $auth mkdir -p "$remote_location"
    eval "$auth rsync $rsync_options / $remote_location"

    printf "\n:: unmount and delete folder %s\n" "$mount_point"
    $auth umount "$mount_point"
    $auth find "$mount_point" -empty -type d -delete
}

if [ -h "$usb_device" ]; then
    backup_usb "$(hostname)"
else
    backup_ssh "$(hostname)"
fi
