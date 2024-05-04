#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/led_flash.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-05-04T08:06:10+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# command options
while [ 1 -le "$#" ]; do
    case "$1" in
        -d | --delay)
            delay="$2" \
            shift 2
            ;;
        -i | --indicator)
            indicator="$2" \
            shift 2
            ;;
        *)
            script=$(basename "$0")
            printf "usage: %s [-d/--delay .5] [-i/--indicator numlock]\n" \
                "$script"
            exit 1
            ;;
    esac
done

path=$( \
    find /sys/class/leds -type l -name "*::${indicator:-"capslock"}" \
        | head -n1 \
)
value=$( \
    cat "$path/brightness" \
)

set_value() {
    $auth sh -c "printf \"%s\" \"$1\" > \"$path/brightness\""
    sleep "${delay:-.01}"
    $auth sh -c "printf \"%s\" \"$value\" > \"$path/brightness\""
}

case $value in
    0)
        set_value 1
        ;;
    *)
        set_value 0
        ;;
esac
