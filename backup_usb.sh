#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/backup_usb.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-05T14:03:56+0100

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas"
backup_name="morpheus"
mount_point="/mnt/$backup_name"
usb_device="/dev/disk/by-uuid/2bdffcfb-b365-4321-a64b-5ffce2f1c211"
remote_location="$mount_point/backup/$backup_name"

printf ":: create installed packages list\n"
paru -Qqe > "$XDG_CONFIG_HOME/paru/installed_packages.txt"
# to reinstall the packages: paru -S --needed - < "$XDG_CONFIG_HOME/paru/installed_packages.txt"

printf "\n:: create and mount folder for usb-disk\n"
$auth mkdir -p $mount_point
$auth mount $usb_device $mount_point

printf "\n:: create folder and backup / to USB-Disk\n"
# for testing rsync option --dry-run
$auth mkdir -p $remote_location
$auth rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / $remote_location

printf "\n:: unmount and delete folder\n"
$auth umount $mount_point
$auth find $mount_point -empty -type d -delete
