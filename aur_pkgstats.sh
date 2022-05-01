#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aur_pkgstats.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-05-01T18:53:57+0200

# config
url="https://pkgstats.archlinux.de/api/packages"
pkgs_dir="$HOME/.local/share/repos/aur"
stats_dir="_pkgstats"
destination="$pkgs_dir/$stats_dir"
extension="json"

get_stats() {
    mkdir -p "$destination"

    data=$(curl -fsS "$url/$1")
    startmonth=$(printf "%s" "$data" \
        | awk -F '\"startMonth\":' '{print $2}' \
        | cut -d',' -f1)

    printf "%s" "$data" > "$destination/$1-$startmonth.$extension"
    printf "%s-%s.%s\n" "$1" "$startmonth" "$extension"
}

get_pkgs() {
    find "$pkgs_dir" -maxdepth 1 -type d -exec basename "{}" \; \
        | sed 1d \
        | grep -v "$stats_dir"
}

for pkg in $(get_pkgs); do
    get_stats "$pkg"
done
