#!/bin/sh

# path:       ~/coding/shell/backup_usb.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-03 16:04:14

backup_name="morpheus"
mount_point="/mnt/$backup_name"
usb_device="/dev/sdb1"
local_home="/home/klassiker"
remote_location="$mount_point/backup/$backup_name"

# create and mount folder for usb-disk
sudo mkdir -p $mount_point
sudo mount $usb_device $mount_point

# create folder and backup / to USB-Disk (for testing rsync option --dry-run)
sudo mkdir -p $remote_location
sudo rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/proc/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" \
    --exclude="/run/*" \
    --exclude="$local_home/mount/*" \
    --exclude="$local_home/VM/*" \
    --exclude="/mnt/*" \
    --exclude="/media/*" \
    --exclude="/lost+found" \
    --exclude="/swapfile" / $remote_location

# unmount and delete folder
sudo umount $mount_point
sudo find $mount_point -empty -type d -delete
