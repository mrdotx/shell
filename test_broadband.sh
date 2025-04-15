#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/test_broadband.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-04-15T06:21:14+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
retries=5
delay=10
csv="$HOME/Public/broadband/test.csv"
header="Date	Time	Ping	Down	Up	Host	IP	Km	Server	ID	Sponsor"

# helper
get_value() {
    printf "%s" "$1" \
        | cut -d ',' -f"$2"
}

# direct execution options
case $* in
    *"--list"*|*"--help"*|*"--version"*)
        speedtest-cli "$@"
        exit
        ;;
esac

# main
while [ "${error:-1}" -gt 0 ] && [ $retries -gt 0 ]; do
    test_result=$(speedtest-cli --csv "$@")
    error=$?
    retries=$((retries-1))
    [ $retries -gt 0 ] \
        || exit $error
    [ $error -gt 0 ] \
        && sleep $delay
done

[ -s "$csv" ] \
    || printf "%s\n" "$header" > "$csv"

printf "%s	%s	%s	%.2f	%.2f	%s	%s	%.2f	%s	%s	%s\n" \
    "$(date -d "$(get_value "$test_result" 4)" +"%d.%m.%Y")" \
    "$(date -d "$(get_value "$test_result" 4)" +"%H:%M:%S")" \
    "$(get_value "$test_result" 6)" \
    "$(printf "%s/1000000\n" "$(get_value "$test_result" 7)" | bc -l)" \
    "$(printf "%s/1000000\n" "$(get_value "$test_result" 8)" | bc -l)" \
    "$(uname -n)" \
    "$(get_value "$test_result" 10)" \
    "$(get_value "$test_result" 5)" \
    "$(get_value "$test_result" 3)" \
    "$(get_value "$test_result" 1)" \
    "$(get_value "$test_result" 2)" >> "$csv"
