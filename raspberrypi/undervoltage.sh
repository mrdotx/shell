#!/bin/bash

# path:       ~/coding/shell/raspberrypi/undervoltage.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-03 05:50:37

# information for results
# 0: under-voltage
# 1: arm frequency capped
# 2: currently throttled

# 16: under-voltage has occurred
# 17: arm frequency capped has occurred
# 18: throttling has occurred

# bad values
#  Temp  CPU fake/real     Health state    Vcore
# 50.8'C  900/ 900 MHz 1010000000000000000 1.3125V
# 49.8'C  900/ 900 MHz 1010000000000000000 1.3125V
# 49.8'C  900/ 600 MHz 1010000000000000101 1.2V
# 49.8'C  900/ 600 MHz 1010000000000000101 1.2V
# 48.7'C  900/ 600 MHz 1010000000000000101 1.2V
# 49.2'C  900/ 600 MHz 1010000000000000101 1.2V
# 48.7'C  900/ 900 MHz 1010000000000000000 1.3125V
# 46.5'C  900/ 900 MHz 1010000000000000000 1.3125V

# good values
#  Temp  CPU fake/real     Health state    Vcore
# 36.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 600 MHz 0000000000000000000 1.3125V
# 36.3'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 900 MHz 0000000000000000000 1.3125V

echo -e "To stop simply press [ctrl]-[c]\n"
counter=14
display_header="Time       Temp  CPU fake/real     Health state    Vcore"
while true; do
    (( counter++ ))
    if [ ${counter} -eq 15 ]; then
        echo -e "${display_header}"
        counter=0
    fi
    health=$(perl -e "printf \"%19b\n\", $(/opt/vc/bin/vcgencmd get_throttled | cut -f2 -d=)")
    temp=$(/opt/vc/bin/vcgencmd measure_temp | cut -f2 -d=)
    real_clockspeed=$(/opt/vc/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }')
    sys_clockspeed=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
    core_voltage=$(/opt/vc/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
    echo -e "$(date "+%H:%M:%S") ${temp}$(printf "%5s" "${sys_clockspeed}")/$(printf "%4s" "${real_clockspeed}") MHz $(printf "%019d" "${health}") ${core_voltage}"
    sleep 5
done
