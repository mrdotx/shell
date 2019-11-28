#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofi_calc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 13:56:07

if [[ $1 == "-h" || $1 == "--help" ]]; then
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
    chosen=$(echo -e "Copy to clipboard\nClear\nClose" | $menu -p "= $result")
    case $chosen in
        "Copy to clipboard") echo -n "$result" | xclip -selection clipboard && notify-send -i "$HOME/coding/shell/icons/clipboard.png" "Clipboard" "Result copied: $result" ;;
        "Clear") $0 ;;
        "Close") ;;
        "") ;;
        *) $0 "$result $chosen" ;;
    esac
fi
