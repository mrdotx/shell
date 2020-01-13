#!/bin/sh

# path:       ~/projects/shell/rofi_display.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:16:05+0100

# exit if rofi is running
pgrep -x rofi && exit

# second display
sec_disp() {
    mirror=$(printf "no\\nyes" | rofi -monitor -1 -lines 2 -theme klassiker-center -dmenu -i -p "Mirror displays?")
    if [ "$mirror" = "yes" ]; then
        ext=$(echo "$disp" | rofi -monitor -1 -lines 2 -theme klassiker-center -dmenu -i -p "Optimize resolution for:")
        int=$(echo "$disp" | grep -v "$ext")

        res_external=$(xrandr --query | sed -n "/^$ext/,/\+/p" | tail -n 1 | awk '{print $1}')
        res_internal=$(xrandr --query | sed -n "/^$int/,/\+/p" | tail -n 1 | awk '{print $1}')

        res_ext_x=$(echo "$res_external" | sed 's/x.*//')
        res_ext_y=$(echo "$res_external" | sed 's/.*x//')
        res_int_x=$(echo "$res_internal" | sed 's/x.*//')
        res_int_y=$(echo "$res_internal" | sed 's/.*x//')

        scale_x=$(echo "$res_ext_x / $res_int_x" | bc -l)
        scale_y=$(echo "$res_ext_y / $res_int_y" | bc -l)

        xrandr --output "$ext" --auto --scale 1.0x1.0 --output "$int" --auto --same-as "$ext" --scale "$scale_x"x"$scale_y"
    else
        pri=$(echo "$disp" | rofi -monitor -1 -lines 2 -theme klassiker-center -dmenu -i -p "Select primary display:")
        sec=$(echo "$disp" | grep -v "$pri")
        direction=$(printf "right\\nleft" | rofi -monitor -1 -lines 2 -theme klassiker-center -dmenu -i -p "What side of $pri should $sec be on?")
        xrandr --output "$pri" --auto --scale 1.0x1.0 --output "$sec" --"$direction"-of "$pri" --auto --scale 1.0x1.0
    fi
}

# saved arandr settings
saved_set() {
    chosen=$(find "$HOME/.screenlayout/" -iname "*.sh" | cut -d / -f 5 | sed "s/.sh//g" | sort | rofi -monitor -1 -lines 6 -theme klassiker-center -dmenu -i -p "")
    "$HOME/.screenlayout/$chosen.sh"
}

# get disp
all=$(xrandr -q | grep "connected")
disp=$(echo "$all" | grep " connected" | awk '{print $1}')

# menu
chosen=$(printf "saved settings\\nsecond display\\n%s\\nmanual selection\\naudio toggle" "$disp" | rofi -monitor -1 -lines 6 -theme klassiker-center -dmenu -i -p "") && \
    case "$chosen" in
    "saved settings") saved_set ;;
    "second display") sec_disp ;;
    "manual selection") arandr ;;
    "audio toggle") audio.sh -tog;;
    *) eval xrandr --output "$chosen" --auto --scale 1.0x1.0 "$(echo "$all" | grep -v "$chosen" | awk '{print "--output", $1, "--off"}' | tr '\n' ' ')" ;;
    esac

# maintenance after setup display
if [ -n "$chosen" ] && ! [ "$chosen" = "audio toggle" ]; then
    nitrogen --restore
    polybar.sh
fi
