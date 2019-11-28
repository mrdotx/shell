#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofi_service.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 13:56:44

# exit if rofi is running
pgrep -x rofi && exit

# polkit
polkitservice() {
    POLKITAPP=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

    if [ "$(pgrep -f $POLKITAPP)" ]; then
        killall $POLKITAPP && notify-send -i "$HOME/coding/shell/icons/service.png" "Polkit" "Gnome Authentication Agent stopped!" && exit 0
    else
        $POLKITAPP >/dev/null 2>&1 &
        notify-send -i "$HOME/coding/shell/icons/service.png" "Polkit" "Gnome Authentication Agent started!" && exit 0
    fi
}

# vpn
vpnname=hades
vpn() {
    if [ "$(nmcli connection show --active $vpnname)" ]; then
        nmcli con down id $vpnname && notify-send -i "$HOME/coding/shell/icons/service.png" "VPN" "$vpnname disconnected!" && exit 0
    else
        nmcli con up id $vpnname passwd-file "$HOME"/coding/hidden/vpn/$vpnname && notify-send -i "$HOME/coding/shell/icons/service.png" "VPN" "$vpnname connected!" && exit 0
    fi
}

# nmapplet
nmappletservice() {
    NMAPPLETAPP=nm-applet

    if [ "$(pgrep $NMAPPLETAPP)" ]; then
        killall $NMAPPLETAPP && notify-send -i "$HOME/coding/shell/icons/service.png" "Network Manager" "stopped!" && exit 0
    else
        $NMAPPLETAPP >/dev/null 2>&1 &
        notify-send -i "$HOME/coding/shell/icons/service.png" "Network Manager" "started!" && exit 0
    fi
}

# printer
printerservice() {
    if [ "$printerstatus" != "active" ]; then
        sudo -A systemctl start org.cups.cupsd.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Printer started!" && exit 0
    else
        sudo -A systemctl stop org.cups.cupsd.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Printer stopped!" && exit 0
    fi
}

# avahi
avahiservice() {
    if [ "$avahiserstatus" != "active" ]; then
        sudo -A systemctl start avahi-daemon.service && sudo -A systemctl start avahi-daemon.socket && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Avahi started!" && exit 0
    else
        sudo -A systemctl stop avahi-daemon.service && sudo -A systemctl stop avahi-daemon.socket && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Avahi stopped!" && exit 0
    fi
}

# bluetooth
bluetoothservice() {
    if [ "$bluetoothstatus" != "active" ]; then
        sudo -A systemctl start bluetooth.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Bluetooth started!" && exit 0
    else
        sudo -A systemctl stop bluetooth.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Bluetooth stopped!" && exit 0
    fi
}

# modemmanager
modemmanagerservice() {
    if [ "$modemmanagerstatus" != "active" ]; then
        sudo -A systemctl start ModemManager.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "ModemManager started!" && exit 0
    else
        sudo -A systemctl stop ModemManager.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "ModemManager stopped!" && exit 0
    fi
}

# firewall
firewallservice() {
    if [ "$firewallstatus" != "active" ]; then
        sudo -A systemctl start ufw.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Firewall started!" && exit 0
    else
        sudo -A systemctl stop ufw.service && notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "Firewall stopped!" && exit 0
    fi
}

# status
polkitstatus=$(if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]; then echo "active"; else echo "inactive"; fi)
vpnstatus=$(if [ "$(nmcli connection show --active $vpnname)" ]; then echo "active"; else echo "inactive"; fi)
nmappletstatus=$(if [ "$(pgrep nm-applet)" ]; then echo "active"; else echo "inactive"; fi)
printerstatus=$(systemctl is-active org.cups.cupsd.service)
avahiserstatus=$(systemctl is-active avahi-daemon.service)
avahisocstatus=$(systemctl is-active avahi-daemon.socket)
bluetoothstatus=$(systemctl is-active bluetooth.service)
modemmanagerstatus=$(systemctl is-active ModemManager.service)
firewallstatus=$(systemctl is-active ufw.service)
conkystatus=$(if [ "$(pgrep -x conky)" ]; then echo "active"; else echo "inactive"; fi)

# menu
case $(printf "%s\n" \
    "Authentication Agent ($polkitstatus)" \
    "VPN $vpnname ($vpnstatus)" \
    "Netzwerk Manager ($nmappletstatus)" \
    "Printer ($printerstatus)" \
    "Avahi Service/Socket ($avahiserstatus/$avahisocstatus)" \
    "Bluetooth ($bluetoothstatus)" \
    "ModemManager ($modemmanagerstatus)" \
    "Firewall ($firewallstatus)" \
    "Conky ($conkystatus)" | rofi -dmenu -i -p "") in
"Authentication Agent"*) polkitservice ;;
"VPN"*) vpn ;;
"Netzwerk Manager"*) nmappletservice ;;
"Printer"*) printerservice ;;
"Avahi Service/Socket"*) avahiservice ;;
"Bluetooth"*) bluetoothservice ;;
"ModemManager"*) modemmanagerservice ;;
"Firewall"*) firewallservice ;;
"Conky"*) conky.sh ;;
esac
