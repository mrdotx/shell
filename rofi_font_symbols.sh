#!/bin/sh

# path:       ~/coding/shell/rofi_font_symbols.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 18:10:32

chosen=$(< ~/.local/share/font-symbols rofi -monitor -2 -theme klassiker-vertical -dmenu -i -p "Which symbol to copy?" -l 10)

[ "$chosen" != "" ] || exit

# copy symbol to clipboard
clip=$(echo "$chosen" | sed "s/ .*//")
echo "$clip" | tr -d '\n' | xclip -selection clip
# copy code to primary
pri=$(echo "$chosen" | sed "s/.*; //" | awk '{print $1}')
echo "$pri" | tr -d '\n' | xclip

notify-send -i "$HOME/coding/shell/icons/clip.png" "clip" "Copied to clipboard\t: $clip\nCopied to primary\t: $pri" &
