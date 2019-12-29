#!/bin/sh

# path:       ~/projects/shell/cmus_notify.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-29 20:02:13

if info=$(cmus-remote -Q 2> /dev/null); then
    status=$(echo "$info" | grep '^status ' | sed 's/^status //')
    stream=$(echo "$info" | grep '^stream ' | sed 's/^stream //')
    duration=$(echo "$info" | grep '^duration ' | sed 's/^duration //')
    position=$(echo "$info" | grep '^position ' | sed 's/^position //')
    file=$(echo "$info" | grep '^file ' | sed 's/^file //')
    artist=$(echo "$info" | grep '^tag artist ' | sed 's/^tag artist //')
    album=$(echo "$info" | grep '^tag album ' | sed 's/^tag album //')
    tracknumber=$(echo "$info" | grep '^tag tracknumber ' | sed 's/^tag tracknumber //')
    title=$(echo "$info" | grep '^tag title ' | sed 's/^tag title //')
    genre=$(echo "$info" | grep '^tag genre ' | sed 's/^tag genre //')
    comment=$(echo "$info" | grep '^tag comment ' | sed 's/^tag comment //')
else
    exit 2
fi

case "$1" in
    --notify-send)
        if [ "$duration" -ge 0 ]; then
            pos_min=$(printf "%02d" $((position / 60)))
            pos_sec=$(printf "%02d" $((position % 60)))
            dur_min=$(printf "%02d" $((duration / 60)))
            dur_sec=$(printf "%02d" $((duration % 60)))
            title_status="$pos_min:$pos_sec / $dur_min:$dur_sec"
        fi

        case $status in
            "playing") info=" $title_status" ;;
            "paused") info=" $title_status" ;;
            "stopped") info=" $title_status" ;;
            *) info="" ;;
        esac

        if [ "$stream" = "" ]; then
            info_body="Artist: $artist\nAlbum : $album\nTrack : $tracknumber\nTitle : <b>$title</b>"
        else
            info_body="$title\n$genre\n$comment\n<b>$stream</b>"
        fi

        if [ "$artist" = "" ] && [ "$title" = "" ]; then
            notify-send -i "$HOME/projects/shell/icons/cmus.png" "C* Music Player | $info" "${file##*/}"
        else
            notify-send -i "$HOME/projects/shell/icons/cmus.png" "C* Music Player | $info" "$info_body"
        fi
        ;;
    --polybar)
        case $status in
            "playing") info="" ;;
            "paused") info="%{F#dfdfdf}%{o#666666}" ;;
            "stopped") info="%{F#dfdfdf}%{o#ff5555}" ;;
            *) info="" ;;
        esac

        if [ "$stream" = "" ]; then
            info_body="$album | $tracknumber | $artist - $title"
        else
            info_body="$title | $genre | $stream"
        fi

        if [ "$artist" = "" ] && [ "$title" = "" ]; then
            echo "$info ${file##*/}"
        else
            echo "$info $info_body"
        fi
        ;;
    *)
        polybar-msg hook module/cmus 2
        ;;
esac
