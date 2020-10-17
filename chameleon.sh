#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/chameleon.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-17T20:02:33+0200

color=$(chameleon)
preview="/tmp/chameleon_preview.png"

convert xc:"$color" -resize 50 "$preview"

[ -n "$color" ] \
    && printf "%s\n" "$color" \
        | xsel -i -b \
    && notify-send -i "$preview" "chameleon [$color]" "$color copied to clipboard"

rm -f "$preview"
