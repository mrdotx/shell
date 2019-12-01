#!/bin/sh

# path:       ~/coding/shell/wlan.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 14:42:19

# refresh wifi networks and open network manager
nmcli device wifi list && nmtui
