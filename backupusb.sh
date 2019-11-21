#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/backupusb.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-21 01:34:44

backupname="morpheus"
mountpoint="/mnt/$backupname"
usbdevice="/dev/sdb1"
localhome="/home/klassiker"
remotelocation="$mountpoint/backup/$backupname"

# create and mount folder for usb-disk
sudo mkdir -p $mountpoint
sudo mount $usbdevice $mountpoint

# create folder and backup / to USB-Disk (for testing rsync option --dry-run)
sudo mkdir -p $remotelocation
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","$localhome/mount/*","$localhome/VM/*","/mnt/*","/media/*","/lost+found","/swapfile"} / $remotelocation

# unmount and delete folder
sudo umount $mountpoint
sudo find $mountpoint -mindepth 1 -empty -type d -delete
