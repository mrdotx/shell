#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofivim.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-05 17:21:33

pgrep -x rofi && exit

# menu {{{
case $(printf "nvim\\nnotes\\nmiddlefinger-streetwear.com\\nprinzipal-kreuzberg.com\\nklassiker.online.de\\nmarcusreith.de\\npi\\npi2\\nfiretv\\nfiretv4k\\np9\\nm3" | rofi -dmenu -i -p "") in
    "nvim") $TERMINAL -e vim -c "Lexplore" ;;
    "notes") $TERMINAL -e vim $HOME/coding/hidden/notes/index.md ;;
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
# }}}
