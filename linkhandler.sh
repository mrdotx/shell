#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/linkhandler.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-21 13:34:18

movies="mpv --quiet"
podcasts="$TERMINAL -e mpv --no-audio-display"
pictures="sxiv -a -s f"

# if no url given open browser
[ -z "$1" ] && {
    notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "No URL given, open browser!" &&
        "$BROWSER"
    exit
}

case "$1" in
*mkv | *webm | *mp4 | *youtube.com/watch* | *youtube.com/playlist* | *youtu.be*)
    notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Open in multimedia player!" &&
        setsid tsp $movies --input-ipc-server=/tmp/mpvsoc$(date +%s) "$1" >/dev/null 2>&1 &
    ;;
*mp3 | *flac | *opus)
    notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Open in multimedia player!" &&
        setsid tsp $podcasts --input-ipc-server=/tmp/mpvsoc$(date +%s) "$1" >/dev/null 2>&1 &
    ;;
*png | *jpg | *jpe | *jpeg | *gif)
    notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Open in picture viewer!" &&
        curl -sL "$1" >"/tmp/$(echo "$1" | sed "s/.*\///")" && $pictures "/tmp/$(echo "$1" | sed "s/.*\///")" >/dev/null 2>&1 &
    ;;
*)
    if [ -f "$1" ]; then
        notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Open in editor!" &&
            setsid "$TERMINAL" -e "$EDITOR" "$1" &
    else
        notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Open in browser!" &&
            setsid "$BROWSER" "$1" >/dev/null 2>&1 &
    fi
    ;;
esac
