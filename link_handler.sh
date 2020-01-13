#!/bin/sh

# path:       ~/projects/shell/link_handler.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:14:51+0100

movies="mpv --quiet"
podcasts="$TERMINAL -e mpv --no-audio-display"
pictures="sxiv -a -s f"

# if no url given open browser
[ -z "$1" ] && {
    notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "No URL given, open browser..." \
        && "$BROWSER"
    exit
}

case "$1" in
*mkv | *webm | *mp4 | *youtube.com/watch* | *youtube.com/playlist* | *youtu.be*)
    notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "Open URL in multimedia player:\n$1" \
        && eval tsp "$movies --input-ipc-server=/tmp/mpvsoc$(date +%s) $1 > /dev/null 2>&1" &
    ;;
*mp3 | *flac | *opus)
    notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "Open URL in multimedia player:\n$1" \
        && eval tsp "$podcasts --input-ipc-server=/tmp/mpvsoc$(date +%s) $1 > /dev/null 2>&1" &
    ;;
*png | *jpg | *jpe | *jpeg | *gif)
    notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "Open URL in picture viewer:\n$1" \
        && curl -sL "$1" >"/tmp/$(echo "$1" | sed "s/.*\///")" \
        && $pictures "/tmp/$(echo "$1" | sed "s/.*\///")" >/dev/null 2>&1 &
    ;;
*)
    if [ -f "$1" ]; then
        notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "Open URL in editor:\n$1" \
            && eval "$TERMINAL -e $EDITOR $1" &
    else
        notify-send -i "$HOME/projects/shell/icons/rss.png" "Newsboat" "Open URL in browser:\n$1" \
            && eval "$BROWSER $1 > /dev/null 2>&1" &
    fi
    ;;
esac
