#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/screenlayout.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
internal=eDP1
external=HDMI2

if xrandr | grep "$external disconnected"; then
    xrandr --output "$external" --off --output "$internal" --auto
else
    $HOME/.screenlayout/default.sh
fi
# }}}
