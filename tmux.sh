#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-21T12:18:17+0200

tmux_config="$HOME/.config/tmux/tmux.conf"
tmux_session="${1:-mi}"

tmux_autostart() {
    tmux -f "$tmux_config" new -d -s "$1" -n "shell"
    # tmux neww -t "$1":8 -n "htop" "htop"
    # tmux splitw -h "watch -n2 grep 'MHz' /proc/cpuinfo"
    # tmux splitw -v -p 100 "watch -n2 sensors"
    ! [ "$(pgrep -f "bpytop")" ] \
        && tmux neww -t "$1":9 -n "bpytop" "bpytop"
    tmux selectw -t "$1":0
    tmux -2 attach -d
}

tmux_attach() {
    tmux attach -t "$1"
}

if [ -z "$TMUX" ]; then
    tmux_attach "$tmux_session" \
        || tmux_autostart "$tmux_session"
fi
