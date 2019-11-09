#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/launch.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:13:11

case "$1" in

# desktop  1 {{{
terminal)
    wmctrl -s 0 && kitty >/dev/null 2>&1 &
    ;;
split-kitty)
    wmctrl -s 0 && kitty --session .config/kitty/tile.conf >/dev/null 2>&1 &
    ;;
ranger)
    wmctrl -s 0 && kitty ranger >/dev/null 2>&1 &
    ;;
# }}}

# desktop  2 {{{
web)
    wmctrl -s 1 && firefox-developer-edition >/dev/null 2>&1 &
    ;;
ftp)
    wmctrl -s 1 && filezilla >/dev/null 2>&1 &
    ;;
# }}}

# desktop  3 {{{
vsc)
    wmctrl -s 2 && code-oss >/dev/null 2>&1 &
    ;;
# }}}

# desktop  4 {{{
gimp)
    wmctrl -s 3 && gimp >/dev/null 2>&1 &
    ;;
inkscape)
    wmctrl -s 3 && inkscape >/dev/null 2>&1 &
    ;;
# }}}

# desktop  5 {{{
mail)
    wmctrl -s 4 && thunderbird >/dev/null 2>&1 &
    ;;
office)
    wmctrl -s 4 && libreoffice >/dev/null 2>&1 &
    ;;
keepass)
    wmctrl -s 4 && keepassxc >/dev/null 2>&1 &
    ;;
jameica)
    wmctrl -s 4 && jameica >/dev/null 2>&1 &
    ;;
# }}}

esac
