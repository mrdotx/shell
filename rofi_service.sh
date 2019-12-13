#!/bin/sh

# path:       ~/coding/shell/rofi_service.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 00:55:49

# exit if rofi is running
pgrep -x rofi && exit

# polkit
polkit_ser() {
    polkit_app=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

    if [ "$(pgrep -f $polkit_app)" ]; then
        killall $polkit_app && \
            notify-send -i "$HOME/coding/shell/icons/polkit.png" "Polkit" "Gnome Authentication Agent stopped!" && exit 0
    else
        $polkit_app >/dev/null 2>&1 &
        notify-send -i "$HOME/coding/shell/icons/polkit.png" "Polkit" "Gnome Authentication Agent started!" && exit 0
    fi
}

# gestures
gestures_ser() {
    if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]; then
        libinput-gestures-setup stop && \
            notify-send -i "$HOME/coding/shell/icons/gestures.png" "Gestures" "Gestures stopped!" && exit 0
    else
        libinput-gestures-setup start >/dev/null 2>&1 && \
            notify-send -i "$HOME/coding/shell/icons/gestures.png" "Gestures" "Gestures started!" && exit 0
    fi
}

# vpn
vpn_name=hades
vpn() {
    if [ "$(nmcli connection show --active $vpn_name)" ]; then
        nmcli con down id $vpn_name && \
            notify-send -i "$HOME/coding/shell/icons/vpn.png" "VPN" "$vpn_name disconnected!" && exit 0
    else
        nmcli con up id $vpn_name passwd-file "$HOME"/coding/hidden/vpn/$vpn_name && \
            notify-send -i "$HOME/coding/shell/icons/vpn.png" "VPN" "$vpn_name connected!" && exit 0
    fi
}

# nmapplet
nmapplet_ser() {
    nmapplet_app=nm-applet

    if [ "$(pgrep $nmapplet_app)" ]; then
        killall $nmapplet_app && \
            notify-send -i "$HOME/coding/shell/icons/service.png" "Network Manager" "stopped!" && exit 0
    else
        $nmapplet_app >/dev/null 2>&1 &
        notify-send -i "$HOME/coding/shell/icons/service.png" "Network Manager" "started!" && exit 0
    fi
}

# printer
printer_ser() {
    if [ "$printer_stat" != "active" ]; then
        sudo -A systemctl start org.cups.cupsd.service && \
            notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Printer started!" && exit 0
    else
        sudo -A systemctl stop org.cups.cupsd.service && \
            notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Printer stopped!" && exit 0
    fi
}

# avahi
avahi_ser() {
    if [ "$avahi_ser_stat" != "active" ]; then
        sudo -A systemctl start avahi-daemon.service && \
            sudo -A systemctl start avahi-daemon.socket && \
            notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Avahi started!" && exit 0
    else
        sudo -A systemctl stop avahi-daemon.service && \
            sudo -A systemctl stop avahi-daemon.socket && \
            notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Avahi stopped!" && exit 0
    fi
}

# bluetooth
bluetooth_ser() {
    if [ "$bluetooth_stat" != "active" ]; then
        sudo -A systemctl start bluetooth.service && \
            notify-send -i "$HOME/coding/shell/icons/bluetooth.png" "Service" "Bluetooth started!" && exit 0
    else
        sudo -A systemctl stop bluetooth.service && \
            notify-send -i "$HOME/coding/shell/icons/bluetooth.png" "Service" "Bluetooth stopped!" && exit 0
    fi
}

# modemmanager
modemmanager_ser() {
    if [ "$modemmanager_stat" != "active" ]; then
        sudo -A systemctl start ModemManager.service && \
            notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "ModemManager started!" && exit 0
    else
        sudo -A systemctl stop ModemManager.service && \
            notify-send -i "$HOME/coding/shell/icons/service.png" "Service" "ModemManager stopped!" && exit 0
    fi
}

# firewall
firewall_ser() {
    if [ "$firewall_stat" != "active" ]; then
        sudo -A systemctl start ufw.service && \
            notify-send -i "$HOME/coding/shell/icons/firewall.png" "Service" "Firewall started!" && exit 0
    else
        sudo -A systemctl stop ufw.service && \
            notify-send -i "$HOME/coding/shell/icons/firewall.png" "Service" "Firewall stopped!" && exit 0
    fi
}

# status
polkit_stat=$(if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]; then echo "active"; else echo "inactive"; fi)
gestures_stat=$(if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]; then echo "active"; else echo "inactive"; fi)
vpn_stat=$(if [ "$(nmcli connection show --active $vpn_name)" ]; then echo "active"; else echo "inactive"; fi)
nmapplet_stat=$(if [ "$(pgrep nm-applet)" ]; then echo "active"; else echo "inactive"; fi)
printer_stat=$(systemctl is-active org.cups.cupsd.service)
avahi_ser_stat=$(systemctl is-active avahi-daemon.service)
avahi_soc_stat=$(systemctl is-active avahi-daemon.socket)
bluetooth_stat=$(systemctl is-active bluetooth.service)
modemmanager_stat=$(systemctl is-active ModemManager.service)
firewall_stat=$(systemctl is-active ufw.service)
conky_stat=$(if [ "$(pgrep -x conky)" ]; then echo "active"; else echo "inactive"; fi)

# menu
case $(printf "%s\n" \
    "Authentication Agent ($polkit_stat)" \
    "Gestures ($gestures_stat)" \
    "VPN $vpn_name ($vpn_stat)" \
    "Netzwerk Manager ($nmapplet_stat)" \
    "Printer ($printer_stat)" \
    "Avahi Service/Socket ($avahi_ser_stat/$avahi_soc_stat)" \
    "Bluetooth ($bluetooth_stat)" \
    "ModemManager ($modemmanager_stat)" \
    "Firewall ($firewall_stat)" \
    "Conky ($conky_stat)" | rofi -monitor -1 -dmenu -i -p "") in
        "Authentication Agent"*) polkit_ser ;;
        "Gestures"*) gestures_ser ;;
        "VPN"*) vpn ;;
        "Netzwerk Manager"*) nmapplet_ser ;;
        "Printer"*) printer_ser ;;
        "Avahi Service/Socket"*) avahi_ser ;;
        "Bluetooth"*) bluetooth_ser ;;
        "ModemManager"*) modemmanager_ser ;;
        "Firewall"*) firewall_ser ;;
        "Conky"*) conky.sh ;;
esac
