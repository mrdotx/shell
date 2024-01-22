#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aur_pkgstats.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-01-22T16:27:33+0100

# config
url="https://pkgstats.archlinux.de/api/packages"
pkgs_dir="${1:-"$HOME/.local/share/repos/aur"}"
file_header="Name	Month	Count	Popularity	Samples"

get_pkgs() {
    find "$pkgs_dir" -maxdepth 1 -type d -exec basename "{}" \; \
        | sed 1d
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

    printf "%s	%s	%s	%s	%s\n" \
        "$name" \
        "$month" \
        "$count" \
        "$popularity" \
        "$samples"
}

for pkg in $(get_pkgs); do
    printf "%s " "$pkg"

    [ -e "$pkgs_dir/$pkg.csv" ] \
        && output=$(sed "/$file_header/d" "$pkgs_dir/$pkg.csv") \
        && output=$(printf "%s\n%s" \
            "$output" \
            "$(request "$pkg")" \
        )

    [ -z "$output" ] \
        && output="$(request "$pkg")"

    printf "%s\n" "$file_header" > "$pkgs_dir/$pkg.csv"
    printf "%s" "$output" | sort -ur >> "$pkgs_dir/$pkg.csv"

    printf "=> finished\n"
    unset output
done
