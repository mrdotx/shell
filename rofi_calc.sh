#!/bin/sh

# path:       ~/coding/shell/rofi_calc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 14:01:54

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage:"
    echo "  roficalc.sh [calculation]"
    echo
    echo "calculation:"
    echo "  all operators from bc can be used"
    echo
    echo "Example:"
    echo "  roficalc.sh \"1+2\""
    echo "  roficalc.sh \"(3+4)*5\""
    echo "  roficalc.sh \"6^7\""
    echo "  roficalc.sh \"sqrt(8)\""
    echo "  roficalc.sh \"c(9)\""
    echo
    exit 0
else
    menu="$(command -v rofi) -monitor -2 -theme klassiker-vertical -dmenu -l 3"
    result=$(echo "$@" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    chosen=$(printf "Copy to clipboard\nClear\nClose" | $menu -p "= $result")
    case $chosen in
        "Copy to clipboard") echo "$result" | xclip -selection clipboard && \
            notify-send -i "$HOME/coding/shell/icons/clipboard.png" "Clipboard" "Result copied: $result" ;;
        "Clear") $0 ;;
        "Close") ;;
        "") ;;
        *) $0 "$result $chosen" ;;
    esac
fi
