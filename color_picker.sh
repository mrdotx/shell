#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/color_picker.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:53:22+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

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
