#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/chameleon.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-07T08:46:17+0200

# speed up script by not using unicode
LC_ALL=C
LANG=C

color=$( \
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
    && chameleon \
)
preview="/tmp/chameleon_preview.png"

convert xc:"$color" -resize 32 "$preview"

[ -n "$color" ] \
    && printf "%s\n" "$color" \
        | xsel -i -b \
    && notify-send \
        -i "$preview" \
        "chameleon [$color]" \
        "$color copied to clipboard"

rm -f "$preview"
