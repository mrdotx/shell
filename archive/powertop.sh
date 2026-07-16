#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/powertop.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:51:22+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# software settings in need of tuning
# sets all tunable options to their good setting
powertop --auto-tune;

# wake status of the devices
# wake-on-lan-status for device wlp1s0
printf "enabled\n" > "/sys/class/net/wlp1s0/device/power/wakeup'";

# wake status for usb device usb1
printf "enabled\n" > "/sys/bus/usb/devices/usb1/power/wakeup";

# wake status for usb device 1-3
printf "enabled\n" > "/sys/bus/usb/devices/1-3/power/wakeup";

# wake status for usb device usb2
printf "enabled\n" > "/sys/bus/usb/devices/usb2/power/wakeup";
