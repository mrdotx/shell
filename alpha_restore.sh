#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/alpha_restore.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:38:44+0200

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
    exit 0
else
    tmp_dir=$(mktemp -d /tmp/alpha_restore.XXXXXX)
    susp=0

    printf ":: suspicious files\n"
    for f in "$@"; do
        convert "$f" -strip -alpha extract "$tmp_dir/alpha_extract.rgb"
        if ! (hexdump -ve '"%.2x"' "$tmp_dir/alpha_extract.rgb"|grep -q '^f*$'); then
            printf " %s\n" "$f"
            cp "$f" "$tmp_dir"
            convert -strip -alpha off "$f" "$tmp_dir/$(basename "$f").noalpha.png"
            susp=1
        fi
    done

    [ $susp -eq 1 ] \
        && printf "\n:: please inspect files in %s\n" "$tmp_dir" \
        || printf "\n:: no suspicious files\n"
fi
