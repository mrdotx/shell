#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-21T22:06:08+0200

config="$HOME/.config/tmux/tmux.conf"
session="${1:-mi}"

tmux_neww() {
    window=$1
    shift
    cmd="$*"
    ! [ "$(pgrep -f "$cmd")" ] \
        && tmux neww -t "$session:$window" -n "$cmd" "$cmd"
}

tmux_splitw() {
    window=$1
    direction=$2
    shift 2
    cmd="$*"
    ! [ "$(pgrep -f "$cmd")" ] \
        && tmux splitw -t "$session:$window" -"$direction" "$cmd"
}

tmux_attach() {
    tmux -2 attach -t "$session" -d
}

tmux_autostart() {
    tmux -f "$config" new -s "$session" -n "shell" -d
    tmux_neww 9 "bpytop"
    # tmux_splitw 9 h "watch -n2 grep 'MHz' /proc/cpuinfo"
    tmux selectw -t "$session":0
    tmux_attach
}

[ -z "$TMUX" ] \
    && if [ "$(tmux ls 2>/dev/null | cut -d ':' -f1)" = "$session" ]; then
        tmux_attach
    else
        tmux_autostart
    fi
