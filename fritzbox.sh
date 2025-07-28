#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/fritzbox.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-07-28T04:59:59+0200

# config
default_ip="10.10.10.10"
max_down=150
max_up=30

# color variables
reset="\033[0m"
bold="\033[1m"
black="\033[30m"
red="\033[31m"
green="\033[32m"

# helper
soap_upnp() {
    # alternative authentication: --user "user:password" instead of --netrc
    curl -fs "https://$1:49443/upnp/control/$2" \
        --anyauth --netrc \
        -H 'Content-Type: text/xml"' \
        -H "SoapAction:urn:dslforum-org:service:$3:1#$4" \
        -d "<?xml?><s:Envelope xmlns:s=''><s:Body><u:$4/></s:Body></s:Envelope>"
}

soap_igdupnp() {
    curl -fs "http://$1:49000/igdupnp/control/$2" \
        -H 'Content-Type:text/xml' \
        -H "SoapAction:urn:schemas-upnp-org:service:$3:1#$4" \
        -d "<?xml?><s:Envelope xmlns:s=''><s:Body><u:$4/></s:Body></s:Envelope>"
}

xml_value() {
    filter="$1"
    shift

    printf "%s\n" "$*" \
        | grep "$filter" \
        | sed -e "s/<$filter>//" -e "s/<\/$filter>//"
}

calc() {
    printf "%s\n" "$*" | bc -l
}

convert_uptime() {
    [ -z "$1" ] && printf "?" && exit 1

    day="$(($1 / 60 / 60 / 24))"
    hour="$(($1 / 60 / 60 % 24))"
    min="$(($1 / 60 % 60))"
    sec="$(($1 % 60))"

    if [ $day -eq 0 ] && [ $hour -eq 0 ] && [ $min -eq 0 ]; then
        printf "%d second" "$sec"
        [ $sec -gt 1 ] && printf "s"
    else
        if [ $day -gt 0 ]; then
            printf "%d day" "$day"
            [ $day -gt 1 ] && printf "s"
            { [ $hour -gt 0 ] || [ $min -gt 0 ]; } && printf ", "
        fi
        if [ $hour -gt 0 ]; then
            printf "%d hour" "$hour"
            [ $hour -gt 1 ] && printf "s"
            [ $min -gt 0 ] && printf ", "
        fi
        if [ $min -gt 0 ]; then
            printf "%d minute" "$min"
            [ $min -gt 1 ] && printf "s"
        fi
    fi
}

convert_unit() {
    [ -z "$1" ] && printf "? %s" "$3" && exit 1

    [ "$1" -le "$2" ] && printf "0 %s" "$3" && exit
    [ "$1" -le "$4" ] && printf "%.0f %s" "$(calc "$1 / $2")" "$3" && exit
    printf "%.1f %s" "$(calc "$1 / $4")" "$5"
}

byte_total() {
    convert_unit "$1" 1000000 "MB" 1000000000 "GB"
}

byte_seconds() {
    convert_unit "$1" 1000 "KB/s" 1000000 "MB/s"
}

bit_seconds() {
    convert_unit "$1" 128 "Kbit/s" 131072 "Mbit/s"
}

bit_percent() {
    [ -z "$1" ] && printf "?.?" && exit 1

    printf "%.1f" "$(calc "$1 / ($2 * 131072 / 100)")"
}

bar_draw() {
    quantity="$1"
    printf "%b" "$2"
    while [ "$quantity" -gt 0 ]; do
        printf "%b" "$3"
        quantity=$((quantity - 1))
    done
    printf "%b" "$reset"
}

bar_percent() {
    percent=$( \
        [ "$1" = "?.?" ] && printf "0" && return
        printf "%.0f" "$1"
    )

    width=20

    [ "$percent" -gt 100 ] && percent=100
    [ "$percent" -lt 0 ] && percent=0
    fill=$((percent * width / 100))
    indicator=1
    empty=$((width - fill))

    bar_draw "$((fill - indicator))" "$2" "$3"
    [ $fill -gt 0 ] && bar_draw "$indicator" "$4" "$5"
    bar_draw "$empty" "$6" "$7"
}

