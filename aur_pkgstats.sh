#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aur_pkgstats.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-05-09T19:43:40+0200

# config
url="https://pkgstats.archlinux.de/api/packages"
pkgs_dir="$HOME/.local/share/repos/aur"
stats_file="$pkgs_dir/pkgstats.csv"
file_header="Name,Month,Count,Popularity,Samples"

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

    printf "%s,%s,%s,%s,%s\n" \
        "$name" \
        "$month" \
        "$count" \
        "$popularity" \
        "$samples"
}

[ -e "$stats_file" ] \
    && output=$(sed "/$file_header/d" "$stats_file")

for pkg in $(get_pkgs); do
    printf "%s " "$pkg"
    output=$(printf "%s\n%s" \
        "$output" \
        "$(request "$pkg")" \
    )
    printf "=> finished\n"
done

printf "%s" "$file_header" > "$stats_file"
printf "\n%s" "$output" | sort -u >> "$stats_file"
