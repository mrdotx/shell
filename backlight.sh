#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backlight.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-05-10T15:13:28+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# config
auth="${EXEC_AS_USER:-sudo}"
message_title="Brightness"

script=$(basename "$0")
help="$script [-h/--help] -- script to change backlight
  Usage:
    $script [-inc/-dec] [percent]

  Settings:
    [-inc]    = increase in percent (0-100)
    [-dec]    = decrease in percent (0-100)
    [percent] = how much percent to increase/decrease the brightness

  Examples:
    $script -inc 5
    $script -dec 5"

backlight_dir=$( \
    find /sys/class/backlight -type l \
        | head -n1 \
)

notification() {
    if [ "$1" -ge 100 ]; then
        brightness=$(($1 / 100))
        brightness=$(($2 / brightness))
    else
        brightness=$((100 / $1))
        brightness=$(($2 * brightness))
    fi
    brightness=$((brightness /= $3))
    brightness=$((brightness *= $3))

    notify-send \
        -u low  \
        -t 2000 \
        -i "dialog-information" \
        "$message_title $brightness" \
        -h string:x-canonical-private-synchronous:"$message_title" \
        -h int:value:"$brightness"
}

brightness() {
    if [ "$1" -ge 0 ] \
        && [ "$1" -le 100 ]; then
            max=$(cat "$backlight_dir/max_brightness")
            actual=$(cat "$backlight_dir/actual_brightness")

            percent=$((100 / $1))
            factor=$((max / percent))

            [ $factor -eq 0 ] \
                && factor=1
    else
        printf "%s\n" "$help"
        exit 1
    fi
}

set_brightness() {
    $auth sh -c "printf \"%s\" \"$1\" > \"$backlight_dir/brightness\""
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -inc)
        brightness "$2"
        value=$((actual + factor))
        [ $value -ge "$max" ] \
            && value=$max
        set_brightness "$value"
        notification "$max" "$value" "$2"
        ;;
    -dec)
        brightness "$2"
        value=$((actual - factor))
        [ $value -le 0 ] \
            && value=0
        set_brightness "$value"
        notification "$max" "$value" "$2"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
