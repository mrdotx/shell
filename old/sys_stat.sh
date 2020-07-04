#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/old/sys_stat.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-07-04T13:05:29+0200

tmux -f "$HOME/.config/tmux/tmux.conf" new -d -s sys_stat "htop"
tmux splitw -h "watch -n2 grep 'MHz' /proc/cpuinfo"
tmux splitw -v -p 100 "watch -n2 sensors"
tmux -2 attach -d
