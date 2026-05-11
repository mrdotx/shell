#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/cyanrip.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-05-11T05:14:04+0200

case "$1" in
    -V|-h|-f|-I)
        cyanrip "$1"
        exit
        ;;
    --sampler)
        shift
        directory="{album} [{format}]"
        track="{album} - {if #totaldiscs# > #1#|disc|-}{track} - {artist} - {title}" \
        log="{album}{if #totaldiscs# > #1# - CD|disc|}"
        cue="{album}{if #totaldiscs# > #1# - CD|disc|}"
        ;;
    *)
        directory="{album_artist} - {album} [{format}]"
        track="{album_artist} - {album} - {if #totaldiscs# > #1#|disc|-}{track} - {title}"
        log="{album_artist} - {album}{if #totaldiscs# > #1# - CD|disc|}"
        cue="{album_artist} - {album}{if #totaldiscs# > #1# - CD|disc|}"
        ;;
esac

# determine the value for -s with -f
cyanrip \
    -s 6 \
    -o wav,mp3 \
    -b 192 \
    "$@" \
    -T simple \
    -D "$directory" \
    -F "$track" \
    -L "$log" \
    -M "$cue" \
    -Q
