#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/chameleon.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-03T18:52:30+0200

color=$(chameleon)
preview="/tmp/chameleon_preview.png"

convert xc:"$color" -resize 50 "$preview"

[ -n "$color" ] \
    && notify-send -i "$preview" "chameleon [$color]" "$color copied to clipboard and primary" \
    && printf "%s\n" "$color" \
        | xsel -b \
    && printf "%s\n" "$color" \
        | xsel

rm -f "$preview"
