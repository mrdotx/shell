#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/powertop.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:02:11

# software settings in need of tuning
# sets all tunable options to their good setting
powertop --auto-tune;

# wake status of the devices
# wake-on-lan-status for device wlp1s0
echo 'enabled' > '/sys/class/net/wlp1s0/device/power/wakeup';

# wake status for usb device usb1
echo 'enabled' > '/sys/bus/usb/devices/usb1/power/wakeup';

# wake status for usb device 1-3
echo 'enabled' > '/sys/bus/usb/devices/1-3/power/wakeup';

# wake status for usb device usb2
echo 'enabled' > '/sys/bus/usb/devices/usb2/power/wakeup';
