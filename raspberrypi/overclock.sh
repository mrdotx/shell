#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/raspberrypi/overclock.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# Simple stress test for raspberry pi. If it survives this, it's probably stable.

# procedures {{{
echo "Testing overclock stability..."

# Max out all CPU cores. Heats it up, loads the power-supply.
for ((i = 0; i < $(nproc --all); i++)); do
    nice yes >/dev/null &
done

# Read the entire SD card 10x. Tests RAM and I/O
for i in $(seq 1 10); do
    echo reading: $i
    sudo dd if=/dev/mmcblk0 of=/dev/null bs=4M
done

# Writes 512 MB test file, 10x.
for i in $(seq 1 10); do
    echo writing: $i
    dd if=/dev/zero of=deleteme.dat bs=1M count=512
    sync
done

# Clean up
sudo killall yes
rm deleteme.dat

#Print summary. Anything nasty will appear in dmesg.
echo -n "CPU freq: "
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
echo -n "CPU temp: "
cat /sys/class/thermal/thermal_zone0/temp
dmesg | tail

echo "Not crashed yet, probably stable."
# }}}
