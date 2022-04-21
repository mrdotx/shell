#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/color_picker.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-21T10:45:30+0200

# speed up script by using posix
LC_ALL=C
LANG=C

color=$( \
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
        && xcolor -P 128 \
)

preview="$(mktemp -t color_picker_preview.XXXXXX.png)"

convert xc:"$color" -resize 32 "$preview"

[ -n "$color" ] \
    && printf "%s\n" "$color" \
        | xsel -i -b \
    && notify-send \
        -i "$preview" \
        "color picker" \
        "[$color] copied to clipboard"

rm -f "$preview"
