#!/bin/sh

# path:       ~/projects/shell/xsel.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 15:03:00

# display contents of clipboard
clip=$(xsel -o -b)
prim=$(xsel -o -p)

[ -n "$clip" ] && notify-send -i "$HOME/projects/shell/icons/usb.png" "Clipboard:" "$clip"
[ -n "$prim" ] && notify-send -i "$HOME/projects/shell/icons/usb.png" "Primary:" "$prim"
