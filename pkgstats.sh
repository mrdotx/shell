#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/pkgstats.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:54:03+0200

# config
url="https://pkgstats.archlinux.de/api/packages"
out_dir="$HOME/Public/pkgstats"

round() {
    # WORKAROUND: printf "%.0f" not completely converted in the dash shell
    awk "BEGIN {printf \"%.$1f\", $2}"
}

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

    printf "%s	%d	%d	%s	%d\n" \
        "$name" \
        "$month" \
        "$count" \
        "$(round 2 "$popularity")" \
        "$samples"
}

for pkg in "$@"; do
    # if pkg is a fullpath use only basename
    pkg=$(basename "$pkg")

    file_header="Name	Month	Count	Popularity	Samples"
    printf "%s" "$pkg"

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

    printf " => finished\n"
    unset output
done
