#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/xsel.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:45:03+0200

# display contents of clipboard
clip=$(xsel -o -b)
prim=$(xsel -o -p)

[ -n "$clip" ] \
    && notify-send "Clipboard:" "$clip"
[ -n "$prim" ] \
    && notify-send "Primary:" "$prim"
