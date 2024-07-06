#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/dynv6.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-07-05T16:09:34+0200

dynv6_config="$HOME/.local/share/repos/shell/dynv6.conf"
dynv6_folder="$HOME/.cache/dynv6/"
ipv6_netmask=128

config_values=$(grep -v -E '^#|^;|^$' "$dynv6_config")

get_config_value() {
    printf "%s" "$1" \
        | cut -d ";" -f"$2" \
        | tr -d ' '
}

get_interface_ipv6() {
    ip -6 addr list scope global \
        | grep -v " fd" \
        | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' \
        | head -n 1
}

push_dynv6() {
    url_ipv4="https://dynv6.com/api/update?zone=$1&token=$2&ipv4=$3"
    url_ipv6="https://dynv6.com/api/update?zone=$1&token=$2&ipv6=$4"
    ip_file="$dynv6_folder/$1"

    [ ! -e "$ip_file" ] \
        && touch "$ip_file"

    ipv4_old=$(head -n1 "$ip_file")
    ipv6_old=$(tail -n1 "$ip_file")

    if [ "$ipv4_old" != "$3" ] || [ "$ipv6_old" != "$4" ]; then \
            [ "$ipv4_old" != "$3" ] \
                && printf "%s ipv4 %s\n" "$1" "$(curl -fsS "$url_ipv4")"

            [ "$ipv6_old" != "$4" ] \
                && printf "%s ipv6 %s\n" "$1" "$(curl -fsS "$url_ipv6")"

            printf "%s\n%s" "$3" "$4" > "$ip_file"
    fi
}

printf "%s\n" "$config_values" \
    | while IFS= read -r line; do
        [ -n "$line" ] \
            && dynv6_zone=$(get_config_value "$line" 1) \
            && dynv6_token=$(get_config_value "$line" 2) \
            && dynv6_ipv4=$(get_config_value "$line" 3) \
            && dynv6_ipv6=$(get_config_value "$line" 4) \
            && case "$dynv6_ipv4" in
                fritzbox)
                    ipv4="$(fritzbox.sh --ipv4)"
                    ;;
                *)
                    ipv4="$dynv6_ipv4"
                    ;;
            esac \
            && case "$dynv6_ipv6" in
                fritzbox)
                    ipv6="$(fritzbox.sh --ipv6)/$ipv6_netmask"
                    ;;
                interface)
                    ipv6="$(get_interface_ipv6)/$ipv6_netmask"
                    ;;
                *)
                    ipv6="$dynv6_ipv6"
                    ;;
            esac \
            && push_dynv6 "$dynv6_zone" "$dynv6_token" "$ipv4" "$ipv6"
    done
