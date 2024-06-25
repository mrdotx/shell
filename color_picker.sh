#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/color_picker.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-06-24T15:59:22+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

color=$( \
    # WORKAROUND: xcolor doesn't start
    sleep .5 \
        && xcolor --scale 10 --preview-size 196 \
)

preview="$(mktemp -t color_picker_preview.XXXXXX.png)"

magick xc:"$color" -resize 32 "$preview"

[ -n "$color" ] \
    && printf "%s" "$color" \
        | xsel -i -b \
    && notify-send \
        -i "$preview" \
        -u low \
        "color picker" \
        "[$color] copied to clipboard"

rm -f "$preview"
