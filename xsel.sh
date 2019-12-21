#!/bin/sh

# path:       ~/coding/shell/xsel.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 13:48:13

# display contents of clipboard
clip=$(xsel -o -b)
prim=$(xsel -o -p)

[ -n "$clip" ] && notify-send -i "$HOME/coding/shell/icons/usb.png" "Clipboard:" "$clip"
[ -n "$prim" ] && notify-send -i "$HOME/coding/shell/icons/usb.png" "Primary:" "$prim"
