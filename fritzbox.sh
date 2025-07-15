#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/fritzbox.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-07-15T05:16:25+0200

# config
default_ip="10.10.10.10"
max_down=150
max_up=30

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

bar_percent() {
    percent=$( \
        [ "$1" = "?.?" ] && printf "0" && return
        printf "%.0f" "$1"
    )

    max=20

    bar_draw() {
        quantity="$1"
        while [ "$quantity" -gt 0 ]; do
            printf "%b%s" "$2" "■"
            quantity=$((quantity - 1))
        done
    }

    [ "$percent" -gt 100 ] && percent=100
    [ "$percent" -lt 0 ] && percent=0
    positive=$((percent * max / 100))
    negative=$((max - positive))

    bar_draw "$positive" "$2"
    bar_draw "$negative" "$3"
    printf "%b" "$reset"
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
        # color variables
        reset="\033[0m"
        bold="\033[1m"
        black="\033[30m"
        red="\033[31m"
        green="\033[32m"

        data=$(soap_igdupnp "${2:-$default_ip}" \
            "WANCommonIFC1" "WANCommonInterfaceConfig" "GetAddonInfos"
        )

        rate_up=$(xml_value "NewByteSendRate" "$data")
        rate_down=$(xml_value "NewByteReceiveRate" "$data")
        total_up=$(xml_value "NewX_AVM_DE_TotalBytesSent64" "$data")
        total_down=$(xml_value "NewX_AVM_DE_TotalBytesReceived64" "$data")
        percent_up="$(bit_percent "$rate_up" "$max_up")"
        percent_down="$(bit_percent "$rate_down" "$max_down")"

        printf "%s %s%% %s %b%b↑%b %s %s\n%s %s%% %s %b%b↓%b %s %s\n" \
                "$(bit_seconds "$rate_up")" \
                "$percent_up" \
                "$(bar_percent "$percent_up" "$bold$red" "$bold$black")" \
                "$bold" "$red" "$reset" \
                "$(byte_total "$total_up")" \
                "$(byte_seconds "$rate_up")" \
                "$(bit_seconds "$rate_down")" \
                "$percent_down" \
                "$(bar_percent "$percent_down" "$bold$green" "$bold$black")" \
                "$bold" "$green" "$reset" \
                "$(byte_total "$total_down")" \
                "$(byte_seconds "$rate_down")" \
            | column --table --table-noheadings --output-separator " " \
                --table-column right,width=6 \
                --table-column right \
                --table-column right,width=6 \
                --table-column right \
                --table-column right \
                --table-column right,width=3 \
                --table-column right \
                --table-column right,width=4 \
                --table-column right
        ;;
    -r | --reboot)
        # the ip is always required to prevent an accidental reboot
        soap_upnp "$2" "deviceconfig" "DeviceConfig" "Reboot"
        ;;
    -t | --termination)
        soap_igdupnp "${2:-$default_ip}" \
            "WANIPConn1" "WANIPConnection" "ForceTermination"
        ;;
    *)
        watch --color --no-title --interval 5 "$0" --info "${1:-$default_ip}"
        ;;
esac
