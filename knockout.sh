#!/bin/sh

# path:       ~/projects/shell/knockout.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-04 15:59:21

script=$(basename "$0")
help="$script [-h/--help] -- script for \"knockout\" the system
  Usage:
    $script [-lock/-suspend/-logout/-reboot/-shutdown/-switch] [lockmethod]

  Settings:
    [-lock]         = lock the screen with [lockmethod]
    [-suspend]      = suspend or suspend with [lockmethod]
    [-logout]       = logout from current session
    [-reboot]       = reboot the system
    [-shutdown]     = shutdown the system
    [-switch]       = switch user
    [lockmethod]    = method to lock the screen
      blur          = blured screenshot of the desktop
      simple        = single color with message

  Examples:
    $script -lock blur
    $script -lock simple
    $script -suspend
    $script -suspend blur
    $script -suspend simple
    $script -logout
    $script -reboot
    $script -shutdown
    $script -switch"

# suckless simple lock
lock_simple ()
{
    # slock message "locked [user] at [date]"
    slock -m "locked $(whoami) at $(date "+%a %d.%m.%Y %k:%M")" &
}

# take screenshot, blur it and lock the screen with i3lock
lock_blur ()
{
    # take screenshot
    scrot -o /tmp/screenshot.png

    # blur it
    #convert -scale 10% -blur 0x0.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # more blur but faster
    convert -scale 10% -blur 0x2.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # lock the screen
    i3lock -i /tmp/screenshot_blur.png
}

case "$1" in
    -lock)
        if [ "$2" = "blur" ]; then
            lock_blur
            exit 0
        elif [ "$2" = "simple" ]; then
            lock_simple
            exit 0
        else
            echo "$help"
            exit 0
        fi
        ;;
    -suspend)
        if [ -z "$2" ]; then
            systemctl suspend
            exit 0
        elif [ "$2" = "blur" ]; then
            lock_blur && systemctl suspend
            exit 0
        elif [ "$2" = "simple" ]; then
            lock_simple && systemctl suspend
            exit 0
        else
            echo "$help"
            exit 0
        fi
        ;;
    -logout)
        i3-msg exit
        ;;
    -reboot)
        systemctl reboot
        ;;
    -shutdown)
        systemctl poweroff
        ;;
    -switch)
        dm-tool switch-to-greeter
        ;;
    *)
        echo "$help"
        exit 0
esac
exit 0
