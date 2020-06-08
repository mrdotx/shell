#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/chameleon.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T12:52:22+0200

color=$(chameleon)
preview="/tmp/chameleon_preview.png"

convert xc:"$color" -resize 50 "$preview"

[ -n "$color" ] \
    && printf "%s\n" "$color" \
        | xsel -b \
    && printf "%s\n" "$color" \
        | xsel \
    && notify-send -i "$preview" "chameleon [$color]" "$color copied to clipboard and primary"

rm -f "$preview"
