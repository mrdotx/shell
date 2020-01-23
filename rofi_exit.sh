#!/bin/sh

# path:       ~/projects/shell/rofi_exit.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-23T11:08:40+0100

# exit if rofi is running
pgrep -x rofi && exit

# menu for knockput script
case $(printf "%s\n" \
    "shutdown" \
    "reboot" \
    "logout" \
    "switch user" \
    "suspend" \
    "suspend blur" \
    "suspend simple" \
    "lock blur" \
    "lock simple" | rofi -monitor -1 -lines 9 -theme klassiker-center -dmenu -i -p "") in
    "shutdown") i3_knockout.sh -shutdown ;;
    "reboot") i3_knockout.sh -reboot ;;
    "logout") i3_knockout.sh -logout ;;
    "switch user") i3_knockout.sh -switch ;;
    "suspend") i3_knockout.sh -suspend ;;
    "suspend blur") i3_knockout.sh -suspend blur ;;
    "suspend simple") i3_knockout.sh -suspend simple ;;
    "lock blur") i3_knockout.sh -lock blur ;;
    "lock simple") i3_knockout.sh -lock simple ;;
esac
