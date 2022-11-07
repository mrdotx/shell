#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wireguard_toggle.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-11-07T19:13:48+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# config
systemd_network="/etc/systemd/network"
wireguard_config="$systemd_network/wireguard"
prefix="99-"

script=$(basename "$0")
help="$script [-h/--help] -- script to enable/disable wireguard interfaces
  Usage:
    $script [-s/--status] <interface>

  Settings:
    [-s/--status] = shows the status of the specified interface/config
    <interface>   = wireguard interface/config

  Examples:
    $script wg0
    $script -s wg0

  Config:
    systemd_network  = \"$systemd_network\"
    wireguard_config = \"$wireguard_config\"
    prefix           = \"$prefix\""

check_root() {
    [ "$(id -u)" -ne 0 ] \
        && printf "this script needs root privileges to run\n" \
        && exit 1
}

check_config() {
    ! [ -e "$wireguard_config/$prefix$1.netdev" ] \
        && printf "couldn't find config for %s\n" "$1" \
        && exit 1
}

enable_interface() {
    ln -s "$wireguard_config/$prefix$1.netdev" \
        "$systemd_network/$prefix$1.netdev"
    ln -s "$wireguard_config/$prefix$1.network" \
        "$systemd_network/$prefix$1.network"
    systemctl restart systemd-networkd.service
    printf "%s enabled\n" "$1"
}

disable_interface() {
    ip link set "$1" down
    ip link del dev "$1"
    rm "$systemd_network/$prefix$1.netdev" \
        "$systemd_network/$prefix$1.network"
    printf "%s disabled\n" "$1"
}

interface_status() {
    if [ -h "$systemd_network/$prefix$1.netdev" ]; then
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

        if [ -h "$systemd_network/$prefix$1.netdev" ]; then
            disable_interface "$1"
        else
            enable_interface "$1"
        fi
        ;;
esac
