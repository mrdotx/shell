#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/update_dates.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-11-08T05:55:19+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
y99="\(20[0-9][0-9]\)"
m12="\([0-1][0-9]\)"
d31="\([0-3][0-9]\)"
t24="\([0-2][0-9]\)"
t60="\([0-5][0-9]\)"
z="\(+0000\)"
filter="$y99$m12$d31$t24$t60$t60 $z"

convert_date() {
    date_string=$( \
        printf "%s\n" "$1" \
            | sed \
                -e 's/./&-/4' \
                -e 's/./&-/7' \
                -e 's/./&T/10' \
                -e 's/./&:/13' \
                -e 's/./&:/16' \
    )

    date -d "$date_string" +'%Y%m%d%H%M%S %z'
}

grep -o "$filter" "$1" \
    | sort -u \
    | while IFS= read -r old_date; do
        new_date=$(convert_date "$old_date")
        sed -i "s/$old_date/$new_date/g" "$1"
    done
