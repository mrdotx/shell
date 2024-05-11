#!/usr/bin/env bash

# path:   /home/klassiker/.local/share/repos/shell/stopwatch.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-05-09T12:25:16+0200

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
    start/stop: space
    quit:    q or esc

  Examples:
    $script
    $script -d"

counter=1
space=$(printf '\x20')
escape=$(printf '\033')

read_key() {
    read -rsN1 -t.05 key
    case "$exit_status" in
        1)  # start
            [ "$key" = "$space" ] \
                && printf "\n" \
                && counter=$((counter + 1)) \
                && return 2
            ;;
        2)  # stop
            [ "$counter" -eq 1000 ] \
                && counter=0
            [ "$key" = "$space" ] \
                && return 1
            ;;
    esac

    return "$1"
}

stopwatch() {
    time_index=0
    exit_status=2

    while ! { [ "$key" = "$escape" ] || [ "$key" = "q" ]; }; do
        case "$exit_status" in
            1)  # run
                t=$(printf "%06d" "$(($(date +%s%3N) - time_index))")
                printf "\r% 4d. %s" \
                    "$counter" \
                    "$(TZ=UTC date -d"@${t::(-3)}.${t:(-3)}" +%H:%M:%S.%3N)"
                ;;
            2)  # reset
                time_index=$(date +%s%3N)
                ;;
        esac
        read_key "$exit_status"
        exit_status=$?
    done

    # append line feed if escaped during the run
    { [ "$key" = "$escape" ] || [ "$key" = "q" ]; } \
        && [ $exit_status -eq 1 ] \
        && printf '\n'

    return 0
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -d)
        printf "\033c"
        stopwatch
        ;;
    *)
        printf "\033c%b%b\n" \
            " start/stop: space\n" \
            " quit:    q or esc\n"
        stopwatch
        ;;
esac
