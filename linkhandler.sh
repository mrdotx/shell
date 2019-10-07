#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/linkhandler.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# variables {{{
PICTURES="sxiv -a -s f"
MOVIES="mpv --quiet"
# }}}

# procedure {{{
# If no url given open browser
[ -z "$1" ] && {
    "$BROWSER"
    exit
}

case "$1" in
*mkv | *webm | *mp4 | *youtube.com/watch* | *youtube.com/playlist* | *youtu.be*)
    setsid $MOVIES --input-ipc-server=/tmp/mpvsoc$(date +%s) "$1" >/dev/null 2>&1 &
    ;;
*png | *jpg | *jpe | *jpeg | *gif)
    curl -sL "$1" > "/tmp/$(echo "$1" | sed "s/.*\///")" && $PICTURES "/tmp/$(echo "$1" | sed "s/.*\///")"  >/dev/null 2>&1 &
    ;; 
*mp3 | *flac | *opus | *mp3?source)
    setsid tsp curl -LO "$1" >/dev/null 2>&1 &
    ;;
*)
    if [ -f "$1" ]; then "$TERMINAL" -e "$EDITOR $1"
    else setsid $BROWSER "$1" >/dev/null 2>&1 & fi
    ;;
esac
# }}}
