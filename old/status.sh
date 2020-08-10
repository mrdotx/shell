#!/usr/bin/env bash

# path:       /home/klassiker/.local/share/repos/shell/old/status.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-08-10T17:56:47+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to show system information
  Usage:
    $script [-l/-v]

  Settings:
    [-l] = system information in line
    [-v] = system information vertical

  Examples:
    $script -l
    $script -v"

cpu() {
    cpu_temp="$(< /sys/class/thermal/thermal_zone0/temp cut -c "1-2")C"
    cores="$(grep -c "^processor" /proc/cpuinfo)"
    cpu_usage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
    cpu_usage="$((${cpu_usage/\.*/} / ${cores:-1}))%"
    printf "%s [%s]" "$cpu_temp" "$cpu_usage"
}

ram() {
    ram_total="$(free | awk 'NR==2 { printf "%s",$2; }')"
    ram_together="$(free | awk 'NR==2 { printf "%s",$5; }')"
    ram="$(free | awk 'NR==2 { printf "%s",$3; }')"
    ram="$(bc <<<"scale=3;($ram_together+$ram)/1024" | awk '{ printf("%.0f\n",$1) }')M"
    ram_totalg="$(bc <<<"scale=3;$ram_total/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    ram_total="$(bc <<<"scale=3;$ram_total/1024" | awk '{ printf("%.0f\n",$1) }')M"
    ram_usage="$(bc <<<"scale=3;$ram/($ram_total/100)" | awk '{ printf("%.0f\n",$1) }')%"
    printf "%s/%s [%s]" "$ram" "$ram_totalg" "$ram_usage"
}

swap() {
    swap_total="$(free | awk 'NR==3 { printf "%s",$2; }')"
    swap="$(free | awk 'NR==3 { printf "%s",$3; }')"
    swap="$(bc <<<"scale=3;$swap/1024" | awk '{ printf("%.0f\n",$1) }')M"
    swap_totalg="$(bc <<<"scale=3;$swap_total/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    swap_total="$(bc <<<"scale=3;$swap_total/1024" | awk '{ printf("%.0f\n",$1) }')M"
    swap_usage="$(bc <<<"scale=3;$swap/($swap_total/100)" | awk '{ printf("%.0f\n",$1) }')%"
    printf "%s/%s [%s]" "$swap" "$swap_totalg" "$swap_usage"
}

nvme() {
    nvme_total="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$2; }')"
    nvme="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$3; }')"
    nvme="$(bc <<<"scale=3;$nvme/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    nvme_total="$(bc <<<"scale=3;$nvme_total/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    nvme_usage="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$5; }')"
    printf "%s/%s [%s]" "$nvme" "$nvme_total" "$nvme_usage"
}

sda() {
    sda_total="$(df /dev/sda1 | awk 'NR==2 { printf "%s",$2; }')"
    sda="$(df /dev/sda1 | awk 'NR==2 { printf "%s",$3; }')"
    sda="$(bc <<<"scale=3;$sda/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    sda_total="$(bc <<<"scale=3;$sda_total/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
    sda_usage="$(df /dev/sda1 | awk 'NR==2 { printf "%s",$5; }')"
    printf "%s/%s [%s]" "$sda" "$sda_total" "$sda_usage"
}

wlan() {
    wlan="$(iwgetid -r)"
    wlan_signal="$(iwconfig wlan0 | grep -i Link | cut -c "24-25")"
    wlan_signal="$(bc <<<"scale=3;$wlan_signal/70*100" | awk '{ printf("%.0f\n",$1) }')%"
    printf "%s [%s]" "$wlan" "$wlan_signal"
}

ipv4() {
    ip="$(ip -4 addr show wlan0 | grep -oP "(?<=inet ).*(?=/)")"
    printf "%s" "$ip"
}

name() {
    name="$(whoami)@$(hostname)"
    printf "%s" "$name"
}

up() {
    up="$(uptime -p | sed 's/s//g; s/,//g; s/up //g; s/ week/w/g; s/ day/d/g; s/ hour/h/g; s/ minute/m/g')"
    printf "%s" "$up"
}

clock() {
    clock="$(date '+%a, %e %B %G, %k:%M')"
    printf "%s" "$clock"
}

case "$1" in
    -l)
        printf "cpu: %s | ram: %s | swap: %s | nvme: %s | sda: %s | wlan: %s | ip: %s | name: %s | up: %s | %s\n" \
            "$(cpu)" \
            "$(ram)" \
            "$(swap)" \
            "$(nvme)" \
            "$(sda)" \
            "$(wlan)" \
            "$(ipv4)" \
            "$(name)" \
            "$(up)" \
            "$(clock)"
        ;;
    -v)
        printf "%s\n\ncpu:  %s\nram:  %s\nswap: %s\nnvme: %s\nsda:  %s\nwlan: %s\nip:   %s\nup:   %s\n\n--\n# %s\n" \
            "$(name)" \
            "$(cpu)" \
            "$(ram)" \
            "$(swap)" \
            "$(nvme)" \
            "$(sda)" \
            "$(wlan)" \
            "$(ipv4)" \
            "$(up)" \
            "$(clock)"
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
        ;;
esac
