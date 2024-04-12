#!/usr/bin/env bash

# path:   /home/klassiker/.local/share/repos/shell/stopwatch.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-11T18:35:31+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- script to measure the time
  Usage:
    $script [-d]

  Settings:
    [-d] = disable header

  Keys:
    Start/Stop: space
    Quit:       q or esc

  Examples:
    $script
    $script -d"

header=" Start/Stop: space
 Quit:       q or esc
 "

time_stop=0
time_now=0
time_index=0
status=2
n=1

set_time_now() {
    time_now=$(date +%s%3N)
}

time_date() {
    t="$1"
    s=$(printf "%1d\n" "${t: 0 : -3}")
    ms=${t: -3 : 3 }
    printf "\r%s" "   $n) $(TZ=UTC date -d"@$s.$ms" +%H:%M:%S.%3N)"
}

run() {
    time_stop=$((time_now - time_index))
    time_date $time_stop
}

reset() {
    set_time_now
    time_index=$time_now
}

read_key() {
    last=$1
    read -rsN1 -t.1 key;
    case "$status" in
        1)
            [ "$key" = $'\x20' ] \
                && printf "\n" \
                && n=$((n + 1)) \
                && return 2
            ;;
        2)
            [ "$key" = $'\x20' ] \
                && return 1
            ;;
    esac
    return "$last";
}

stopwatch() {
    while ! { [ "$key" = $'\e' ] || [ "$key" = "q" ]; }; do
        set_time_now
        case "$status" in
            1)
                run
                ;;
            2)
                reset
                ;;
        esac
        read_key $status
        status=$?
        sleep .1
    done
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -d)
        tput reset
        stopwatch
        ;;
    *)
        tput reset
        printf "%s\n" "$header"
        stopwatch
        ;;
esac
