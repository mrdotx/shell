#!/usr/bin/env sh

# path:       /home/klassiker/.local/share/repos/shell/terminal_colors.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T13:59:07+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to show terminal colors
  Usage:
    $script [settings]

  Settings:
    without given settings will show all informations
    -b = base colors
    -c = color palette
    -g = greyscale
    -t = true colors
    -n = hide numbers
    -h = hide header

  Example:
    $script -bcg
    $script -t
    $script -bnh"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "%s\n" "$help"
    exit 0
fi

if [ $# -eq 0 ]; then
    option="bcgt"
else
    case "$1" in
        -*)
            option="$1"
            ;;
        *)
            printf "%s\n" "$help"
            exit 0
            ;;
    esac
fi

plot() {
    if [ -z "$num" ]; then
        printf "\033[48;5;%sm %3d \033[0m" "$1" "$1"
    else
        printf "\033[48;5;%sm     \033[0m" "$1"
    fi
}

base_color() {
    start_column=0
    end_column=15
    while [ "$start_column" -le "$end_column" ]; do
        plot "$start_column"
        n=$((start_column-7))
        if [ $((n%8)) -eq 0 ]; then
                printf "\n"
            fi
        start_column=$((start_column+1))
    done
}

color() {
    start_column=16
    end_column=231
    block=$(($(tput cols)/30))
    if [ "$block" -ge 6 ]; then
        block=6
    elif [ "$block" -ge 3 ]; then
        block=3
    fi
    column_num=$((block*6))
    column_counter=0
    while [ "$start_column" -le "$end_column" ]; do
        plot "$start_column"
        start_column=$((start_column+1))
        column_counter=$((column_counter+1))
        if [ "$column_counter" -eq "$column_num" ]; then
            n=$((start_column-16))
            if [ $((n%36)) -ne 0 ]; then
                n=$((block-1))
                start_column=$((start_column-n*36))
            fi
            column_counter=0
            printf "\n"
        elif [ $((column_counter%6)) -eq 0 ] && [ $((start_column+30)) -le "$end_column" ]; then
                start_column=$((start_column+30))
        fi
    done
}

greyscale() {
    start_column=232
    end_column=255
    block=$(($(tput cols)/30))
    if [ "$block" -ge 4 ]; then
        block=4
    elif [ "$block" -ge 2 ]; then
        block=2
    fi
    while [ "$start_column" -le "$end_column" ]; do
        plot "$start_column"
        n=$((start_column-15))
        m=$((block*6))
        if [ $((n%m)) -eq 0 ]; then
                printf "\n"
            fi
        start_column=$((start_column+1))
    done
}

true_color() {
    awk -v column_quantity=$(($(tput cols)*24)) 'BEGIN{
        s="/\\";
        for (column = 0; column<column_quantity; column++) {
            r = 255-(column*255/column_quantity);
            g = (column*510/column_quantity);
            b = (column*255/column_quantity);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,column%2+1,1);
        }
        printf "\n";
    }'
}

output() {
    [ -z "${option##*$1*}" ] \
    && if [ -z "$head" ]; then
        printf ":: %s\n" "$3"
        "$2"
    else
        "$2"
    fi
    return 0
}

[ -z "${option##*n*}" ] \
    && num=0
[ -z "${option##*h*}" ] \
    && head=0

output "b" "base_color" "base colors"
output "c" "color" "color palette"
output "g" "greyscale" "greyscale"
output "t" "true_color" "true colors"
