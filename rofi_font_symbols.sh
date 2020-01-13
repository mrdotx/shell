#!/bin/sh

# path:       ~/projects/shell/rofi_font_symbols.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:16:20+0100

chosen=$(< ~/.local/share/font-symbols rofi -monitor -2 -theme klassiker-vertical -dmenu -i -p "Which symbol to copy?" -l 10)

[ -n "$chosen" ] || exit

# copy symbol to clipboard
clip=$(echo "$chosen" | sed "s/ .*//")
echo "$clip" | tr -d '\n' | xsel -b
# copy code to primary
pri=$(echo "$chosen" | sed "s/.*; //" | awk '{print $1}')
echo "$pri" | tr -d '\n' | xsel

notify-send -i "$HOME/projects/shell/icons/clipboard.png" "clipboard" "Copied to clipboard\t: $clip\nCopied to primary\t: $pri"
