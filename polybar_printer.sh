#!/bin/sh

# path:       ~/coding/shell/polybar_printer.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 00:33:16

if [ "$(systemctl is-active org.cups.cupsd.service)" != "active" ]
then
    sudo -A systemctl start org.cups.cupsd.service && \
    sudo -A systemctl start avahi-daemon.service && \
    sudo -A systemctl start avahi-daemon.socket && \
    echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
else
    sudo -A systemctl stop org.cups.cupsd.service && \
    sudo -A systemctl stop avahi-daemon.service && \
    sudo -A systemctl stop avahi-daemon.socket && \
    echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
fi
