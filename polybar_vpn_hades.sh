#!/bin/sh

# path:       ~/coding/shell/polybar_vpn_hades.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 00:24:49

vpnname=hades

if [ "$(nmcli connection show --active $vpnname)" ]
then
    nmcli con down id $vpnname && \
    echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
else
    nmcli con up id $vpnname passwd-file "$HOME"/coding/hidden/vpn/$vpnname && \
    echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
fi
