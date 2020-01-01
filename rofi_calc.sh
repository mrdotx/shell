#!/bin/sh

# path:       ~/projects/shell/rofi_calc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-02 00:18:17

script=$(basename "$0")
help="$script [-h/--help] -- script to run bc calculations in rofi
  Usage:
    $script [calculation]

  Setting:
    [calculation] = all operators from bc can be used to calculate

  Examples:
    $script \"0+2\"
    $script \"(2+4)*5\"
    $script \"5^7\"
    $script \"sqrt(7)\"
    $script \"c(8)\""

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$help"
    exit 0
else
    menu="rofi -monitor -2 -theme klassiker-vertical -dmenu -l 3"
    result=$(echo "$@" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    chosen=$(printf "Copy to clipboard\nClear\nClose" | $menu -p "= $result")
    case $chosen in
        "Copy to clipboard") echo "$result" | xsel -b \
            && notify-send -i "$HOME/projects/shell/icons/clipboard.png" "Clipboard" "Result copied: $result" ;;
        "Clear") $0 ;;
        "Close") ;;
        "") ;;
        *) $0 "$result $chosen" ;;
    esac
fi
