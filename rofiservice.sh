#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/rofiservice.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

pgrep -x rofi && exit

# polkit {{{
polkitservice() {
    POLKITAPP=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

    if [ "$(pgrep -f $POLKITAPP)" ]; then
        killall $POLKITAPP && notify-send "Polkit" "Gnome Authentication Agent stopped!" && exit 0
    else
        $POLKITAPP >/dev/null 2>&1 &
        notify-send "Polkit" "Gnome Authentication Agent started!" && exit 0
    fi
}
# }}}

# VPN styx {{{
styxvpn() {
    VPN=styx

    if [ "$(nmcli connection show --active $VPN)" ]; then
        nmcli con down id $VPN && notify-send "VPN" "$VPN disconnected!" && exit 0
    else
        nmcli con up id $VPN passwd-file "$HOME"/bin/vpn/$VPN && notify-send "VPN" "$VPN connected!" && exit 0
    fi
}
# }}}

# nmapplet {{{
nmappletservice() {
    NMAPPLETAPP=nm-applet

    if [ "$(pgrep $NMAPPLETAPP)" ]; then
        killall $NMAPPLETAPP && notify-send "Network Manager" "stopped!" && exit 0
    else
        $NMAPPLETAPP >/dev/null 2>&1 &
        notify-send "Network Manager" "started!" && exit 0
    fi
}
# }}}

# printer {{{
printerservice() {
    if [ "$printerstatus" != "active" ]; then
        sudo -A systemctl start org.cups.cupsd.service && notify-send "Service" "Printer started!" && exit 0
    else
        sudo -A systemctl stop org.cups.cupsd.service && notify-send "Service" "Printer stopped!" && exit 0
    fi
}
# }}}

# avahi {{{
avahiservice() {
    if [ "$avahiserstatus" != "active" ]; then
        sudo -A systemctl start avahi-daemon.service && sudo -A systemctl start avahi-daemon.socket && notify-send "Service" "Avahi started!" && exit 0
    else
        sudo -A systemctl stop avahi-daemon.service && sudo -A systemctl stop avahi-daemon.socket && notify-send "Service" "Avahi stopped!" && exit 0
    fi
}
# }}}

# bluetooth {{{
bluetoothservice() {
    if [ "$bluetoothstatus" != "active" ]; then
        sudo -A systemctl start bluetooth.service && notify-send "Service" "Bluetooth started!" && exit 0
    else
        sudo -A systemctl stop bluetooth.service && notify-send "Service" "Bluetooth stopped!" && exit 0
    fi
}
# }}}

# modemmanager {{{
modemmanagerservice() {
    if [ "$modemmanagerstatus" != "active" ]; then
        sudo -A systemctl start ModemManager.service && notify-send "Service" "ModemManager started!" && exit 0
    else
        sudo -A systemctl stop ModemManager.service && notify-send "Service" "ModemManager stopped!" && exit 0
    fi
}
# }}}

# firewall {{{
firewallservice() {
    if [ "$firewallstatus" != "active" ]; then
        sudo -A systemctl start ufw.service && notify-send "Service" "Firewall started!" && exit 0
    else
        sudo -A systemctl stop ufw.service && notify-send "Service" "Firewall stopped!" && exit 0
    fi
}
# }}}

# status {{{
polkitstatus=$(if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]; then echo "active"; else echo "inactive"; fi)
styxvpnstatus=$(if [ "$(nmcli connection show --active hades)" ]; then echo "active"; else echo "inactive"; fi)
nmappletstatus=$(if [ "$(pgrep nm-applet)" ]; then echo "active"; else echo "inactive"; fi)
printerstatus=$(systemctl is-active org.cups.cupsd.service)
avahiserstatus=$(systemctl is-active avahi-daemon.service)
avahisocstatus=$(systemctl is-active avahi-daemon.socket)
bluetoothstatus=$(systemctl is-active bluetooth.service)
modemmanagerstatus=$(systemctl is-active ModemManager.service)
firewallstatus=$(systemctl is-active ufw.service)
conkystatus=$(if [ "$(pgrep -f "conky -c $HOME/.conky/*")" ]; then echo "active"; else echo "inactive"; fi)
# }}}

# menu {{{
case $(printf "%s\n" "Authentication Agent ($polkitstatus)" "VPN styx ($styxvpnstatus)" "Netzwerk Manager ($nmappletstatus)" "Printer ($printerstatus)" "Avahi Service/Socket ($avahiserstatus/$avahisocstatus)" "Bluetooth ($bluetoothstatus)" "ModemManager ($modemmanagerstatus)" "Firewall ($firewallstatus)" "Conky ($conkystatus)" | rofi -dmenu -i -p "") in
Authentication?Agent*) polkitservice ;;
VPN?styx*) styxvpn ;;
Netzwerk?Manager*) nmappletservice ;;
Printer*) printerservice ;;
Avahi?Service/Socket*) avahiservice ;;
Bluetooth*) bluetoothservice ;;
ModemManager*) modemmanagerservice ;;
Firewall*) firewallservice ;;
Conky*) conky.sh ;;
esac
# }}}
