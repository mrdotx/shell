#!/bin/sh

# path:       ~/coding/shell/polybar_bluetooth.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 00:28:47

if [ "$(systemctl is-active bluetooth.service)" != "active" ]
then
    sudo -A systemctl start bluetooth.service && \
    sudo -A systemctl start bluetooth.target && \
    sudo -A systemctl start ModemManager.service && \
    echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
else
    sudo -A systemctl stop bluetooth.service && \
    sudo -A systemctl stop bluetooth.target && \
    sudo -A systemctl stop ModemManager.service && \
    echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
fi
