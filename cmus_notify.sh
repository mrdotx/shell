#!/bin/sh

# path:       ~/projects/shell/cmus_notify.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-01 22:39:35

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

        if [ -z "$stream" ]; then
            info_body="Artist: $artist\nAlbum : $album\nTrack : $tracknumber\nTitle : <b>$title</b>"
        else
            info_body="<b>$stream</b>\n$genre\n$title\n$comment"
        fi

        if [ -z "$artist" ] && [ -z "$title" ]; then
            notify-send -i "$HOME/projects/shell/icons/cmus.png" "C* Music Player | $info" "${file##*/}"
        else
            notify-send -i "$HOME/projects/shell/icons/cmus.png" "C* Music Player | $info" "$info_body"
        fi
        ;;
    --polybar)
        grey=$(xrdb -query | grep Polybar.foreground1: | cut -f2)
        red=$(xrdb -query | grep color9: | cut -f2)

        case $status in
            "playing") info=""
                len=100 ;;
            "paused") info="%{o$grey}"
                len=111 ;;
            "stopped") info="%{o$red}"
                len=111 ;;
            *) info="" ;;
        esac

        if [ -z "$stream" ]; then
            info_body="$artist | $title | $album"
        else
            info_body="$stream | $genre | $title"
        fi

        if [ -z "$artist" ] && [ -z "$title" ]; then
            echo "$info ${file##*/}" | cut -c 1-$len
        else
            echo "$info $info_body" | cut -c 1-$len
        fi
        ;;
    *)
        polybar-msg hook module/cmus 2
        ;;
esac
