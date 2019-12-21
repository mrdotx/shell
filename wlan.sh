#!/bin/sh

# path:       ~/projects/shell/wlan.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 15:02:50

# refresh wifi networks and open network manager
nmcli device wifi list && nmtui
