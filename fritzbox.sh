#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/fritzbox.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-07-11T05:46:18+0200

# config
url="http://10.10.10.10:49000"
max_down=150
max_up=30

# helper
soap_igdupnp() {
    curl -fs "$url/igdupnp/control/$1" \
        -H 'Content-Type:text/xml' \
        -H "SoapAction:urn:schemas-upnp-org:service:$2:1#$3" \
        -d "<?xml?><s:Envelope xmlns:s=''><s:Body><u:$3/></s:Body></s:Envelope>"
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

conv() {
    [ -z "$1" ] && printf "? %s" "$3" && exit 1

    [ "$1" -le "$2" ] && printf "0 %s" "$3" && exit
    [ "$1" -le "$4" ] && printf "%.0f %s" "$(calc "$1 / $2")" "$3" && exit
    printf "%.1f %s" "$(calc "$1 / $4")" "$5"
}

bit_perc() {
    [ -z "$1" ] && printf "?.?%%" && exit 1

    printf "%.1f%%" "$(calc "$1 / ($2 * 131072 / 100)")"
}

bit_sec() {
    conv "$1" 128 "Kbit/s" 131072 "Mbit/s"
}

byte_sec() {
    conv "$1" 1000 "KB/s" 1000000 "MB/s"
}

byte_total() {
    conv "$1" 1000000 "MB" 1000000000 "GB"
}

# main
case "$1" in
    -4 | --ipv4)
        data=$(soap_igdupnp "WANIPConn1" "WANIPConnection" \
                "GetExternalIPAddress" \
        )

        xml_value "NewExternalIPAddress" "$data"
        ;;
    -6 | --ipv6)
        data=$(soap_igdupnp "WANIPConn1" "WANIPConnection" \
                "X_AVM_DE_GetExternalIPv6Address" \
        )

        xml_value "NewExternalIPv6Address" "$data"
        ;;
    -b | --bar)
        data=$(soap_igdupnp "WANCommonIFC1" "WANCommonInterfaceConfig" \
                "GetAddonInfos"
        )

        rate_down=$(xml_value "NewByteReceiveRate" "$data")
        rate_up=$(xml_value "NewByteSendRate" "$data")

        printf "↓%s ↑%s" \
            "$(bit_sec "$rate_down")" \
            "$(bit_sec "$rate_up")"
        ;;
    -i | --info)
        # color variables
        reset="\033[0m"
        bold="\033[1m"
        red="\033[31m"
        green="\033[32m"

        data=$(soap_igdupnp "WANCommonIFC1" "WANCommonInterfaceConfig" \
                "GetAddonInfos"
        )

        rate_down=$(xml_value "NewByteReceiveRate" "$data")
        rate_up=$(xml_value "NewByteSendRate" "$data")
        total_down=$(xml_value "NewX_AVM_DE_TotalBytesReceived64" "$data")
        total_up=$(xml_value "NewX_AVM_DE_TotalBytesSent64" "$data")

        printf "%s %s %b%b↑%b %s %s\n%s %s %b%b↓%b %s %s" \
                "$(bit_sec "$rate_up")" \
                "$(bit_perc "$rate_up" "$max_up")" \
                "$bold" "$red" "$reset" \
                "$(byte_total "$total_up")" \
                "$(byte_sec "$rate_up")" \
                "$(bit_sec "$rate_down")" \
                "$(bit_perc "$rate_down" "$max_down")" \
                "$bold" "$green" "$reset" \
                "$(byte_total "$total_down")" \
                "$(byte_sec "$rate_down")" \
            | column --table --table-noheadings --output-separator " " \
                --table-column right,width=6 \
                --table-column right \
                --table-column right,width=6 \
                --table-column right \
                --table-column right,width=3 \
                --table-column right \
                --table-column right,width=4 \
                --table-column right
        ;;
    *)
        watch --color --no-title --interval 1 "$0" --info
        ;;
esac
