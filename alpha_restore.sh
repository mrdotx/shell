#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/alpha_restore.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-06-24T15:59:13+0200

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to find png files with suspicious data
                                in alpha channel
  Usage:
    $script [png files]

  Examples:
    $script test.png
    $script test1.png test2.png test3.png"


if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 1
else
    tmp_directory=$(mktemp -t -d alpha_restore.XXXXXX)
    suspicious=0

    printf ":: suspicious files\n"
    for f in "$@"; do
        magick "$f" -strip -alpha extract "$tmp_directory/alpha_extract.rgb"
        if ! (hexdump -ve '"%.2x"' "$tmp_directory/alpha_extract.rgb" \
                | grep -q '^f*$' \
            ); then
            printf " %s\n" "$f"
            cp "$f" "$tmp_directory"
            magick -strip -alpha off "$f" \
                "$tmp_directory/$(basename "$f").noalpha.png"
            suspicious=1
        fi
    done

    [ $suspicious -eq 1 ] \
        && printf "\n:: please inspect files in %s\n" "$tmp_directory" \
        || printf "\n:: no suspicious files\n"
fi
