#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/alpha_restore.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:53:05+0200

# color variables
reset="\033[0m"
bold="\033[1m"
green="\033[32m"
blue="\033[94m"
cyan="\033[96m"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to find png files with suspicious data
                                in alpha channel
  Usage:
    $script <file>.png [file1.png] [file2.png]

  Examples:
    $script test.png
    $script test1.png test2.png test3.png"

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 1
else
    tmp_directory=$(mktemp -t -d alpha_restore.XXXXXX)
    suspicious=0

    printf "%b%b::%b %bsuspicious files%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset"
    for f in "$@"; do
        magick "$f" -strip -alpha extract "$tmp_directory/alpha_extract.rgb"
        if ! (hexdump -ve '"%.2x"' "$tmp_directory/alpha_extract.rgb" \
                | grep -q '^f*$' \
            ); then
            printf "%s\n" "$f"
            cp "$f" "$tmp_directory"
            magick -strip -alpha off "$f" \
                "$tmp_directory/$(basename "$f").noalpha.png"
            suspicious=1
        fi
    done

    [ $suspicious -eq 1 ] \
        && printf "%b%b==>%b please inspect files in %b%s%b\n" \
            "$bold" "$green" "$reset" "$cyan" "$tmp_directory" "$reset"\
        || printf "%b%b==>%b %bno suspicious files%b\n" \
            "$bold" "$green" "$reset" "$bold" "$reset"
fi
