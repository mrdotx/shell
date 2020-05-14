#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/sys_stat.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:43:13+0200

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas --"

tmux -f "$HOME/.config/tmux/tmux.conf" new -d -s sys_stat "watch -n2 smem -a -t"
tmux splitw -h "watch -n2 $auth smem -u -a -t"
tmux splitw -v -p 100 "watch -n2 grep 'MHz' /proc/cpuinfo"
tmux splitw -v -p 100 "watch -n2 sensors"
tmux -2 attach -d
