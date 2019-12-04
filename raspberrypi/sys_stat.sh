#!/bin/sh

# path:       ~/coding/shell/raspberrypi/sys_stat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 22:43:06

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
cpu_frequency=$(/opt/vc/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' &)
voltage=$(/opt/vc/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//' &)
scaling_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &)
echo "uptime:       ${operatingtime}"
echo "ethernet:     sent: ${net_send}GB received: ${net_received}GB"
echo "processor:    ${cpu} ${cpu_frequency}MHz ${voltage} ${scaling_governor}"
echo

echo "[Top 5 Processes]"
echo "--------------------------------------------------------------------------------"
top_processes=$(ps -e -o etimes,time,comm --sort -time | head -n6 &)
echo "${top_processes}"
echo

# failures
echo "[Failures]"
echo "--------------------------------------------------------------------------------"
failures=$(sudo systemctl --failed && sudo journalctl -p 3 -xb &)
echo "${failures}"
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
