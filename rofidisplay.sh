#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/rofidisplay.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-13 12:31:17

# exit rofi if it's running
pgrep -x rofi && exit

# second display
seconddisplay() {
    mirror=$(printf "no\\nyes" | rofi -monitor primary -dmenu -i -p "Mirror displays?")
    if [ "$mirror" = "yes" ]; then
        external=$(echo "$displays" | rofi -monitor primary -dmenu -i -p "Optimize resolution for:")
        internal=$(echo "$displays" | grep -v "$external")

        res_external=$(xrandr --query | sed -n "/^$external/,/\+/p" | tail -n 1 | awk '{print $1}')
        res_internal=$(xrandr --query | sed -n "/^$internal/,/\+/p" | tail -n 1 | awk '{print $1}')

        res_ext_x=$(echo "$res_external" | sed 's/x.*//')
        res_ext_y=$(echo "$res_external" | sed 's/.*x//')
        res_int_x=$(echo "$res_internal" | sed 's/x.*//')
        res_int_y=$(echo "$res_internal" | sed 's/.*x//')

        scale_x=$(echo "$res_ext_x / $res_int_x" | bc -l)
        scale_y=$(echo "$res_ext_y / $res_int_y" | bc -l)

        xrandr --output "$external" --auto --scale 1.0x1.0 --output "$internal" --auto --same-as "$external" --scale "$scale_x"x"$scale_y"
    else
        primary=$(echo "$displays" | rofi -monitor primary -dmenu -i -p "Select primary display:")
        secondary=$(echo "$displays" | grep -v "$primary")
        direction=$(printf "right\\nleft" | rofi -monitor primary -dmenu -i -p "What side of $primary should $secondary be on?")
        xrandr --output "$primary" --auto --scale 1.0x1.0 --output "$secondary" --"$direction"-of "$primary" --auto --scale 1.0x1.0
    fi
}

# saved arandr settings
savedsettings() {
    chosen=$(find "$HOME"/.screenlayout/*.sh | cut -d / -f 5 | sed "s/.sh//g" | rofi -monitor primary -dmenu -i -p "")
    "$HOME"/.screenlayout/"$chosen".sh
}

# get displays
allposs=$(xrandr -q | grep "connected")
displays=$(echo "$allposs" | grep " connected" | awk '{print $1}')

# menu
chosen=$(printf "%s\\nsecond display\\nsaved settings\\nmanual selection" "$displays" | rofi -monitor primary -dmenu -i -p "") &&
    case "$chosen" in
    "second display") seconddisplay ;;
    "saved settings") savedsettings ;;
    "manual selection")
        arandr
        exit
        ;;
    *) xrandr --output "$chosen" --auto --scale 1.0x1.0 $(echo "$allposs" | grep -v "$chosen" | awk '{print "--output", $1, "--off"}' | tr '\n' ' ') ;;
    esac

# maintenance after setup displays
#nitrogen --restore
pgrep -x dunst >/dev/null && killall dunst &
polybar.sh
