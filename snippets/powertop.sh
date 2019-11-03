#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/powertop.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:30:18

# procedure {{{
# Software Settings in Need of Tuning
# sets all tunable options to their Good setting
powertop --auto-tune;

# Wake status of the devices
# Wake-On-LAN-Status für Gerät wlp1s0
echo 'enabled' > '/sys/class/net/wlp1s0/device/power/wakeup';

# Wake status for USB device usb1
echo 'enabled' > '/sys/bus/usb/devices/usb1/power/wakeup';

# Wake status for USB device 1-3
echo 'enabled' > '/sys/bus/usb/devices/1-3/power/wakeup';

# Wake status for USB device usb2
echo 'enabled' > '/sys/bus/usb/devices/usb2/power/wakeup';
# }}}
