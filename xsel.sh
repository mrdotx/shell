#!/bin/sh

# path:       ~/projects/shell/xsel.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:17:36+0100

# display contents of clipboard
clip=$(xsel -o -b)
prim=$(xsel -o -p)

[ -n "$clip" ] && notify-send -i "$HOME/projects/shell/icons/usb.png" "Clipboard:" "$clip"
[ -n "$prim" ] && notify-send -i "$HOME/projects/shell/icons/usb.png" "Primary:" "$prim"
