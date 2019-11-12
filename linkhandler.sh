#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/linkhandler.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-12 22:13:51

pictures="sxiv -a -s f"
movies="mpv --quiet"

# if no url given open browser
[ -z "$1" ] && {
    "$BROWSER"
    exit
}

case "$1" in
*mkv | *webm | *mp4 | *youtube.com/watch* | *youtube.com/playlist* | *youtu.be*)
    setsid tsp $movies --input-ipc-server=/tmp/mpvsoc$(date +%s) "$1" >/dev/null 2>&1 &
    ;;
*png | *jpg | *jpe | *jpeg | *gif)
    curl -sL "$1" > "/tmp/$(echo "$1" | sed "s/.*\///")" && $pictures "/tmp/$(echo "$1" | sed "s/.*\///")"  >/dev/null 2>&1 &
    ;;
*mp3 | *flac | *opus | *mp3?source)
    setsid tsp curl -LO "$1" >/dev/null 2>&1 &
    ;;
*)
    if [ -f "$1" ]; then "$TERMINAL" -e "$EDITOR $1"
    else setsid $BROWSER "$1" >/dev/null 2>&1 & fi
    ;;
esac
