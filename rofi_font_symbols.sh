#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofi_font_symbols.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-29 19:47:56

chosen=$(grep -v "#" ~/.local/share/font-symbols | rofi -monitor -2 -theme klassiker-vertical -dmenu -i -l 10)

[ "$chosen" != "" ] || exit

# copy symbol to clipboard
c=$(echo "$chosen" | sed "s/ .*//")
echo "$c" | tr -d '\n' | xclip -selection clipboard
# copy code to primary
s=$(echo "$chosen" | sed "s/.*; //" | awk '{print $1}')
echo "$s" | tr -d '\n' | xclip

notify-send -i "$HOME/coding/shell/icons/clipboard.png" "Clipboard" "Copied to clipboard\t: $c\nCopied to primary\t: $s" &
