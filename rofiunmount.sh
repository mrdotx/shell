#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofiunmount.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:33:44

pgrep -x rofi && exit

# remote unmount {{{
remoteumt() {
    if grep -E "$HOME"/mount/.*fuse /etc/mtab; then
        chosen=$(awk '/\/mount\/.*fuse/ {print $2}' /etc/mtab | sort | rofi -dmenu -i -p "")
        [ -z "$chosen" ] && exit
        fusermount -u "$chosen" && if [ -d "$chosen" ]; then rmdir "$chosen"; fi && notify-send "Unmount Remote" "$chosen unmounted."
    else
        exit
    fi
}
# }}}

# usb unmount {{{
usbumt() {
    mounts=$(lsblk -nrpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4!~/\/boot|\/home$|SWAP/&&length($4)>1 || $2=="rom"&&length($4)>1 || $3=="1,4M"&&length($4)>1) printf "%s (%s)\n",$4,$3}')
    [ -z "$mounts" ] && exit
    chosen=$(echo "$mounts" | rofi -dmenu -i -p "" | awk '{print $1}')
    [ -z "$chosen" ] && exit
    sudo -A umount "$chosen" && if [ -d "$chosen" ]; then rmdir "$chosen"; fi && notify-send "Unmount USB" "$chosen unmounted."
}
# }}}

# android unmount {{{
androidumt() {
    if grep simple-mtpfs /etc/mtab; then
        chosen=$(awk '/simple-mtpfs/ {print $2}' /etc/mtab | sort | rofi -dmenu -i -p "")
        [ -z "$chosen" ] && exit
        fusermount -u "$chosen" && if [ -d "$chosen" ]; then rmdir "$chosen"; fi && notify-send "Unmount Android" "$chosen unmounted."
    else
        exit
    fi
}
# }}}

# dvd eject {{{
dvdeject() {
    mounts=$(lsblk -nrpo "name,type,size,mountpoint" | awk '$2=="rom"{printf "%s (%s)\n",$1,$3}')
    [ -z "$mounts" ] && exit
    chosen=$(echo "$mounts" | rofi -dmenu -i -p "" | awk '{print $1}')
    [ -z "$chosen" ] && exit
    sudo -A eject "$chosen" && notify-send "Eject DVD" "$chosen ejected."
}
# }}}

# menu {{{
case $(printf "Remote Unmount\\nUSB Unmount\\nAndroid Unmount\\nDVD Eject" | rofi -dmenu -i -p "") in
    "Remote Unmount") remoteumt ;;
    "USB Unmount") usbumt ;;
    "Android Unmount") androidumt ;;
    "DVD Eject") dvdeject ;;
esac
# }}}
