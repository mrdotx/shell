#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/cmus_notify.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 13:53:07

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

    if [ "$duration" -ge 0 ]; then
        position_minutes=$(printf "%02d" $((position / 60)))
        position_seconds=$(printf "%02d" $((position % 60)))
        duration_minutes=$(printf "%02d" $((duration / 60)))
        duration_seconds=$(printf "%02d" $((duration % 60)))
        title_status="$position_minutes:$position_seconds / $duration_minutes:$duration_seconds"
    fi

    case $status in
        "playing") info=" $title_status" ;;
        "paused") info=" $title_status" ;;
        "stopped") info=" $title_status" ;;
        *) info="" ;;
    esac

    if [[ "$stream" == "" ]]; then
        info_body="Artist: $artist\nAlbum : $album\nTrack : $tracknumber\nTitle : <b>$title</b>"
    else
        info_body="$title\n$genre\n$comment\n<b>$stream</b>"
    fi

    if [[ "$artist" == "" && "$title" == "" ]]; then
        notify-send -i "$HOME/coding/shell/icons/cmus.png" "C* Music Player | $info" "${file##*/}"
    else
        notify-send -i "$HOME/coding/shell/icons/cmus.png" "C* Music Player | $info" "$info_body"
    fi

else
    notify-send -i "$HOME/conding/shell/icons/cmus.png" "C* Music Player" "Not running!"
fi
