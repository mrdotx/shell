#!/usr/bin/env bash

# path:       /home/klassiker/.local/share/repos/shell/old/statusbar.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-08-07T07:53:47+0200

# commands for output
cputemp="$(< /sys/class/thermal/thermal_zone0/temp cut -c "1-2")ºC"
cores="$(grep -c "^processor" /proc/cpuinfo)"
cpuusage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpuusage="$((${cpuusage/\.*/} / ${cores:-1}))%"

ramtotal="$(free | awk 'NR==2 { printf "%s",$2; }')"
ramtogether="$(free | awk 'NR==2 { printf "%s",$5; }')"
ram="$(free | awk 'NR==2 { printf "%s",$3; }')"
ram="$(bc <<<"scale=3;($ramtogether+$ram)/1024" | awk '{ printf("%.0f\n",$1) }')M"
ramtotalg="$(bc <<<"scale=3;$ramtotal/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
ramtotal="$(bc <<<"scale=3;$ramtotal/1024" | awk '{ printf("%.0f\n",$1) }')M"
ramusage="$(bc <<<"scale=3;$ram/($ramtotal/100)" | awk '{ printf("%.0f\n",$1) }')%"

swaptotal="$(free | awk 'NR==3 { printf "%s",$2; }')"
swap="$(free | awk 'NR==3 { printf "%s",$3; }')"
swap="$(bc <<<"scale=3;$swap/1024" | awk '{ printf("%.0f\n",$1) }')M"
swaptotalg="$(bc <<<"scale=3;$swaptotal/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
swaptotal="$(bc <<<"scale=3;$swaptotal/1024" | awk '{ printf("%.0f\n",$1) }')M"
swapusage="$(bc <<<"scale=3;$swap/($swaptotal/100)" | awk '{ printf("%.0f\n",$1) }')%"

hddtotal="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$2; }')"
hdd="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$3; }')"
hdd="$(bc <<<"scale=3;$hdd/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
hddtotal="$(bc <<<"scale=3;$hddtotal/1024/1024" | awk '{ printf("%.2f\n",$1) }')G"
hddusage="$(df /dev/nvme0n1p2 | awk 'NR==2 { printf "%s",$5; }')"

wlan="$(iwgetid -r)"
wlansignal="$(iwconfig wlan0 | grep -i Link | cut -c "24-25")"
wlansignal="$(bc <<<"scale=3;$wlansignal/70*100" | awk '{ printf("%.0f\n",$1) }')%"

ip="$(ip -4 addr show wlan0 | grep -oP "(?<=inet ).*(?=/)")"
name="$(whoami)@$(hostname)"

clock="$(date '+%a, %e %B %G, %k:%M')"

uptime="$(uptime -p | sed 's/s//g; s/,//g; s/up //g; s/ week/w/g; s/ day/d/g; s/ hour/h/g; s/ minute/m/g')"

# put together
statusbar="cpu: $cputemp [$cpuusage] | ram: $ram/$ramtotalg [$ramusage] | swap: $swap/$swaptotalg [$swapusage] | hdd: $hdd/$hddtotal [$hddusage] | wlan: $wlan [$wlansignal] | ip: $ip | name: $name | uptime: $uptime | $clock"

# output
printf "%s\n" "$statusbar"
