#!/usr/bin/env bash

# path:       ~/projects/shell/stopwatch.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-16T23:23:46+0100

script=$(basename "$0")
help="$script [-h/--help] -- script to measure the time
  Usage:
    $script

  Keys:
    Start/Stop: space
    Quit:       q"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$help"
    exit 0
else

stat=2
t_stop=0
t_now=0
t_index=0

set_t_now(){
    t_now=$(date +%s%N)
}

stopwatch() {
    t="$1"
    s=$(printf "%1d\n" "${t: 0 : -9}")
    ns=${t: -9 : 9 }
    printf '\r%s' "$(TZ=UTC date -d"@$s.$ns" +%H:%M:%S.%N)"
}

run(){
    t_stop=$((t_now - t_index))
    stopwatch $t_stop
}

reset(){
    set_t_now
    t_index=$t_now
}

read_cmd(){
    last=$1
    read -r -s -t0.1 -N1 key;
    case "$stat" in
        1) [ "$key" = $'\x20' ] && printf "\n" && return 2 ;;
        2) [ "$key" = $'\x20' ] && return 1 ;;
    esac
    return "$last";
}

stat=2
clear
echo "Start/Stop: space"
echo -e "Quit:       q\n"

while [ ! "$key" = "q" ]
do
    set_t_now
    case "$stat" in
        1) run ;;
        2) reset ;;
    esac
    read_cmd $stat
    stat=$?
    sleep 0.1
done

fi
