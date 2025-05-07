#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/alsa.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-05-07T05:50:52+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
config_path="$HOME/.config/alsa"
config_file="asoundrc"
analog_filter="analog"
message_title="Volume"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to change alsa audio output
  Usage:
    $script [-i/--increase/-d/--decrease/-a/--absolute] [percent] [-n/--notify]
    $script [-m/--mute/-u/--unmute/-t/--toggle] [-n/--notify]

  Settings:
    [-i/--increase] = increase in percent (0-100)
    [-d/--decrease] = decrease in percent (0-100)
    [-a/--absolute] = absolute volume in percent (0-100)
    [percent]       = percentage of increase/decrease/absolute volume
    [-m/--mute]     = mute audio
    [-u/--unmute]   = unmute audio
    [-t/--toggle]   = toggle mute status
    [-n/--notify]   = send status notification

  Examples:
    $script --increase 5
    $script -d 5 -n
    $script --absolute 36
    $script -m
    $script --unmute
    $script --toggle --notify"

notification() {
    case "$1" in
        -n | --notify)
            get_volume "$2"

            notify-send \
                -t 2000 \
                -u low \
                "$message_title $volume_indicator" \
                -h string:x-canonical-private-synchronous:"$message_title" \
                -h int:value:"$volume"
            ;;
    esac
}

get_analog() {
    card=$(grep -m1 "card" "$config_path/$config_file" \
        | sed 's/^    //' \
    )

    ! aplay -l \
        | grep -m1 -i -e "^$card.*$analog_filter" > /dev/null 2>&1 \
            && device_mixer="PCM" \
            && device_mute="IEC958" \
            && return

    device_mixer="Master"
    device_mute="Master"
}

get_volume() {
    amixer get "$device_mute" | tail -1 | grep "\[off\]" >/dev/null \
        && volume=0 \
        && volume_indicator="MUTE" \
        && return

    volume="$(amixer get "$device_mixer" \
        | tail -1 \
        | cut -d'[' -f2 \
        | sed 's/%]*//' \
    )"
    volume=$((volume /= ${1:-1}))
    volume=$((volume *= ${1:-1}))
    volume_indicator="$volume%"
}

set_volume() {
    [ "$2" -ge 0 ] > /dev/null 2>&1 \
        && [ "$2" -le 100 ] > /dev/null 2>&1 \
        && get_analog \
        && amixer -q set "$device_mixer" "$2%$1" \
        && notification "$3" "$2"
}

set_mute() {
    get_analog \
        && amixer -q set "$device_mute" "$1" \
        && notification "$2"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -i | --increase)
        set_volume "+" "$2" "$3"
        ;;
    -d | --decrease)
        set_volume "-" "$2" "$3"
        ;;
    -a | --absolute)
        set_volume "" "$2" "$3"
        ;;
    -m | --mute)
        set_mute "mute" "$2"
        ;;
    -u | --unmute)
        set_mute "unmute" "$2"
        ;;
    -t | --toggle)
        set_mute "toggle" "$2"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
