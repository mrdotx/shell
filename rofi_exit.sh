#!/bin/sh

# path:       ~/projects/shell/rofi_exit.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-24 12:08:40

# exit if rofi is running
pgrep -x rofi && exit

# menu for knockput script
case $(printf "%s\n" \
    "shutdown" \
    "reboot" \
    "logout" \
    "switch user" \
    "suspend blur" \
    "suspend simple" \
    "lock blur" \
    "lock simple" | rofi -monitor -1 -lines 8 -theme klassiker-center -dmenu -i -p "") in
"shutdown") knockout.sh -shutdown ;;
"reboot") knockout.sh -reboot ;;
"logout") knockout.sh -logout ;;
"switch user") knockout.sh -switch ;;
"suspend blur") knockout.sh -suspend blur ;;
"suspend simple") knockout.sh -suspend simple ;;
"lock blur") knockout.sh -lock blur ;;
"lock simple") knockout.sh -lock simple ;;
esac
