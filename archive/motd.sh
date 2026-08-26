#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/motd.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-08-26T03:49:32+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# config
me=$(whoami)
date_format="%d.%m.%Y %H:%M:%S"

# layout functions
color() {
    printf "\033[%sm%s\033[0m" "$1" "$2"
}

extend() {
    str="$1"
    spaces=$((57-${#1}))
    while [ $spaces -gt 0 ]; do
        str="$str "
        spaces=$((spaces-1))
    done
    printf "%s" "$str"
}

center() {
    str="$1"
    width=${2:-78}
    spaces_left=$(((width-${#1})/2))
    spaces_right=$((width-spaces_left-${#1}))
    while [ $spaces_left -gt 0 ]; do
        str=" $str"
        spaces_left=$((spaces_left-1))
    done

    while [ $spaces_right -gt 0 ]; do
        str="$str "
        spaces_right=$((spaces_right-1))
    done

    printf "%s" "$str"
}

# uptime
sec2time() {
    input=$1

    if [ "$input" -lt 60 ]; then
        printf "%s seconds" "$input"
    else
        days=$((input/86400))
        input=$((input%86400))
        hours=$((input/3600))
        input=$((input%3600))
        mins=$((input/60))

        [ $days -ne 1 ] \
            && days_plural="s"

        [ $hours -ne 1 ] \
            && hours_plural="s"

        [ $mins -ne 1 ] \
            && mins_plural="s"

        printf "%s day%s, %s hour%s, %s minute%s" \
            "$days" \
            "$days_plural" \
            "$hours" \
            "$hours_plural" \
            "$mins" \
            "$mins_plural"
    fi
}

uptime_long() {
    printf "%s [%s]" \
        "$(sec2time "$(cut -d "." -f 1 /proc/uptime)")" \
        "$(date -d "@""$(grep btime /proc/stat | cut -d " " -f 2)" +"$date_format")"
}

# tty login
tty_login() {
    read -r login_from login_ip login_month login_day login_time login_year << EOF
        $(last "$me" -w -F -d | awk 'NR==2 { print $2,$3,$5,$6,$7,$8 }')
EOF

    login_date="$(date -d "$login_month $login_day $login_time $login_year" -Ins)"

    case $login_date in
        -)
            login_date=$login_ip
            login_ip=$login_from
            ;;
    esac

    case $login_date in
        *T*)
            login="$(date -d "$login_date" +"$date_format") [$login_ip]"
            ;;
        *)
            # not enough logins
            login="None"
            ;;
    esac

    printf "%s" "$login"
}

# memory
memory() {
    case $1 in
        swap)
            free -m \
                | awk 'NR==3 { printf "total %sMB, used %sMB, free %sMB",$2,$3,$4; }'
            ;;
        *)
            free -m \
                | awk 'NR==2 { printf "total %sMB, used %sMB, free %sMB, cached %sMB",$2,$3,$4,$7; }'
            ;;
    esac
}
# space
space() {
    df -h "$1" \
        | awk 'NR==2 { printf "total %sB, used %sB, free %sB, utilized %s",$2,$3,$4,$5; }'
}

# cpu
cpu() {
    printf "cpu %sMHz, temp %s'C" \
        "$(($(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) / 1000))" \
        "$(cut -c "1-2" /sys/class/hwmon/hwmon0/temp1_input)"
}

# alive
alive() {
    ping -c1 -W1 -q "$1" >/dev/null 2>&1 \
        && printf "online" \
        && return

    printf "offline"
}

# colors
border_color="0;34"
header_logo_color="1;36"
greetings_color="1;32"
stats_label_color="1;33"

# border
border_line="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
border_top_line=$(color $border_color "┏$border_line┓")
border_bottom_line=$(color $border_color "┗$border_line┛")
border_bar=$(color $border_color "┃")
border_empty_line="$border_bar                                                                      $border_bar"

# greetings
greetings="$(color $greetings_color "$(center "Welcome back, $me!" 55)")"
greetings_date="$(color $greetings_color "$(center "$(date +"$date_format")" 55)")"
greetings_kernel="$(color $greetings_color "$(center "$(uname -r -m)" 55)")"
greetings_kernel_version="$(color $greetings_color "$(center "$(uname -v)" 55)")"

# header
header="$border_top_line\n"
header="$header$border_bar$(color $header_logo_color "                   .___      __                                       ")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "   ____________  __| _/_____/  |____  ___                             ")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "  /     \_  __ \/ __ |/  _ \   __\  \/  /                             ")$border_bar\n"
header="$header$border_bar$(color $header_logo_color " |  Y Y  \  | \/ /_/ (  <_> )  |  >    <                              ")$border_bar\n"
header="$header$border_bar$(color $header_logo_color " |__|_|  /__|  \____ |\____/|__| /__/\_ \                             ")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "       \/           \/                 \/                             ")$border_bar\n"
header="$header$border_empty_line\n"
header="$header$border_bar$(color $header_logo_color "               $greetings")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "               $greetings_date")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "               $greetings_kernel")$border_bar\n"
header="$header$border_bar$(color $header_logo_color "               $greetings_kernel_version")$border_bar\n"
header="$header$border_bottom_line"

# labels
label1="$border_bar $(color $stats_label_color "Last Login:") $(extend "$(tty_login)")$border_bar"
label2="$border_bar $(color $stats_label_color "Uptime....:") $(extend "$(uptime_long)")$border_bar"
label3="$border_bar $(color $stats_label_color "Memory....:") $(extend "$(memory)")$border_bar"
label4="$border_bar $(color $stats_label_color "Swap......:") $(extend "$(memory swap)")$border_bar"
label5="$border_bar $(color $stats_label_color "Boot......:") $(extend "$(space /boot)")$border_bar"
label6="$border_bar $(color $stats_label_color "Home......:") $(extend "$(space /home)")$border_bar"
label7="$border_bar $(color $stats_label_color "System....:") $(extend "$(cpu)")$border_bar"

stats="$label1\n$label2\n$label3\n$label4\n$label5\n$label6\n$label7"

# main
printf "%b\n%b\n%b\n%b\n" "$header" "$border_top_line" "$stats" "$border_bottom_line"
