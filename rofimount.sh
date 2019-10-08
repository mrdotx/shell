#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/rofimount.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

pgrep -x rofi && exit

# create mount director if not created {{{
if [ ! -d "$HOME"/mount ]; then
    mkdir "$HOME"/mount;
fi
# }}}

# remote mount {{{
remotemnt() {
    chosen=$(find "$HOME"/coding/secrets/mount/*.sh | cut -d / -f 7 | sed "s/.sh//g" | rofi -dmenu -i -p "")
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$chosen
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && "$HOME/coding/secrets/mount/$chosen.sh" "$mntpoint" && notify-send "Mount Remote" "$chosen mounted to "$mntpoint"."
}
# }}}

# usb mount {{{
usbmnt() {
    chosen="$(lsblk -rpo "name,type,size,mountpoint" | awk '{ if ($2=="part"&&$4=="" || $2=="rom"&&$4=="" || $3=="1,4M"&&$4=="") printf "%s (%s)\n",$1,$3}' | rofi -dmenu -i -p "" | awk '{print $1}')"
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$(basename $chosen)
    parttype="$(lsblk -no "fstype" "$chosen")"
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && case "$parttype" in
        "vfat") sudo -A mount -t vfat "$chosen" "$mntpoint" -o rw,umask=0000 && notify-send "Mount $parttype USB" "$chosen mounted to $mntpoint.";;
        *) sudo -A mount "$chosen" "$mntpoint" && notify-send "Mount $parttype USB" "$chosen mounted to $mntpoint."; user="$(whoami)"; ug="$(groups | awk '{print $1}')"; sudo -A chown "$user":"$ug" 741 "$mntpoint";;
    esac
}
# }}}

# android mount {{{
androidmnt() {
    chosen=$(simple-mtpfs -l 2>/dev/null | rofi -dmenu -i -p "" | cut -d : -f 1)
    [ -z "$chosen" ] && exit
    mntpoint="$HOME"/mount/$chosen
    if [ ! -d "$mntpoint" ]; then mkdir "$mntpoint"; fi && simple-mtpfs --device "$chosen" "$mntpoint" && notify-send "Mount Android" "$chosen mounted to $mntpoint."
}
# }}}

# menu {{{
case $(printf "Remote Mount\\nUSB Mount\\nAndroid Mount" | rofi -dmenu -i -p "") in
"Remote Mount") remotemnt ;;
"USB Mount") usbmnt ;;
"Android Mount") androidmnt ;;
esac
# }}}
