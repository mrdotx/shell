#!/bin/sh

# path:       ~/coding/shell/rofi_mount.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 18:01:21

# exit if rofi is running
pgrep -x rofi && exit

# create mount directory if not created
if [ ! -d "$HOME/mount" ]; then
    mkdir "$HOME/mount"
fi

# remote mount
remote_mnt() {
    chosen=$(find "$HOME/coding/hidden/mount/" -iname "*.sh" | cut -d / -f 7 | sed "s/.sh//g" | sort | rofi -dmenu -i -p "")
    [ -z "$chosen" ] && exit
    mnt_point="$HOME/mount/$chosen"
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi && \
        "$HOME/coding/hidden/mount/$chosen.sh" "$mnt_point" && \
        notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount Remote" "$chosen mounted to $mnt_point"
}

# usb mount
usb_mnt() {
    chosen="$(lsblk -rpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4=="" || $2=="rom"&&$4=="" || $3=="1,4M"&&$4=="") printf "%s (%s)\n",$1,$3}' | rofi -dmenu -i -p "" | awk '{print $1}')"
    [ -z "$chosen" ] && exit
    mnt_point="$HOME/mount/$(basename "$chosen")"
    part_typ="$(lsblk -no "fstype" "$chosen")"
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi && case "$part_typ" in
    "vfat") sudo -A mount -t vfat "$chosen" "$mnt_point" -o rw,umask=0000 && \
        notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount $part_typ USB" "$chosen mounted to $mnt_point" ;;
    *)
        sudo -A mount "$chosen" "$mnt_point" && \
            notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount $part_typ USB" "$chosen mounted to $mnt_point"
        user="$(whoami)"
        ug="$(groups | awk '{print $1}')"
        sudo -A chown "$user":"$ug" 741 "$mnt_point"
        ;;
    esac
}

# android mount
android_mnt() {
    chosen=$(simple-mtpfs -l 2>/dev/null | rofi -dmenu -i -p "" | cut -d : -f 1)
    [ -z "$chosen" ] && exit
    mnt_point="$HOME"/mount/$chosen
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi && \
        simple-mtpfs --device "$chosen" "$mnt_point" && \
        notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount Android" "$chosen mounted to $mnt_point"
}

# menu
case $(printf "%s\n" \
    "Remote Mount" \
    "USB Mount" \
    "Android Mount" | rofi -dmenu -i -p "") in
        "Remote Mount") remote_mnt ;;
        "USB Mount") usb_mnt ;;
        "Android Mount") android_mnt ;;
esac
