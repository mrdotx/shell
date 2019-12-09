#!/bin/sh

# path:       ~/coding/shell/raspberrypi/sys_stat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-09 23:51:49

# start time
start=$(date +%s.%N)

echo "################################################################################"
system_name=$(hostname &)
standard_time=$(date +"%c" &)
echo "[${system_name}] - ${standard_time}"
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
operating_time=$(uptime --pretty &)
net_send=$(awk '{print $1/1024/1024/1024}' /sys/class/net/eth0/statistics/tx_bytes &)
net_received=$(awk '{print $1/1024/1024/1024}' /sys/class/net/eth0/statistics/rx_bytes &)
cpu=$(awk -F ": " '/Hardware/{print $2}' /proc/cpuinfo &)
cpu_frequency=$(/opt/vc/bin/vcgencmd measure_clock arm | awk -F "=" '{printf ("%0.0f",$2/1000000); }' &)
cpu_temp=$(/opt/vc/bin/vcgencmd measure_temp | awk -F '=' '{print $2}' &)
voltage=$(/opt/vc/bin/vcgencmd measure_volts | awk -F '=' '{print $2}' | sed 's/000//' &)
scaling_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &)
load_avg=$(awk -F ' ' '{print $1" "$2" "$3}' /proc/loadavg &)
memory=$(free -h &)
disc=$(df -hPT /boot / &)
echo "uptime:       ${operating_time}"
echo "ethernet:     sent: ${net_send}GB received: ${net_received}GB"
echo "processor:    ${cpu} ${cpu_frequency}MHz ${voltage} ${scaling_governor} ${cpu_temp}"
echo "load:         ${load_avg}"
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
service() {
    if [ "$(systemctl is-active "$1")" = "active" ]; then
        status="up  "
        runtime="$(systemctl status "$1" | awk -F '; ' 'FNR == 3 {print $NF}')"
    else
        status="down"
        runtime="-"
    fi
}
ports() {
    if ss -nlt | grep -q ":$1 "; then
        port="open  "
    else
        port="closed"
    fi
}
echo "Service           Status  Port            RunTime"
service "sshd"; ports "22"
echo "ssh               $status    22    $port    $runtime"
service "pihole-FTL"; ports "53"
echo "pihole            $status    53    $port    $runtime"
service "cloudflared-dns"; ports "5300"
echo "cloudflared       $status    5300  $port    $runtime"
service "tor"; ports "9050"
echo "tor               $status    9050  $port    $runtime"
service "org.cups.cupsd"; ports "631"
echo "cups              $status    631   $port    $runtime"
service "nginx"; ports "80"
echo "nginx             $status    80    $port    $runtime"
ports "443"
echo "                          443   $port"
service "rpimonitord"; ports "8888"
echo "rpimonitor        $status    8888  $port    $runtime"
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
