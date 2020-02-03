#!/bin/sh

# path:       ~/projects/shell/snippets/powertop.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-02-03T13:47:02+0100

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
