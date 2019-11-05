#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofivim.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-05 16:37:29

pgrep -x rofi && exit

# menu {{{
case $(printf "nvim\\nnotes\\nmiddlefinger-streetwear.com\\nprinzipal-kreuzberg.com\\nklassiker.online.de\\nmarcusreith.de" | rofi -dmenu -i -p "") in
    "nvim") $TERMINAL -e vim -c "Lexplore" ;;
    "notes") $TERMINAL -e vim $HOME/coding/hidden/notes/index.md ;;
    "middlefinger-streetwear.com") $TERMINAL -e vim scp://middlefinger/ -c "Lexplore" ;;
    "prinzipal-kreuzberg.com") $TERMINAL -e vim scp://prinzipal/ -c "Lexplore" ;;
    "klassiker.online.de") $TERMINAL -e vim ftp://klassiker.online.de/ -c "Lexplore" ;;
    "marcusreith.de") $TERMINAL -e vim ftp://marcusreith.de/ -c "Lexplore" ;;
    *) $TERMINAL -e vim ;;
esac
# }}}
