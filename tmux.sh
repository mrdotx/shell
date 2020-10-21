#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-21T20:24:36+0200

config="$HOME/.config/tmux/tmux.conf"
session="${1:-mi}"

tmux_neww() {
    window=$1
    shift
    cmd="$*"
    ! [ "$(pgrep -f "$cmd")" ] \
        && tmux neww -t "$session":"$window" -n "$cmd" "$cmd"
}

tmux_splitw() {
    window=$1
    direction=$2
    shift 2
    cmd="$*"
    ! [ "$(pgrep -f "$cmd")" ] \
        && tmux splitw -t "$session":"$window" -"$direction" "$cmd"
}

tmux_attach() {
    tmux attach -t "$session"
}

tmux_autostart() {
    tmux -f "$config" new -d -s "$session" -n "shell"
    tmux_neww 9 "bpytop"
    # tmux_splitw 9 h "watch -n2 grep 'MHz' /proc/cpuinfo"
    tmux selectw -t "$session":0
    tmux -2 attach -d
}

if [ -z "$TMUX" ]; then
    tmux_attach \
        || tmux_autostart
fi
