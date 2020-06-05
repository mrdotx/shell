#!/usr/bin/env sh

# path:       /home/klassiker/.local/share/repos/shell/terminal_colors.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-05T18:08:20+0200

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
    opt="bcgt"
else
    case "$1" in
        -*)
            opt="$1"
            ;;
        *)
            printf "%s\n" "$help"
            exit 0
            ;;
    esac
fi

plot(){
    if [ -z "$num" ]; then
        printf "\033[48;5;%sm %3d \033[0m" "$1" "$1"
    else
        printf "\033[48;5;%sm     \033[0m" "$1"
    fi
}

base(){
    s_col=0
    e_col=15
    while [ "$s_col" -le "$e_col" ]; do
        plot "$s_col"
        n=$((s_col-7))
        if [ $((n%8)) -eq 0 ]; then
                printf "\n"
            fi
        s_col=$((s_col+1))
    done
}

color(){
    s_col=16
    e_col=231
    blk=$(($(tput cols)/30))
    if [ "$blk" -ge 6 ]; then
        blk=6
    elif [ "$blk" -ge 3 ]; then
        blk=3
    fi
    column_num=$((blk*6))
    column_counter=0
    while [ "$s_col" -le "$e_col" ]; do
        plot "$s_col"
        s_col=$((s_col+1))
        column_counter=$((column_counter+1))
        if [ "$column_counter" -eq "$column_num" ]; then
            n=$((s_col-16))
            if [ $((n%36)) -ne 0 ]; then
                n=$((blk-1))
                s_col=$((s_col-n*36))
            fi
            column_counter=0
            printf "\n"
        elif [ $((column_counter%6)) -eq 0 ] && [ $((s_col+30)) -le "$e_col" ]; then
                s_col=$((s_col+30))
        fi
    done
}

grey(){
    s_col=232
    e_col=255
    blk=$(($(tput cols)/30))
    if [ "$blk" -ge 4 ]; then
        blk=4
    elif [ "$blk" -ge 2 ]; then
        blk=2
    fi
    while [ "$s_col" -le "$e_col" ]; do
        plot "$s_col"
        n=$((s_col-15))
        m=$((blk*6))
        if [ $((n%m)) -eq 0 ]; then
                printf "\n"
            fi
        s_col=$((s_col+1))
    done
}

t_color(){
    awk -v col_qty=$(($(tput cols)*24)) 'BEGIN{
        s="/\\";
        for (col = 0; col<col_qty; col++) {
            r = 255-(col*255/col_qty);
            g = (col*510/col_qty);
            b = (col*255/col_qty);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,col%2+1,1);
        }
        printf "\n";
    }'
}

out(){
    [ -z "${opt##*$1*}" ] \
    && if [ -z "$head" ]; then
        printf ":: %s\n" "$3"
        "$2"
    else
        "$2"
    fi
    return 0
}

[ -z "${opt##*n*}" ] \
    && num=0
[ -z "${opt##*h*}" ] \
    && head=0

out "b" "base" "base colors"
out "c" "color" "color palette"
out "g" "grey" "greyscale"
out "t" "t_color" "true colors"
