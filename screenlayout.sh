#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/screenlayout.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:33:53

# procedure {{{
internal=eDP1
external=HDMI2

if xrandr | grep "$external disconnected"; then
    xrandr --output "$external" --off --output "$internal" --auto
else
    $HOME/.screenlayout/default.sh
fi
# }}}
