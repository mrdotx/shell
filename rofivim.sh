#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofivim.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-17 16:20:03

# exit if rofi is running
pgrep -x rofi && exit

# menu for vim shortcuts
case $(printf "%s\n" \
    "nvim" \
    "notes" \
    "middlefinger-streetwear.com" \
    "prinzipal-kreuzberg.com" \
    "klassiker.online.de" \
    "marcusreith.de" \
    "pi" \
    "pi2" \
    "firetv" \
    "firetv4k" \
    "p9" \
    "m3" | rofi -monitor primary -dmenu -i -p "") in
"nvim") $TERMINAL -e vim -c "Lexplore" ;;
"notes") $TERMINAL -e vim "$HOME"/coding/hidden/notes/index.md ;;
"middlefinger-streetwear.com") $TERMINAL -e vim scp://middlefinger/ -c "Lexplore" ;;
"prinzipal-kreuzberg.com") $TERMINAL -e vim scp://prinzipal/ -c "Lexplore" ;;
"klassiker.online.de") $TERMINAL -e vim ftp://klassiker.online.de/ -c "Lexplore" ;;
"marcusreith.de") $TERMINAL -e vim ftp://marcusreith.de/ -c "Lexplore" ;;
"pi") $TERMINAL -e vim scp://hermes/ -c "Lexplore" ;;
"pi2") $TERMINAL -e vim scp://prometheus/ -c "Lexplore" ;;
"firetv") $TERMINAL -e vim scp://firetv/ -c "Lexplore" ;;
"firetv4k") $TERMINAL -e vim scp://firetv4k/ -c "Lexplore" ;;
"p9") $TERMINAL -e vim scp://p9/ -c "Lexplore" ;;
"m3") $TERMINAL -e vim scp://m3/ -c "Lexplore" ;;
*) $TERMINAL -e vim ;;
esac
