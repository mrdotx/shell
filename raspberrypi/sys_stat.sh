#!/bin/sh

# path:       ~/coding/shell/raspberrypi/sys_stat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-06 00:15:24

# start time
start=$(date +%s.%N)

echo "################################################################################"
systemname=$(hostname &)
standardtime=$(date +"%c" &)
echo "[${systemname}] - ${standardtime}"
echo "################################################################################"
echo

echo "[Distribution]"
echo "--------------------------------------------------------------------------------"
name=$(awk -F '"' '/PRETTY_NAME/{print $2}' /etc/os-release &)
kernel=$(uname -msr &)
firmware=$(awk -F '#' '{print $2}' /proc/version &)
echo "name:         ${name}"
echo "kernel:       ${kernel}"
echo "firmware:     #${firmware}"
echo

echo "[System]"
echo "--------------------------------------------------------------------------------"
operatingtime=$(uptime --pretty &)
net_send=$(awk '{print $1/1024/1024/1024}' /sys/class/net/eth0/statistics/tx_bytes &)
net_received=$(awk '{print $1/1024/1024/1024}' /sys/class/net/eth0/statistics/rx_bytes &)
cpu=$(awk -F ": " '/Hardware/{print $2}' /proc/cpuinfo &)
cpu_frequency=$(/opt/vc/bin/vcgencmd measure_clock arm | awk -F "=" '{printf ("%0.0f",$2/1000000); }' &)
cpu_temp=$(/opt/vc/bin/vcgencmd measure_temp | awk -F '=' '{print $2}' &)
voltage=$(/opt/vc/bin/vcgencmd measure_volts | awk -F '=' '{print $2}' | sed 's/000//' &)
scaling_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &)
loadavg=$(awk -F ' ' '{print $1" "$2" "$3}' /proc/loadavg &)
memory=$(free -h &)
disc=$(df -hPT /boot / &)
echo "uptime:       ${operatingtime}"
echo "ethernet:     sent: ${net_send}GB received: ${net_received}GB"
echo "processor:    ${cpu} ${cpu_frequency}MHz ${voltage} ${scaling_governor} ${cpu_temp}"
echo "load:         ${loadavg}"
echo
echo "${memory}"
echo
echo "${disc}"
echo

echo "[Top 5 Processes]"
echo "--------------------------------------------------------------------------------"
top_processes=$(ps -e -o pid,etimes,time,comm --sort -time | sed "6q" &)
echo "${top_processes}"
echo

echo "[Services]"
echo "--------------------------------------------------------------------------------"
status() {
    if [ "$(systemctl is-active "$1")" = "active" ]; then
        echo "up  "
    else
        echo "down"
    fi
}
runtime() {
    if [ "$(systemctl is-active "$1")" = "active" ]; then
        systemctl status "$1" | awk -F '; ' 'FNR == 3 {print $NF}'
    else
        echo "-"
    fi
}
port() {
    if netstat -nlt | grep -q ":$1 "; then
        echo "open  "
    else
        echo "closed"
    fi
}
echo "Service      Status  Port            RunTime"
echo "ssh          $(status "sshd")    22    $(port "22")    $(runtime "sshd")"
echo "pihole       $(status "pihole-FTL")    53    $(port "53")    $(runtime "pihole-FTL")"
echo "cloudflared  $(status "cloudflared-dns")    5300  $(port "5300")    $(runtime "cloudflared-dns")"
echo "tor          $(status "tor")    9050  $(port "9050")    $(runtime "tor")"
echo "cups         $(status "org.cups.cupsd")    631   $(port "631")    $(runtime "org.cups.cupsd")"
echo "nginx        $(status "nginx")    80    $(port "80")    $(runtime "nginx")"
echo "                     443   $(port "443")"
echo "rpimonitor   $(status "rpimonitord")    8888  $(port "8888")    $(runtime "rpimonitord")"
echo

# failures
echo "[Failures]"
echo "--------------------------------------------------------------------------------"
failures=$(systemctl --failed && journalctl -p 3 -xb &)
echo "${failures}" | fold
echo

# packages
echo "[Packages]"
echo "--------------------------------------------------------------------------------"
packages=$(checkupdates &)
echo "${packages}"
echo

echo "################################################################################"
duration=$(echo "$(date +%s.%N) - $start" | bc)
execution_time=$(printf "%.2f seconds" "$duration")
echo "Script Execution Time: $execution_time"
echo "################################################################################"
