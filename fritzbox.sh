#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/fritzbox.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-07-04T21:48:35+0200

get_fritzbox_data() {
connection_state="
<?xml version='1.0' encoding='utf-8'?>
    <s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'
     s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'>
        <s:Body>
            <u:$3 xmlns:u='urn:schemas-upnp-org:service:$2:1' />
        </s:Body>
    </s:Envelope>
"

    curl -fsS "http://fritz.box:49000/igdupnp/control/$1" \
            -H "SoapAction:urn:schemas-upnp-org:service:$2:1#$3" \
            -H 'User-Agent: AVM UPnP/1.0 Client 1.0' \
            -H 'Content-Type: text/xml; charset="utf-8"' \
            -d "$connection_state"
}

get_value() {
    filter="$1"
    shift

    printf "%s\n" "$@" \
        | grep "$filter" \
        | sed -e "s/<$filter>//" -e "s/<\/$filter>//"
}

calc() {
    printf "%s\n" "$*" | bc -l
}

convert_bytes() {
    [ "$1" -le 1000 ] \
        && printf "0 KB/s" \
        && exit

    [ "$1" -le 1000000 ] \
        && printf "%.0f KB/s" "$(calc "$1 / 1000")" \
        && exit

    printf "%.1f MB/s" "$(calc "$1 / 1000000")"
}

convert_bits() {
    [ "$1" -le 128 ] \
        && printf "0 Kbit/s" \
        && exit

    [ "$1" -le 131072 ] \
        && printf "%.0f Kbit/s" "$(calc "$1 / 128")" \
        && exit

    printf "%.1f Mbit/s" "$(calc "$1 / 131072")"
}

case "$1" in
    --ipv4)
        data=$( \
            get_fritzbox_data \
                "WANIPConn1" \
                "WANIPConnection" \
                "GetExternalIPAddress" \
        )

        get_value "NewExternalIPAddress" "$data"
        ;;
    --ipv6)
        data=$( \
            get_fritzbox_data \
                "WANIPConn1" \
                "WANIPConnection" \
                "X_AVM_DE_GetExternalIPv6Address" \
        )

        get_value "NewExternalIPv6Address" "$data"
        ;;
    *)
        data=$( \
            get_fritzbox_data \
                "WANCommonIFC1" \
                "WANCommonInterfaceConfig" \
                "GetAddonInfos" \
        )

        byte_receive_rate=$(get_value "NewByteReceiveRate" "$data")
        byte_send_rate=$(get_value "NewByteSendRate" "$data")

        printf "↓%s ↑%s | ↓%s ↑%s\n" \
            "$(convert_bytes "$byte_receive_rate")" \
            "$(convert_bytes "$byte_send_rate")" \
            "$(convert_bits "$byte_receive_rate")" \
            "$(convert_bits "$byte_send_rate")"
        ;;
esac
