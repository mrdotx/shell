#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/color_picker.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-03-13T17:25:17+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

color=$( \
    # WORKAROUND: xcolor doesn't start
    sleep .5 \
        && xcolor -P 128 \
)

preview="$(mktemp -t color_picker_preview.XXXXXX.png)"

convert xc:"$color" -resize 32 "$preview"

[ -n "$color" ] \
    && printf "%s" "$color" \
        | xsel -i -b \
    && notify-send \
        -i "$preview" \
        -u low \
        "color picker" \
        "[$color] copied to clipboard"

rm -f "$preview"
