#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/wttr.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-08-17T03:48:04+0200

location_cache() {
    grep -q -s '[^[:space:]]' "$1" \
        || curl -fsS 'https://ipinfo.io/city' > "$1"

    cat "$1"
}

city=$(location_cache /tmp/location.cache | sed 's/ /%20/g')

case $1 in
    --clean)
        curl -fsS "v2d.wttr.in/$city?AFq" | uniq | sed '1d'
        ;;
    --default)
        curl -fsS "wttr.in/$city"
        ;;
    *)
        curl -fsS "v2d.wttr.in/$city?AF"
        ;;
esac
