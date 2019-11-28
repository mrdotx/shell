#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofi_mount.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 13:56:25

# exit if rofi is running
pgrep -x rofi && exit

# create mount directory if not created
if [ ! -d "$HOME"/mount ]; then
    mkdir "$HOME"/mount
fi

# remote mount
remotemnt() {
    chosen=$(find "$HOME"/coding/hidden/mount/*.sh | cut -d / -f 7 | sed "s/.sh//g" | rofi -dmenu -i -p "")
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$chosen
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && "$HOME/coding/hidden/mount/$chosen.sh" "$mntpoint" && notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount Remote" "$chosen mounted to $mntpoint"
}

# usb mount
usbmnt() {
    chosen="$(lsblk -rpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4=="" || $2=="rom"&&$4=="" || $3=="1,4M"&&$4=="") printf "%s (%s)\n",$1,$3}' | rofi -dmenu -i -p "" | awk '{print $1}')"
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$(basename "$chosen")
    parttype="$(lsblk -no "fstype" "$chosen")"
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && case "$parttype" in
    "vfat") sudo -A mount -t vfat "$chosen" "$mntpoint" -o rw,umask=0000 && notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount $parttype USB" "$chosen mounted to $mntpoint" ;;
    *)
        sudo -A mount "$chosen" "$mntpoint" && notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount $parttype USB" "$chosen mounted to $mntpoint"
        user="$(whoami)"
        ug="$(groups | awk '{print $1}')"
        sudo -A chown "$user":"$ug" 741 "$mntpoint"
        ;;
    esac
}

# android mount
androidmnt() {
    chosen=$(simple-mtpfs -l 2>/dev/null | rofi -dmenu -i -p "" | cut -d : -f 1)
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$chosen
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && simple-mtpfs --device "$chosen" "$mntpoint" && notify-send -i "$HOME/coding/shell/icons/usb.png" "Mount Android" "$chosen mounted to $mntpoint"
}

# menu
case $(printf "%s\n" \
    "Remote Mount" \
    "USB Mount" \
    "Android Mount" | rofi -dmenu -i -p "") in
"Remote Mount") remotemnt ;;
"USB Mount") usbmnt ;;
"Android Mount") androidmnt ;;
esac
