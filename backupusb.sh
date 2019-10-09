#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/backupusb.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# config {{{
backupname="morpheus"
mountpoint="/mnt/$backupnname"
usbdevice="/dev/sdb1"
localhome="/home/klassiker"
remotelocation="$mountpoint/backup/$backupname"
# }}}

# create and mount folder for usb-disk {{{
sudo mkdir -p $mountpoint
sudo mount $usbdevice $mountpoint
# }}}

# create folder and backup / to USB-Disk (for testing rsync option --dry-run) {{{
sudo mkdir -p $remotelocation
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","$localhome/mount/*","$localhome/vm/*","/mnt/*","/media/*","/lost+found"} / $remotelocation
# }}}

# unmount and delete folder {{{
sudo umount $mountpoint
sudo find $mountpoint -mindepth 1 -empty -type d -delete
# }}}
