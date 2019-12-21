#!/usr/bin/env bash

# path:       ~/projects/shell/raspberrypi/overclock.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:48:39

# simple stress test for raspberry pi. if it survives this, it's probably stable.
echo "Testing overclock stability..."

# max out all cpu cores. heats it up, loads the power-supply.
for ((i = 0; i < $(nproc --all); i++)); do
    nice yes >/dev/null &
done

# read the entire sd card 10x. tests ram and i/o
for i in $(seq 1 10); do
    echo reading: "$i"
    sudo dd if=/dev/mmcblk0 of=/dev/null bs=4M
done

# writes 512 mb test file, 10x.
for i in $(seq 1 10); do
    echo writing: "$i"
    dd if=/dev/zero of=deleteme.dat bs=1M count=512
    sync
done

# clean up
sudo killall yes
rm deleteme.dat

# print summary. anything nasty will appear in dmesg.
echo -n "CPU freq: "
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
echo -n "CPU temp: "
cat /sys/class/thermal/thermal_zone0/temp
dmesg | tail

echo "Not crashed yet, probably stable."
