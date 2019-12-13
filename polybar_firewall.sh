#!/bin/sh

# path:       ~/coding/shell/polybar_firewall.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 00:25:57

if [ "$(systemctl is-active ufw.service)" != "active" ]
then
    sudo -A systemctl start ufw.service && \
    echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
else
    sudo -A systemctl stop ufw.service && \
    echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
fi
