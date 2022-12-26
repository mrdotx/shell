#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/memtest86.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-12-26T10:39:37+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# config
whats_new="https://www.memtest86.com/whats-new.html"
download="https://www.memtest86.com/downloads/memtest86-usb.zip"

destination="/boot/memtest86"
version_file="$destination/version"

tmp_directory=$(mktemp -t -d memtest86.XXXXXX)

zip_file="$tmp_directory/memtest86-usb.zip"
zip_destination="$tmp_directory/memtest86-usb"
mount_destination="$tmp_directory/mount"
image="memtest86-usb.img"

# functions
check_root() {
    [ "$(id -u)" -ne 0 ] \
        && printf "this script needs root privileges to run\n" \
        && exit 1
}

get_versions() {
    printf "==> download %s\n" "$whats_new"
    curl -o \
        "$tmp_directory/whats-new.html" \
        "$whats_new"

    printf "==> version comparison\n"
    [ -f "$version_file" ] \
        && version="$(cat $version_file)"
    printf "  -> version installed: %s\n" "$version"

    version="$( \
        grep -m1 ">Version" "$tmp_directory/whats-new.html" \
            | sed -e 's/^[ \t]*//' \
            | cut -d ' ' -f4 \
        )"
    printf "  -> version available: %s\n" "$version"
}

update_memtest86() {
    printf "==> download %s\n" "$download"
    curl -o \
        "$zip_file" \
        "$download"

    printf "==> unzip %s\n" "$zip_file"
    unzip -q \
        "$zip_file" \
        -d "$zip_destination"

    printf "==> mount %s\n" "$image"
    start_sector=$( \
        fdisk -lu "$zip_destination/$image" \
            | grep "${image}2" \
            | cut -d ' ' -f2 \
        )
    offset=$((start_sector * 512))
    mkdir "$mount_destination"
    mount -o loop,offset=$offset \
        "$zip_destination/$image" \
        "$mount_destination"

    printf "==> process files\n"
    printf "  -> remove %s\n" "$destination"
    rm -rf "$destination"
    printf "  -> copy %s/mount/EFI/BOOT to %s/memtest86\n" \
        "$tmp_directory" \
        "$tmp_directory"
    cp -r \
        "$tmp_directory"/mount/EFI/BOOT \
        "$tmp_directory"/memtest86
    printf "  -> write version %s to %s/memtest86/version\n" \
        "$version" \
        "$tmp_directory"
    printf "%s\n" "$version" > "$tmp_directory/memtest86/version"
    printf "  -> move %s/memtest86 to %s\n" \
        "$tmp_directory" \
        "$destination"
    mv \
        "$tmp_directory"/memtest86 \
        "$destination"

    printf "==> unmount %s\n" "$image"
    umount "$mount_destination"
}

# main
check_root
get_versions
printf "  -> update [y]es/[N]o: " \
    && read -r update
case "$update" in
    y|Y|yes|Yes)
        update_memtest86
        ;;
esac
printf "==> clean up\n"
rm -rf "$tmp_directory"
