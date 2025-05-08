#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backlight.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-05-08T05:49:03+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
message_title="Brightness"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to change backlight
  Usage:
    $script [-i/--increase/-d/--decrease] [percent] [-n/--notify]

  Settings:
    [-i/--increase] = increase in percent (0-100)
    [-d/--decrease] = decrease in percent (0-100)
    [percent]       = how much percent to increase/decrease the brightness
    [-n/--notify]   = send status notification

  Examples:
    $script --increase 5
    $script -d 5 -n
    $script --decrease 5 --notify"

backlight_dir=$( \
    find /sys/class/backlight -type l \
        | head -n1 \
)

notification() {
    case "$1" in
        -n | --notify)
            get_brightness "$2"

            notify-send \
                -t 2000 \
                -u low  \
                "$message_title $brightness%" \
                -h string:x-canonical-private-synchronous:"$message_title" \
                -h int:value:"$brightness"
            ;;
    esac
}

get_brightness_values() {
    [ "$1" -ge 0 ] \
        && [ "$1" -le 100 ] \
        && max=$(cat "$backlight_dir/max_brightness") \
        && actual=$(cat "$backlight_dir/actual_brightness") \
        && percent=$((100 / $1)) \
        && factor=$((max / percent)) \
        && [ "$factor" -eq 0 ] \
            && factor=1
}

get_brightness() {
    if [ "$max" -ge 100 ]; then
        brightness=$((max / 100))
        brightness=$((value / brightness))
    else
        brightness=$((100 / max))
        brightness=$((value * brightness))
    fi
    brightness=$((brightness /= $1))
    brightness=$((brightness *= $1))
}

set_brightness() {
    $auth sh -c "printf \"%s\" \"$1\" > \"$backlight_dir/brightness\"" \
        && notification "$3" "$2"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -i | --increase)
        get_brightness_values "$2"
        value=$((actual + factor))
        [ $value -ge "$max" ] \
            && value=$max
        set_brightness "$value" "$2" "$3"
        ;;
    -d | --decrease)
        get_brightness_values "$2"
        value=$((actual - factor))
        [ $value -le 0 ] \
            && value=0
        set_brightness "$value" "$2" "$3"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
