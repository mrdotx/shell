#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/wake_on_lan.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:54:12+0200

check() {
    tools="nc"

    printf "\n"
    for tool in $tools; do
        if command -v "$tool" > /dev/null 2>&1; then
            printf "      [ ] %s\n" "$tool"
        else
            printf "      [X] %s\n" "$tool"
        fi
    done
}

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to send magic packet
  Usage:
    $script [mac] [ip] [port]

  Settings:
    [mac]  = mandatory, mac address of the target machine
    [ip]   = optional, ip to send the magic packet to (default: 10.10.10.255)
    [port] = optional, port to send the magic packet to (default: 9)

  Examples:
    $script
    $script 11:22:33:44:55:66
    $script 11:22:33:44:55:66 10.10.10.20
    $script 11:22:33:44:55:66 10.10.10.20 4000

  Commands:
    tools required (X: missing commands): $(check)"

magic_packet() {
    # (12x f + 16x mac without separators) + escape (\x) every 2 chars
    mac=$(printf "%s" "$1" \
        | sed 's/[ :-]//g' \
    )

    printf "%s" \
            "ffffffffffff" \
            "$(for n in $(seq 16); do \
                printf "%s" "$mac"
                n=$((n-1))
            done)" \
        | sed -e 's/../\\x&/g'
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
        ;;
    *)
        printf "sending magic packet...\n"
        printf "%s" "$(magic_packet "$1")" \
            | nc --wait=1 --udp \
                "${2:-"10.10.10.255"}" \
                "${3:-9}"
        printf "done...\n"
        ;;
esac
