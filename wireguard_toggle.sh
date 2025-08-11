#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wireguard_toggle.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:51:42+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
systemd_network="/etc/systemd/network"
wireguard_config="$systemd_network/wireguard"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to enable/disable wireguard interfaces
  Usage:
    $script [-s/--status] <config>

  Settings:
    [-s/--status] = shows the status of the specified config
    <config>      = wireguard config without extensions (netdev/network)

  Examples:
    $script 90-vpn_m75q
    $script -s 90-vpn_m75q

  Config:
    systemd_network  = \"$systemd_network\"
    wireguard_config = \"$wireguard_config\""

check_root() {
    [ "$(id -u)" -ne 0 ] \
        && printf "this script needs root privileges to run\n" \
        && exit 1
}

check_config() {
    ! [ -e "$wireguard_config/$1.netdev" ] \
        && printf "couldn't find config for %s\n" "$1" \
        && exit 1
}

enable_interface() {
    ln -s "$wireguard_config/$1.netdev" \
        "$systemd_network/$1.netdev"
    ln -s "$wireguard_config/$1.network" \
        "$systemd_network/$1.network"
    systemctl restart systemd-networkd.service
    printf "%s enabled\n" "$1"
}

disable_interface() {
    interface=$(
        grep "Name=" "$wireguard_config/$1.network" \
            | cut -d "=" -f2
    )

    ip link set "$interface" down
    ip link del dev "$interface"
    rm "$systemd_network/$1.netdev" \
        "$systemd_network/$1.network"
    printf "%s disabled\n" "$1"
}

interface_status() {
    if [ -h "$systemd_network/$1.netdev" ]; then
        printf "%s is enabled\n" "$1"
    else
        printf "%s is disabled\n" "$1"
    fi
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
        ;;
    -s | --status)
        check_config "$2"
        interface_status "$2"
        ;;
    *)
        check_root
        check_config "$1"

        if [ -h "$systemd_network/$1.netdev" ]; then
            disable_interface "$1"
        else
            enable_interface "$1"
        fi
        ;;
esac
