#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/speed_test.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-01-22T16:19:01+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
csv="$HOME/Public/speed_test.csv"
header="Date	Time	Ping	Down	Up	Host	IP	Km	Server	ID	Sponsor"

# helper
get_value() {
    printf "%s" "$1" \
        | cut -d ',' -f"$2"
}

# direct execution options
case $* in
    *"--list"*|*"--version"*)
        speedtest-cli "$@"
        exit 0
        ;;
esac

# main
speedtest_result=$(speedtest-cli --csv "$@")

[ -s "$csv" ] \
    || printf "%s\n" "$header" > "$csv"

printf "%s	%s	%s	%.2f	%.2f	%s	%s	%.2f	%s	%s	%s\n" \
    "$(date -d "$(get_value "$speedtest_result" 4)" +"%d.%m.%Y")" \
    "$(date -d "$(get_value "$speedtest_result" 4)" +"%H:%M:%S")" \
    "$(get_value "$speedtest_result" 6)" \
    "$(printf "%s/1000000\n" "$(get_value "$speedtest_result" 7)" | bc -l)" \
    "$(printf "%s/1000000\n" "$(get_value "$speedtest_result" 8)" | bc -l)" \
    "$(uname -n)" \
    "$(get_value "$speedtest_result" 10)" \
    "$(get_value "$speedtest_result" 5)" \
    "$(get_value "$speedtest_result" 3)" \
    "$(get_value "$speedtest_result" 1)" \
    "$(get_value "$speedtest_result" 2)" >> "$csv"
