#!/bin/sh

# path:       ~/projects/shell/rofi_exit.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-30 14:50:57

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
"shutdown") knockout.sh -shutdown ;;
"reboot") knockout.sh -reboot ;;
"logout") knockout.sh -logout ;;
"switch user") knockout.sh -switch ;;
"suspend") knockout.sh -suspend ;;
"suspend blur") knockout.sh -suspend blur ;;
"suspend simple") knockout.sh -suspend simple ;;
"lock blur") knockout.sh -lock blur ;;
"lock simple") knockout.sh -lock simple ;;
esac
