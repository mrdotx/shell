#!/bin/sh

# path:       ~/projects/shell/raspberrypi/stability.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-22T23:44:30+0100

vcgencmd="/opt/vc/bin/vcgencmd"
cores=$(($(nproc --all) - 1))

echo "raspberry pi stability test"

echo ":: heat up all cpu cores to stress the power-supply"
for i in $(seq 0 $cores); do
    echo " core: $i"
    nice yes >/dev/null &
done

echo ":: read the entire sd card 5 times"
for i in $(seq 1 5); do
    echo " reading: $i"
    sudo dd if=/dev/mmcblk0 of=/dev/null bs=4M
done

echo ":: writes 512mb test file 5 times"
for i in $(seq 1 5); do
    echo " writing: $i"
    dd if=/dev/zero of=test.dat bs=1M count=512
    sync
done

echo ":: kill processes and delete test file"
sudo killall yes
rm test.dat

echo ":: summery"
printf " cpu freq: %s MHz\n" "$($vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }')"
printf " cpu temp: %s\n" "$($vcgencmd measure_temp | cut -f2 -d=)"
echo ":: check dmesg, the failures will be shown there"
dmesg | tail -n 5
