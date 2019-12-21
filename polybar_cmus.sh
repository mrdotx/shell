#!/bin/sh

# path:       ~/projects/shell/polybar_cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:55:51

if info=$(cmus-remote -Q 2> /dev/null); then

    status=$(echo "$info" | grep '^status ' | sed 's/^status //')
    stream=$(echo "$info" | grep '^stream ' | sed 's/^stream //')
    duration=$(echo "$info" | grep '^duration ' | sed 's/^duration //')
    position=$(echo "$info" | grep '^position ' | sed 's/^position //')
    file=$(echo "$info" | grep '^file ' | sed 's/^file //')
    artist=$(echo "$info" | grep '^tag artist ' | sed 's/^tag artist //')
#    album=$(echo "$info" | grep '^tag album ' | sed 's/^tag album //')
#    tracknumber=$(echo "$info" | grep '^tag tracknumber ' | sed 's/^tag tracknumber //')
    title=$(echo "$info" | grep '^tag title ' | sed 's/^tag title //')
#    genre=$(echo "$info" | grep '^tag genre ' | sed 's/^tag genre //')
#    comment=$(echo "$info" | grep '^tag comment ' | sed 's/^tag comment //')

    if [ "$duration" -ge 0 ]; then
        pos_min=$(printf "%02d" $((position / 60)))
        pos_sec=$(printf "%02d" $((position % 60)))
        dur_min=$(printf "%02d" $((duration / 60)))
        dur_sec=$(printf "%02d" $((duration % 60)))
        title_status="$pos_min:$pos_sec / $dur_min:$dur_sec"
    fi

    case $status in
        "playing") info="%{F#dfdfdf}%{o#4084d6} $title_status" ;;
        "paused") info="%{F#dfdfdf}%{o#ff5555} $title_status" ;;
        "stopped") info="%{F#dfdfdf}%{o#666666} $title_status" ;;
        *) info="" ;;
    esac

    if [ "$stream" = "" ]; then
        info_body="$artist - $title"
    else
        info_body="$title - $stream"
    fi

    if [ "$artist" = "" ] && [ "$title" = "" ]; then
        echo "$info ${file##*/}%{o-}%{F-}"
    else
        echo "$info $info_body%{o-}%{F-}"
    fi

else
    echo
fi
