#!/bin/sh

# path:       ~/projects/shell/rofi_unmount.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:59:24

# exit if rofi is running
pgrep -x rofi && exit

# remote unmount
remote_unmnt() {
    if grep -E "$HOME/mount/.*fuse" /etc/mtab; then
        chosen=$(awk '/\/mount\/.*fuse/ {print $2}' /etc/mtab | sort | rofi -monitor -1 -dmenu -i -p "")
        [ -z "$chosen" ] && exit
        fusermount -u "$chosen" && \
            if [ -d "$chosen" ]; then rmdir "$chosen"; fi && \
                notify-send -i "$HOME/projects/shell/icons/usb.png" "Unmount Remote" "$chosen unmounted"
    else
        exit
    fi
}

# usb unmount
usb_unmnt() {
    mounts=$(lsblk -nrpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4!~/\/boot|\/home\/klassiker\/mount\/data|\/home$|SWAP/&&length($4)>1 || $2=="rom"&&length($4)>1 || $3=="1,4M"&&length($4)>1) printf "%s (%s)\n",$4,$3}')
    [ -z "$mounts" ] && exit
    chosen=$(echo "$mounts" | rofi -monitor -1 -dmenu -i -p "" | awk '{print $1}')
    [ -z "$chosen" ] && exit
    sudo -A umount "$chosen" && \
        if [ -d "$chosen" ]; then rmdir "$chosen"; fi && \
            notify-send -i "$HOME/projects/shell/icons/usb.png" "Unmount USB" "$chosen unmounted"
}

# android unmount
android_unmnt() {
    if grep simple-mtpfs /etc/mtab; then
        chosen=$(awk '/simple-mtpfs/ {print $2}' /etc/mtab | sort | rofi -monitor -1 -dmenu -i -p "")
        [ -z "$chosen" ] && exit
        fusermount -u "$chosen" && \
            if [ -d "$chosen" ]; then rmdir "$chosen"; fi && \
                notify-send -i "$HOME/projects/shell/icons/usb.png" "Unmount Android" "$chosen unmounted"
    else
        exit
    fi
}

# dvd eject
dvd_eject() {
    mounts=$(lsblk -nrpo "name,type,size,mountpoint" | awk '$2=="rom"{printf "%s (%s)\n",$1,$3}')
    [ -z "$mounts" ] && exit
    chosen=$(echo "$mounts" | rofi -monitor -1 -dmenu -i -p "" | awk '{print $1}')
    [ -z "$chosen" ] && exit
    sudo -A eject "$chosen" && \
        notify-send -i "$HOME/projects/shell/icons/usb.png" "Eject DVD" "$chosen ejected"
}

# menu
case $(printf "%s\n" \
    "Remote Unmount" \
    "USB Unmount" \
    "Android Unmount" \
    "DVD Eject" | rofi -monitor -1 -dmenu -i -p "") in
        "Remote Unmount") remote_unmnt ;;
        "USB Unmount") usb_unmnt ;;
        "Android Unmount") android_unmnt ;;
        "DVD Eject") dvd_eject ;;
esac
