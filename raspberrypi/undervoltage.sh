#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/raspberrypi/undervoltage.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:26:03

# info {{{
# 0: under-voltage
# 1: arm frequency capped
# 2: currently throttled

# 16: under-voltage has occurred
# 17: arm frequency capped has occurred
# 18: throttling has occurred

# Bad values
#  Temp  CPU fake/real     Health state    Vcore
# 50.8'C  900/ 900 MHz 1010000000000000000 1.3125V
# 49.8'C  900/ 900 MHz 1010000000000000000 1.3125V
# 49.8'C  900/ 600 MHz 1010000000000000101 1.2V
# 49.8'C  900/ 600 MHz 1010000000000000101 1.2V
# 48.7'C  900/ 600 MHz 1010000000000000101 1.2V
# 49.2'C  900/ 600 MHz 1010000000000000101 1.2V
# 48.7'C  900/ 900 MHz 1010000000000000000 1.3125V
# 46.5'C  900/ 900 MHz 1010000000000000000 1.3125V

# Good values
#  Temp  CPU fake/real     Health state    Vcore
# 36.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 600 MHz 0000000000000000000 1.3125V
# 36.3'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 600 MHz 0000000000000000000 1.3125V
# 37.9'C  900/ 900 MHz 0000000000000000000 1.3125V
# 37.4'C  900/ 900 MHz 0000000000000000000 1.3125V
# }}}

# procedure {{{
echo -e "To stop simply press [ctrl]-[c]\n"
Maxfreq=$(($(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq) - 15))
Counter=14
DisplayHeader="Time       Temp  CPU fake/real     Health state    Vcore"
while true; do
	let Counter++
	if [ ${Counter} -eq 15 ]; then
		echo -e "${DisplayHeader}"
		Counter=0
	fi
	Health=$(perl -e "printf \"%19b\n\", $(/opt/vc/bin/vcgencmd get_throttled | cut -f2 -d=)")
	Temp=$(/opt/vc/bin/vcgencmd measure_temp | cut -f2 -d=)
	RealClockspeed=$(/opt/vc/bin/vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }')
	SysFSClockspeed=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
	CoreVoltage=$(/opt/vc/bin/vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
	echo -e "$(date "+%H:%M:%S"): ${Temp}$(printf "%5s" ${SysFSClockspeed})/$(printf "%4s" ${RealClockspeed}) MHz $(printf "%019d" ${Health}) ${CoreVoltage}"
	sleep 5
done
# }}}
