#!/bin/sh

# path:       ~/projects/shell/polybar_vpn_hades.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-02 00:18:59

vpnname=hades
grey=$(xrdb -query | grep Polybar.foreground1: | cut -f2)
red=$(xrdb -query | grep color9: | cut -f2)

case "$1" in
    --status)
        if [ "$(nmcli connection show --active $vpnname)" ]
        then
            echo "%{o$red}%{o-}"
        else
            echo "%{o$grey}%{o-}"
        fi
        ;;
    *)
        if [ "$(nmcli connection show --active $vpnname)" ]
        then
            nmcli con down id $vpnname \
                && echo "%{o$grey}%{o-}"
        else
            nmcli con up id $vpnname passwd-file "$HOME"/projects/hidden/vpn/$vpnname \
                && echo "%{o$red}%{o-}"
        fi
        ;;
esac
