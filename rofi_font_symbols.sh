#!/bin/sh

# path:       ~/coding/shell/rofi_font_symbols.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-03 18:41:27

chosen=$(< ~/.local/share/font-symbols rofi -monitor -2 -theme klassiker-vertical -dmenu -i -p "Which symbol to copy?" -l 10)

[ "$chosen" != "" ] || exit

# copy symbol to clipboard
clipboard=$(echo "$chosen" | sed "s/ .*//")
echo "$clipboard" | tr -d '\n' | xclip -selection clipboard
# copy code to primary
primary=$(echo "$chosen" | sed "s/.*; //" | awk '{print $1}')
echo "$primary" | tr -d '\n' | xclip

notify-send -i "$HOME/coding/shell/icons/clipboard.png" "Clipboard" "Copied to clipboard\t: $clipboard\nCopied to primary\t: $primary" &
