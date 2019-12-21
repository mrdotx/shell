#!/bin/sh

# path:       ~/projects/shell/polybar_vpn_hades.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:57:11

vpnname=hades

case "$1" in
    --status)
        if [ "$(nmcli connection show --active $vpnname)" ]
        then
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(nmcli connection show --active $vpnname)" ]
        then
            nmcli con down id $vpnname && \
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        else
            nmcli con up id $vpnname passwd-file "$HOME"/projects/hidden/vpn/$vpnname && \
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
esac