# main
case "$1" in
    -4 | --ipv4)
        data=$(soap_igdupnp "${2:-$default_ip}" \
            "WANIPConn1" "WANIPConnection" "GetExternalIPAddress" \
        )

        xml_value "NewExternalIPAddress" "$data"
        ;;
    -6 | --ipv6)
        data=$(soap_igdupnp "${2:-$default_ip}" \
            "WANIPConn1" "WANIPConnection" "X_AVM_DE_GetExternalIPv6Address" \
        )

        xml_value "NewExternalIPv6Address" "$data"
        ;;
    -b | --bar)
        data=$(soap_igdupnp "${2:-$default_ip}" \
            "WANCommonIFC1" "WANCommonInterfaceConfig" "GetAddonInfos"
        )

        rate_down=$(xml_value "NewByteReceiveRate" "$data")
        rate_up=$(xml_value "NewByteSendRate" "$data")

        printf "↓%s ↑%s\n" \
            "$(bit_seconds "$rate_down")" \
            "$(bit_seconds "$rate_up")"
        ;;
    -i | --info)
        data=$(soap_igdupnp "${2:-$default_ip}" \
            "WANCommonIFC1" "WANCommonInterfaceConfig" "GetAddonInfos"
        )

        rate_up=$(xml_value "NewByteSendRate" "$data")
        rate_down=$(xml_value "NewByteReceiveRate" "$data")
        total_up=$(xml_value "NewX_AVM_DE_TotalBytesSent64" "$data")
        total_down=$(xml_value "NewX_AVM_DE_TotalBytesReceived64" "$data")

        printf "%s %s %b %s %s\n%s %s %b %s %s\n" \
                "$(byte_seconds "$rate_up")" \
                "$(byte_total "$total_up")" \
                "$bold$red↑$reset" \
                "$(bar_percent "$(bit_percent "$rate_up" "$max_up")" \
                    "$bold$red" "■" "$bold$red" "■" "$bold$black" "■")" \
                "$(bit_seconds "$rate_up")" \
                "$(byte_seconds "$rate_down")" \
                "$(byte_total "$total_down")" \
                "$bold$green↓$reset" \
                "$(bar_percent "$(bit_percent "$rate_down" "$max_down")" \
                    "$bold$green" "■" "$bold$green" "■" "$bold$black" "■")" \
                "$(bit_seconds "$rate_down")" \
            | column --table --table-noheadings --output-separator " " \
                --table-column right,width=5 \
                --table-column right \
                --table-column right,width=3 \
                --table-column right \
                --table-column right \
                --table-column right \
                --table-column right,width=5 \
                --table-column right
        ;;
    -r | --reboot)
        # the ip is always required to prevent an accidental reboot
        soap_upnp "$2" "deviceconfig" "DeviceConfig" "Reboot"
        ;;
    -t | --terminate)
        soap_igdupnp "${2:-$default_ip}" \
            "WANIPConn1" "WANIPConnection" "ForceTermination"
        ;;
    -u | --uptime)
        data=$(soap_upnp "${2:-$default_ip}" \
            "deviceinfo" "DeviceInfo" "GetInfo")

        printf "uptime: %s\n" \
            "$(convert_uptime "$(xml_value "NewUpTime" "$data")")"
        ;;
    -x | --xml)
        # get soap description files (libxml2 required)
        for xml in \
            igddesc.xml igdicfgSCPD.xml igdconnSCPD.xml \
            tr64desc.xml deviceinfoSCPD.xml deviceconfigSCPD.xml; do
                xmllint "http://${2:-$default_ip}:49000/$xml" \
                    --format --output "$xml"
        done
        ;;
    *)
        watch --color --no-title --interval 5 "$0" --info "${1:-$default_ip}"
        ;;
esac
