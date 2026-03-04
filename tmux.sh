#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/tmux.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-03-04T05:12:11+0100

session="$(uname -n)"
attach="tmux attach -d -t $session"
term="$TERMINAL -T 'tmux' -e"

script=$(basename "$0")
help="$script [-h/--help] -- script to open applications in tmux windows
  Usage:
    $script [-o] [window] [title] [directory/command]

  Settings:
    without given settings, start/attach tmux session
    [-o]                = open tmux in separate terminal
    [window]            = tmux window no. to open application in
    [title]             = optional title of the window (default command)
                          shell = opens the shell
                          xtop  = opens htop and nvtop in split-window
    [directory/command] = application to start
                          if title is \"shell\" this is the start-directory

  Examples:
    $script
    $script 0 \"shell\"
    $script 9 \"sensors\"
    $script -o 0 \"shell\" \"$HOME/.config\"
    $script -o 9 \"sensors\" \"watch -n1 sensors\""

tmux_open() {
    if [ $# -ge 2 ]; then
        window=$1
        title=$2
        [ $# -ge 3 ] \
            && shift
        shift
        cmd="$*"

        ! tmux lsw 2>/dev/null | grep -q "^$window:" \
            && case "$title" in
                shell)
                    tmux neww -t "$session:$window" -c "$cmd"
                    ;;
                xtop)
                    lines="$((($(stty size | cut -d' ' -f1)-2)/3))"

                    tmux neww -t "$session:$window" -n "$title" "htop" \
                        \; splitw -l $lines -v "nvtop" \
                        \; selectp -t 1
                    ;;
                *)
                    tmux neww -t "$session:$window" -n "$title" "$cmd"
                    ;;
            esac

        tmux selectw -t "$session:$window"
    fi
}

tmux_kill_window() {
    [ -n "$1" ] \
        && [ -n "$window" ] \
        && [ ! "$window" -eq "$1" ] \
        && tmux killw -t "$session:$1"
}

case "$1" in
    "-h"|"--help")
        printf "%s\n" "$help"
        exit 0
        ;;
    "-o")
        open="$term $attach"
        shift
        ;;
    *)
        open="$attach"
        ;;
esac

case "$session" in
    "$(tmux ls 2>/dev/null | cut -d ':' -f1)")
        tmux_open "$@"
        ;;
    *)
        tmux new -d -s "$session"
        #tmux_open 15 "btop"
        tmux_open "$@"
        tmux_kill_window 1
        ;;
esac

if [ ! "$(pgrep -fx "$attach")" ]; then
    eval "$open"
fi
