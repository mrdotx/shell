#!/bin/sh

# path:       ~/projects/shell/rofi_mount.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-03 23:22:28

# exit if rofi is running
pgrep -x rofi && exit

# rclone mount
rclone_mnt() {
    rcl() {
        rcl_host=$1
        rcl_mnt=/media/$rcl_host
        rmt_dir=$2
        if [ ! -d "$rcl_mnt" ]; then mkdir "$rcl_mnt"; fi \
            && rclone mount "$rcl_host:$rmt_dir" "$rcl_mnt" \
            & notify-send -i "$HOME/projects/shell/icons/usb.png" "RClone Mount" "$rcl_host mounted to $rcl_mnt"
        }

    case $(printf "%s\n" \
        "dropbox" \
        "firetv" \
        "firetv4k" \
        "gmx" \
        "googledrive" \
        "klassiker" \
        "m3" \
        "marcus" \
        "middlefinger" \
        "p9" \
        "pi" \
        "pi2" \
        "prinzipal" \
        "web.de" | rofi -monitor -1 -dmenu -i -p "") in
        "dropbox") rcl "dropbox" "/" ;;
        "firetv") rcl "firetv" "/storage/emulated/0" ;;
        "firetv4k") rcl "firetv4k" "/storage/emulated/0" ;;
        "gmx") rcl "gmx" "/" ;;
        "googledrive") rcl "googledrive" "/" ;;
        "klassiker") rcl "klassiker" "/" ;;
        "m3") rcl "m3" "/storage/7EB3-34D3" ;;
        "marcus") rcl "marcus" "/" ;;
        "middlefinger") rcl "middlefinger" "/" ;;
        "p9") rcl "p9" "/storage/1B0C-F276" ;;
        "pi") rcl "pi" "/home/alarm" ;;
        "pi2") rcl "pi2" "/home/alarm" ;;
        "prinzipal") rcl "prinzipal" "/" ;;
        "web.de") rcl "webde" "/" ;;
    esac
}

# usb mount
usb_mnt() {
    chosen="$(lsblk -rpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4=="" || $2=="rom"&&$4=="" || $3=="1,4M"&&$4=="") printf "%s (%s)\n",$1,$3}' | rofi -monitor -1 -dmenu -i -p "" | awk '{print $1}')"
    [ -z "$chosen" ] && exit
    mnt_point="/media/$(basename "$chosen")"
    part_typ="$(lsblk -no "fstype" "$chosen")"
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi && case "$part_typ" in
    "vfat") sudo -A mount -t vfat "$chosen" "$mnt_point" -o rw,umask=0000 \
        && notify-send -i "$HOME/projects/shell/icons/usb.png" "USB Mount $part_typ" "$chosen mounted to $mnt_point" ;;
    *)
        sudo -A mount "$chosen" "$mnt_point" \
            && notify-send -i "$HOME/projects/shell/icons/usb.png" "USB Mount $part_typ" "$chosen mounted to $mnt_point"
        user="$(whoami)"
        ug="$(groups | awk '{print $1}')"
        sudo -A chown "$user":"$ug" 741 "$mnt_point"
        ;;
    esac
}

# iso mount
iso_mnt() {
    chosen=$(find /media/disk1/downloads -type f -iname "*.iso" | cut -d / -f 5 | sed "s/.iso//g" | sort | rofi -monitor -1 -dmenu -i -p "")
    [ -z "$chosen" ] && exit
    mnt_point="/media/$chosen"
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi \
        && sudo mount -o loop "/media/disk1/downloads/$chosen.iso" "$mnt_point" \
        && notify-send -i "$HOME/projects/shell/icons/usb.png" "ISO Mount" "$chosen mounted to $mnt_point"
}
# android mount
android_mnt() {
    chosen=$(simple-mtpfs -l 2>/dev/null | rofi -monitor -1 -dmenu -i -p "" | cut -d : -f 1)
    [ -z "$chosen" ] && exit
    mnt_point="/media/$chosen"
    if [ ! -d "$mnt_point" ]; then mkdir "$mnt_point"; fi \
        && simple-mtpfs --device "$chosen" "$mnt_point" \
        && notify-send -i "$HOME/projects/shell/icons/usb.png" "Android Mount" "$chosen mounted to $mnt_point"
}

# menu
case $(printf "%s\n" \
    "RClone Mount" \
    "USB Mount" \
    "ISO Mount" \
    "Android Mount" | rofi -monitor -1 -dmenu -i -p "") in
        "RClone Mount") rclone_mnt ;;
        "USB Mount") usb_mnt ;;
        "ISO Mount") iso_mnt ;;
        "Android Mount") android_mnt ;;
esac
