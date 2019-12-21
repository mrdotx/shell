#!/bin/sh

# path:       ~/coding/shell/rofi_font_symbols.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 13:49:55

chosen=$(< ~/.local/share/font-symbols rofi -monitor -2 -theme klassiker-vertical -dmenu -i -p "Which symbol to copy?" -l 10)

[ "$chosen" != "" ] || exit

# copy symbol to clipboard
clip=$(echo "$chosen" | sed "s/ .*//")
echo "$clip" | tr -d '\n' | xsel -b
# copy code to primary
pri=$(echo "$chosen" | sed "s/.*; //" | awk '{print $1}')
echo "$pri" | tr -d '\n' | xsel

notify-send -i "$HOME/coding/shell/icons/clip.png" "clip" "Copied to clipboard\t: $clip\nCopied to primary\t: $pri" &
