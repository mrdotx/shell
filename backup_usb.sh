#!/bin/sh

# path:       ~/projects/shell/backup_usb.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:14:11+0100

backup_name="morpheus"
mount_point="/mnt/$backup_name"
usb_device="/dev/disk/by-uuid/2bdffcfb-b365-4321-a64b-5ffce2f1c211"
remote_location="$mount_point/backup/$backup_name"

# create and mount folder for usb-disk
sudo mkdir -p $mount_point
sudo mount $usb_device $mount_point

# create folder and backup / to USB-Disk (for testing rsync option --dry-run)
sudo mkdir -p $remote_location
sudo rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/lost+found" \
    --exclude="/media/disk1/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / $remote_location

# unmount and delete folder
sudo umount $mount_point
sudo find $mount_point -empty -type d -delete
