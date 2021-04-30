#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_usb.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-04-30T10:02:54+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="$EXEC_AS_USER"
backup_name=$(hostname)
mount_point="/mnt/$backup_name"
usb_device="/dev/disk/by-uuid/2bdffcfb-b365-4321-a64b-5ffce2f1c211"
remote_location="$mount_point/backup/$backup_name"

printf ":: create installed packages list\n"
paru -Qq > "$XDG_CONFIG_HOME/paru/installed_packages.txt"
printf ":: create explicit installed packages list\n"
paru -Qqe > "$XDG_CONFIG_HOME/paru/explicit_installed_packages.txt"
# to reinstall the packages:
# paru -S --needed - < "$XDG_CONFIG_HOME/paru/explicit_installed_packages.txt"

printf "\n:: create and mount folder for usb-disk\n"
$auth mkdir -p "$mount_point"
$auth mount "$usb_device" "$mount_point"

printf "\n:: create folder and backup / to USB-Disk\n"
$auth mkdir -p "$remote_location"
# for testing rsync option --dry-run
$auth rsync -aAXvh --delete \
    --exclude="/dev/*" \
    --exclude="/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / "$remote_location"

printf "\n:: unmount and delete folder\n"
$auth umount "$mount_point"
$auth find "$mount_point" -empty -type d -delete
