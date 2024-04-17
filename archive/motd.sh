#!/usr/bin/env bash

# path:   /home/klassiker/.local/share/repos/shell/archive/motd.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-16T17:45:48+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
me=$(whoami)

# layout functions
color() {
    printf "\e[%sm%s\e[0m" "$1" "$2"
}

extend() {
    str="$1"
    spaces=$((61-${#1}))
    while [ $spaces -gt 0 ]; do
        str="$str "
        spaces=$((spaces-1))
    done
    printf "%s" "$str"
}

center() {
    str="$1"
    width=${2:-78}
    spacesLeft=$(((width-${#1})/2))
    spacesRight=$((width-spacesLeft-${#1}))
    while [ $spacesLeft -gt 0 ]; do
        str=" $str"
        spacesLeft=$((spacesLeft-1))
    done

    while [ $spacesRight -gt 0 ]; do
        str="$str "
        spacesRight=$((spacesRight-1))
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
            && daysPlural="s"

        [ $hours -ne 1 ] \
            && hoursPlural="s"

        [ $mins -ne 1 ] \
            && minsPlural="s"

        printf "%s day%s, %s hour%s, %s minute%s" \
            "$days" \
            "$daysPlural" \
            "$hours" \
            "$hoursPlural" \
            "$mins" \
            "$minsPlural"
    fi
}

uptime_long() {
    printf "%s [%s]" \
        "$(sec2time "$(cut -d "." -f 1 /proc/uptime)")" \
        "$(date -d "@""$(grep btime /proc/stat | cut -d " " -f 2)" +"%d.%m.%Y %H:%M:%S")"
}

# tty login
tty_login() {
    read -r loginFrom loginIP loginMonth loginDay loginTime loginYear << EOF
        $(last "$me" -w -F -d | awk 'NR==2 { print $2,$3,$5,$6,$7,$8 }')
EOF

    loginDate="$(date -d "$loginMonth $loginDay $loginTime $loginYear" -Ins)"

    case $loginDate in
        -)
            loginDate=$loginIP
            loginIP=$loginFrom
            ;;
    esac

    case $loginDate in
        *T*)
            login="$(date -d "$loginDate" +"%a, %d %B %Y, %T") [$loginIP]"
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
                | awk 'NR==3 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }'
            ;;
        *)
            free -m \
                | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB, Cached: %sMB",$2,$3,$4,$7; }'
            ;;
    esac
}
# space
space() {
    df -h "$1" \
        | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB, Utilized: %s",$2,$3,$4,$5; }'
}

# cpu
cpu() {
    printf "CPU: %sMHz, TEMP: %s'C" \
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
borderColor="0;34"
headerXtogoColor="1;36"
greetingsColor="1;32"
statsLabelColor="1;33"

# border
borderLine="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
borderTopLine=$(color $borderColor "┏$borderLine┓")
borderBottomLine=$(color $borderColor "┗$borderLine┛")
borderBar=$(color $borderColor "┃")
borderEmptyLine="$borderBar                                                                              $borderBar"

# greetings
greetings="$(color $greetingsColor "$(center "Welcome back, $me!" 55)")"
greetingsDate="$(color $greetingsColor "$(center "$(date +"%a, %d %B %Y, %T")" 55)")"
greetingsKernel="$(color $greetingsColor "$(center "$(uname -r -m)" 55)")"
greetingsKernelVersion="$(color $greetingsColor "$(center "$(uname -v)" 55)")"

# header
header="$borderTopLine\n"
header="$header$borderBar$(color $headerXtogoColor "                   .___      __                                               ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "   ____________  __| _/_____/  |____  ___                                     ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "  /     \_  __ \/ __ |/  _ \   __\  \/  /                                     ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor " |  Y Y  \  | \/ /_/ (  <_> )  |  >    <                                      ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor " |__|_|  /__|  \____ |\____/|__| /__/\_ \                                     ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "       \/           \/                 \/                                     ")$borderBar\n"
header="$header$borderEmptyLine\n"
header="$header$borderBar$(color $headerXtogoColor "                       $greetings")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "                       $greetingsDate")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "                       $greetingsKernel")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "                       $greetingsKernelVersion")$borderBar\n"
header="$header$borderBottomLine"

# labels
label1="$borderBar $(color $statsLabelColor "Last Login....:") $(extend "$(tty_login)")$borderBar"
label2="$borderBar $(color $statsLabelColor "Uptime........:") $(extend "$(uptime_long)")$borderBar"
label3="$borderBar $(color $statsLabelColor "Memory........:") $(extend "$(memory)")$borderBar"
label4="$borderBar $(color $statsLabelColor "Swap..........:") $(extend "$(memory swap)")$borderBar"
label5="$borderBar $(color $statsLabelColor "Boot..........:") $(extend "$(space /boot)")$borderBar"
label6="$borderBar $(color $statsLabelColor "Home..........:") $(extend "$(space /home)")$borderBar"
label7="$borderBar $(color $statsLabelColor "System:.......:") $(extend "$(cpu)")$borderBar"

stats="$label1\n$label2\n$label3\n$label4\n$label5\n$label6\n$label7"

# main
printf "%b\n%b\n%b\n%b\n" "$header" "$borderTopLine" "$stats" "$borderBottomLine"
