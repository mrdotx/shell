#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aur_pkgstats.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-29T10:34:25+0200

# config
url="https://pkgstats.archlinux.de/api/packages"
out_dir="$HOME/Public/pkgstats"

extract_data() {
    printf "%s" "$1" \
        | awk -F "\"$2\":" '{print $2}' \
        | cut -d ',' -f1 \
        | tr -d "\""
}

request() {
    data=$(curl -fsS "$url/$1")
    name=$(extract_data "$data" "name")
    samples=$(extract_data "$data" "samples")
    count=$(extract_data "$data" "count")
    popularity=$(extract_data "$data" "popularity")
    month=$(extract_data "$data" "startMonth")

    printf "%s	%s	%s	%s	%s\n" \
        "$name" \
        "$month" \
        "$count" \
        "$popularity" \
        "$samples"
}

for pkg in "$@"; do
    file_header="Name	Month	Count	Popularity	Samples"
    printf "%s " "$pkg"

    [ -e "$out_dir/$pkg.csv" ] \
        && output=$(sed "/$file_header/d" "$out_dir/$pkg.csv") \
        && output=$(printf "%s\n%s" \
            "$output" \
            "$(request "$pkg")" \
        )

    [ -z "$output" ] \
        && output="$(request "$pkg")"

    printf "%s\n" "$file_header" > "$out_dir/$pkg.csv"
    printf "%s" "$output" | sort -ur >> "$out_dir/$pkg.csv"

    printf "=> finished\n"
    unset output
done
