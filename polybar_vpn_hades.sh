#!/bin/sh

# path:       ~/projects/shell/polybar_vpn_hades.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:15:53+0100

vpn_name=hades
grey=$(xrdb -query | grep Polybar.foreground1: | cut -f2)
red=$(xrdb -query | grep color9: | cut -f2)

case "$1" in
    --status)
        if [ "$(nmcli connection show --active $vpn_name)" ]
        then
            echo "%{o$red}%{o-}"
        else
            echo "%{o$grey}%{o-}"
        fi
        ;;
    *)
        if [ "$(nmcli connection show --active $vpn_name)" ]
        then
            nmcli con down id $vpn_name \
                && echo "%{o$grey}%{o-}"
        else
            gpg -o "/tmp/$vpn_name.txt" "$HOME/cloud/webde/Keys/$vpn_name.txt.gpg" \
                && nmcli con up id $vpn_name passwd-file "/tmp/$vpn_name.txt" \
                && rm -f "/tmp/$vpn_name.txt" \
                && echo "%{o$red}%{o-}"
        fi
        ;;
esac
