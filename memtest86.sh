#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/memtest86.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-05-13T15:15:41+0200

[ ! "$(id -u)" = 0 ] \
    && printf "this script needs root privileges to run\n" \
    && exit 1

# config
whats_new="https://www.memtest86.com/whats-new.html"
download="https://www.memtest86.com/downloads/memtest86-usb.zip"
destination="/boot/EFI/memtest86"
tmp_directory=$(mktemp -t -d memtest86.XXXXXX)

# download
wget -O "$tmp_directory/whats-new.html" "$whats_new"
wget -O "$tmp_directory/memtest86-usb.zip" "$download"
unzip "$tmp_directory/memtest86-usb.zip" -d "$tmp_directory/memtest86-usb"

# mount
start_sector=$(fdisk -lu "$tmp_directory/memtest86-usb/memtest86-usb.img" \
    | grep "memtest86-usb.img2" \
    | cut -d ' ' -f2)
offset=$((start_sector * 512))
mkdir "$tmp_directory/mount"
mount -o loop,offset=$offset \
    "$tmp_directory/memtest86-usb/memtest86-usb.img" \
    "$tmp_directory/mount"

# process files
rm -rf "$destination"
cp -r "$tmp_directory"/mount/EFI/BOOT "$tmp_directory"/memtest86
grep -m1 ">Version" "$tmp_directory/whats-new.html" \
        | sed -e 's/^[ \t]*//' \
        | cut -d ' ' -f4 > "$tmp_directory/memtest86/version"
mv "$tmp_directory"/memtest86 "$destination"

# clean up
umount "$tmp_directory/mount"
rm -rf "$tmp_directory"

# rewrite uefi
efistub.sh
