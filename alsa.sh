#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/alsa.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/dmenu
# date:   2022-04-21T10:46:59+0200

# speed up script by using posix
LC_ALL=C
LANG=C

# config
config_path="$HOME/.config/alsa"
config_file="asoundrc"
analog_filter="analog"
message_title="Volume"

script=$(basename "$0")
help="$script [-h/--help] -- script to change alsa audio output
  Usage:
    $script [-inc/-dec/-abs/-mute] [percent]

  Settings:
    [-inc]    = increase in percent (0-100)
    [-dec]    = decrease in percent (0-100)
    [-abs]    = absolute volume in percent (0-100)
    [percent] = how much percent to increase/decrease the volume
    [-mute]   = mute volume

  Examples:
    $script -inc 5
    $script -dec 5
    $script -abs 36
    $script -mute"

notification() {
    volume="$(amixer get "$1" \
        | tail -1 \
        | cut -d'[' -f2 \
        | sed 's/%]*//' \
    )"

    if amixer get "$2" | tail -1 | grep "\[off\]" >/dev/null; then
        volume=0 \
        volume_indicator="MUTE"
    else
        volume=$((volume /= ${3:-1}))
        volume=$((volume *= ${3:-1}))
        volume_indicator="$volume"
    fi

    notify-send \
        -u low  \
        -t 2000 \
        -i "dialog-information" \
        "$message_title $volume_indicator" \
        -h string:x-canonical-private-synchronous:"$message_title" \
        -h int:value:"$volume"
}

get_analog() {
    card=$(grep -m1 "card" "$config_path/$config_file" \
        | sed 's/^    //' \
    )

    if ! aplay -l \
        | grep -m1 -i -e "^$card.*$analog_filter" > /dev/null 2>&1; then
        device_mixer="PCM"
        device_mute="IEC958"
    else
        device_mixer="Master"
        device_mute="Master"
    fi
}

set_volume() {
    if [ "$#" -eq 2 ] \
        && [ "$2" -ge 0 ] > /dev/null 2>&1 \
        && [ "$2" -le 100 ] > /dev/null 2>&1; then
            amixer -q set $device_mixer "$2%$1"
            notification "$device_mixer" "$device_mute" "$2"
    else
        printf "%s\n" "$help"
        exit 1
    fi
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -inc)
        get_analog
        set_volume "+" "$2"
        ;;
    -dec)
        get_analog
        set_volume "-" "$2"
        ;;
    -abs)
        get_analog
        set_volume "" "$2"
        ;;
    -mute)
        get_analog
        amixer -q set $device_mute toggle
        notification "$device_mixer" "$device_mute"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
