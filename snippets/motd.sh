#!/usr/bin/env bash

# path:       ~/projects/shell/snippets/motd.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:51:20

# functions {{{
color() {
    echo "\e[$1m$2\e[0m"
}

extend() {
    str="$1"
    (( spaces=60-${#1} ))
    while [ $spaces -gt 0 ]; do
        str="$str "
        (( spaces=spaces-1 ))
    done
    echo "$str"
}

center() {
    str="$1"
    (( spacesLeft=(78-${#1})/2 ))
    (( spacesRight=78-spacesLeft-${#1} ))
    while [ $spacesLeft -gt 0 ]; do
        str=" $str"
        (( spacesLeft=spacesLeft-1 ))
    done

    while [ $spacesRight -gt 0 ]; do
        str="$str "
        (( spacesRight=spacesRight-1 ))
    done

    echo "$str"
}

logoCenter() {
    str="$1"
    (( spacesLeft=(60-${#1})/2 ))
    (( spacesRight=60-spacesLeft-${#1} ))
    while [ $spacesLeft -gt 0 ]; do
        str=" $str"
        (( spacesLeft=spacesLeft-1 ))
    done

    while [ $spacesRight -gt 0 ]; do
        str="$str "
        (( spacesRight=spacesRight-1 ))
    done

    echo "$str"
}

sec2time() {
    input=$1

    if [ "$input" -lt 60 ]; then
        echo "$input seconds"
    else
        (( days=input/86400 ))
        (( input=input%86400 ))
        (( hours=input/3600 ))
        (( input=input%3600 ))
        (( mins=input/60 ))

        daysPlural="s"
        hoursPlural="s"
        minsPlural="s"

        if [ $days -eq 1 ]; then
            daysPlural=""
        fi

        if [ $hours -eq 1 ]; then
            hoursPlural=""
        fi

        if [ $mins -eq 1 ]; then
            minsPlural=""
        fi

        echo "$days day$daysPlural, $hours hour$hoursPlural, $mins minute$minsPlural"
    fi
}
# }}}

# colors {{{
borderColor="0;34"
headerXtogoColor="1;36"
greetingsColor="1;32"
statsLabelColor="1;33"
# }}}

# border {{{
borderLine="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
borderTopLine=$(color $borderColor "┏$borderLine┓")
borderBottomLine=$(color $borderColor "┗$borderLine┛")
borderBar=$(color $borderColor "┃")
borderEmptyLine="$borderBar                                                                              $borderBar"
# }}}

# greetings {{{
me=$(whoami)
greetings="$(color $greetingsColor "$(logoCenter "Willkommen zurück, $me!")")"
greetingsDate="$(color $greetingsColor "$(logoCenter "$(date +"%a, %d %B %Y, %T")")")"
greetingsKernel="$(color $greetingsColor "$(logoCenter "$(uname -r -m)")")"
greetingsKernelVersion="$(color $greetingsColor "$(logoCenter "$(uname -v)")")"
# }}}

# header {{{
header="$borderTopLine\n"
header="$header$borderBar$(color $headerXtogoColor "   ___        ___                                                             ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "   \  \      /  /  __                                .___                     ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "    \  \    /  / _/  |_  ____   ____   ____        __| _/____                 ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "     \  \  /  /  \   __\/  _ \ / ___\ /  _ \      / __ |/ __ \                ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "      \  \/  /    |  | (  <_> ) /_/  >  <_> )    / /_/ \  ___/                ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "       >    <     |__|  \____/\___  / \____/  /\ \____ |\___  >               ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "      /  /\  \               /_____/          \/      \/    \/                ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "     /  /  \  \                                                               ")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "    /  /    \  \  $greetings")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "   /__/      \_ \ $greetingsDate")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "               \/ $greetingsKernel")$borderBar\n"
header="$header$borderBar$(color $headerXtogoColor "                  $greetingsKernelVersion")$borderBar\n"
header="$header$borderBottomLine"
# }}}

# system information {{{
read -r loginFrom loginIP loginMonth loginDay loginTime loginYear <<<"$(last "$me" -w -F -d | awk 'NR==2 { print $2,$3,$5,$6,$7,$8 }')"
loginDate="$(date -d "$loginMonth $loginDay $loginTime $loginYear" -Ins)"
# }}}

# tty login {{{
if [[ $loginDate == - ]]; then
    loginDate=$loginIP
    loginIP=$loginFrom
fi

if [[ $loginDate == *T* ]]; then
    login="$(date -d "$loginDate" +"%a, %d %B %Y, %T") [$loginIP]"
else
    # not enough logins
    login="None"
fi
# }}}

# labels {{{
label1="$(extend "$login")"
label1="$borderBar  $(color $statsLabelColor "Last Login....:") $label1$borderBar"

uptime="$(sec2time "$(cut -d "." -f 1 /proc/uptime)")"
uptime="$uptime [$(date -d "@""$(grep btime /proc/stat | cut -d " " -f 2)" +"%d-%m-%Y %H:%M:%S")]"

label2="$(extend "$uptime")"
label2="$borderBar  $(color $statsLabelColor "Uptime........:") $label2$borderBar"

label3="$(extend "$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB, Cached: %sMB",$2,$3,$4,$7; }')")"
label3="$borderBar  $(color $statsLabelColor "Memory........:") $label3$borderBar"

label4="$(extend "$(free -m | awk 'NR==3 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')")"
label4="$borderBar  $(color $statsLabelColor "Swap..........:") $label4$borderBar"

label5="$(extend "$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB, Utilized: %s",$2,$3,$4,$5; }')")"
label5="$borderBar  $(color $statsLabelColor "Home space....:") $label5$borderBar"

label6="$(extend "$(df -h /dev/sda1 | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB, Utilized: %s",$2,$3,$4,$5; }')")"
label6="$borderBar  $(color $statsLabelColor "EFI space.....:") $label6$borderBar"

label7="$(extend "CPU: $(echo $(($(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) / 1000)))MHz, Temp: $(cat /sys/class/thermal/thermal_zone0/temp | cut -c "1-2")ºC")"
label7="$borderBar  $(color $statsLabelColor "System:.......:") $label7$borderBar"

#label8="$(extend "$($HOME/projects/shell/snippets/hera.sh status)")"
#label8="$borderBar  $(color $statsLabelColor "NAS...........:") $label8$borderBar"

#label9="$(extend "$($HOME/projects/shell/snippets/host_status.sh elysion) [elysion]                                           ")"
#label9="$borderBar  $(color $statsLabelColor "BACKUP........:") $label12$borderBar"

stats="$label1\n$label2\n$label3\n$label4\n$label5\n$label6\n$label7"
# }}}

# print motd {{{
echo -e "$header\n$borderTopLine\n$stats\n$borderBottomLine"
# }}}
