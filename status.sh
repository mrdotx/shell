#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/status.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-02-10T17:37:30+0100

# speed up script by not using unicode
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- script to show system information
  Usage:
    $script [-l]

  Settings:
    [-l] = system information in line

  Examples:
    $script
    $script -l"

kb_mb() {
    printf "%.0fM\n" "$(($1*1000/1024))e-3"
}

kb_gb() {
    printf "%.2fG\n" "$(($1*1000/1024/1024))e-3"
}

kernel() {
    printf "%s" "$(uname -r)"
}

cpu() {
    cores="$(grep -c "^processor" /proc/cpuinfo)"
    cpu_usage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum*1000}')"
    cpu_usage="$(printf "%.0f\n" "$((cpu_usage/${cores:-1}))e-3")"

    if test -d /sys/class/thermal/thermal_zone0/temp; then
        cpu_temp="$(cut -c "1-2" /sys/class/thermal/thermal_zone0/temp)C"
        printf "%s [%s%%]" "$cpu_temp" "$cpu_usage"
    else
        printf "%s%%" "$cpu_usage"
    fi
}

ram() {
    ram_total="$(free | awk 'NR==2 { printf "%s",$2; }')"
    ram_together="$(free | awk 'NR==2 { printf "%s",$5; }')"
    ram="$(free | awk 'NR==2 { printf "%s",$3; }')"
    ram="$(printf "%.0f\n" "$(((ram+ram_together)))")"
    ram_usage="$(printf "%.0f\n" "$(((ram)/((ram_total)/100)))")"
    if [ "$ram" -le 1048576 ]; then
        printf "%s/%s [%s%%]" "$(kb_mb "$ram")" "$(kb_gb "$ram_total")" "$ram_usage"
    else
        printf "%s/%s [%s%%]" "$(kb_gb "$ram")" "$(kb_gb "$ram_total")" "$ram_usage"
    fi
}

swap() {
    swap_total="$(free | awk 'NR==3 { printf "%s",$2; }')"
    swap="$(free | awk 'NR==3 { printf "%s",$3; }')"
    swap_usage="$(printf "%.0f\n" "$(((swap)/((swap_total)/100)))")"
    if [ "$swap" -le 1048576 ]; then
        printf "%s/%s [%s%%]" "$(kb_mb "$swap")" "$(kb_gb "$swap_total")" "$swap_usage"
    else
        printf "%s/%s [%s%%]" "$(kb_gb "$swap")" "$(kb_gb "$swap_total")" "$swap_usage"
    fi
}

space() {
    space_total="$(df "$1" | awk 'NR==2 { printf "%s",$2; }')"
    space="$(df "$1" | awk 'NR==2 { printf "%s",$3; }')"
    space_usage="$(df "$1" | awk 'NR==2 { printf "%s",$5; }')"
    printf "%s/%s [%s]" "$(kb_gb "$space")" "$(kb_gb "$space_total")" "$space_usage"
}

wlan() {
    wlan="$(iwgetid -r)"
    wlan_signal="$(iwconfig "$1" | grep -i Link | cut -c "24-25")"
    wlan_signal="$(printf "%.0f\n" "$((wlan_signal*100/70))")"
    printf "%s [%s%%]" "$wlan" "$wlan_signal"
}

ipv4() {
    ip="$(ip -4 addr show "$1" | grep -oP "(?<=inet ).*(?=/)")"
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
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -l)
        printf "cpu: %s | " "$(cpu)"
        printf "ram: %s | " "$(ram)"
        printf "swap: %s | " "$(swap)"
        printf "/: %s | " "$(space "/")"
        printf "/home: %s | " "$(space "/home")"
        printf "wlan: %s | " "$(wlan "wlan0")"
        printf "ip: %s | " "$(ipv4 "wlan0")"
        printf "up: %s | " "$(up)"
        printf "kernel: %s | " "$(kernel)"
        printf "name: %s | " "$(name)"
        printf "%s\n" "$(clock)"
        ;;
    *)
        printf "\n"
        printf "cpu:    %s\n" "$(cpu)"
        printf "ram:    %s\n" "$(ram)"
        printf "swap:   %s\n" "$(swap)"
        printf "/:      %s\n" "$(space "/")"
        printf "/home:  %s\n" "$(space "/home")"
        printf "wlan:   %s\n" "$(wlan "wlan0")"
        printf "ip:     %s\n" "$(ipv4 "wlan0")"
        printf "uptime: %s\n" "$(up)"
        printf "kernel: %s\n" "$(kernel)"
        printf "\n--\n"
        printf "# %s\n" "$(name)"
        printf "# %s\n" "$(clock)"
        printf "\n"
        ;;
esac
