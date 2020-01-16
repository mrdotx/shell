#!/usr/bin/env bash

# path:       ~/projects/shell/stopwatch.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-17T00:57:44+0100

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

clear
printf " Start/Stop: space\n Quit:       q    \n\n"

t_stop=0
t_now=0
t_idx=0
stat=2
n=1

set_t_now(){
    t_now=$(date +%s%N)
}

stopwatch() {
    t="$1"
    s=$(printf "%1d\n" "${t: 0 : -9}")
    ns=${t: -9 : 9 }
    printf "\r%s" " $n) $(TZ=UTC date -d"@$s.$ns" +%H:%M:%S.%N)"
}

run(){
    t_stop=$((t_now-t_idx))
    stopwatch $t_stop
}

reset(){
    set_t_now
    t_idx=$t_now
}

read_key(){
    last=$1
    read -r -s -t.1 -N1 key;
    case "$stat" in
        1) [ "$key" = $'\x20' ] && printf "\n" && n=$((n+1)) && return 2 ;;
        2) [ "$key" = $'\x20' ] && return 1 ;;
    esac
    return "$last";
}

while [ ! "$key" = "q" ]
do
    set_t_now
    case "$stat" in
        1) run ;;
        2) reset ;;
    esac
    read_key $stat
    stat=$?
    sleep .1
done

fi
