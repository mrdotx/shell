#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wireguard_toggle.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-11-07T10:27:05+0100

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
    $script <interface>

  Settings:
    <interface> = wireguard interface

  Examples:
    $script wg0

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
        && printf "couldn't find config for interface '%s'\n" "$1" \
        && exit 1
}

enable_interface() {
    ln -s "$wireguard_config/$prefix$1.netdev" \
        "$systemd_network/$prefix$1.netdev"
    ln -s "$wireguard_config/$prefix$1.network" \
        "$systemd_network/$prefix$1.network"
    systemctl restart systemd-networkd.service
    printf "interface '%s' enabled\n" "$1"
}

disable_interface() {
    ip link set "$1" down
    ip link del dev "$1"
    rm "$systemd_network/$prefix$1.netdev" \
        "$systemd_network/$prefix$1.network"
    printf "interface '%s' disabled\n" "$1"
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
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
