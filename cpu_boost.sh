#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/cpu_boost.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-20T10:02:33+0100

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas"

script=$(basename "$0")
help="$script [-h/--help] -- script to toggle cpu indicators
  Usage:
    $script [--toggle/--status/--available]

  Settings:
    [--toggle] = switch between powersave and performance
    [--status] = shows status of governor and epp
    [--available] = shows available indicators of governor and epp

  Examples:
    $script --toggle
    $script --status
    $script --available"

case "$1" in
    --toggle)
        status=$($auth cpufreqctl --governor)
        # toggle powersave <-> performance
        case $status in
            performance*)
                $auth cpufreqctl --governor --set=powersave
                $auth cpufreqctl --epp --set=balance_power
                ;;
            powersave*)
                $auth cpufreqctl --governor --set=performance
                $auth cpufreqctl --epp --set=performance
                ;;
        esac
        ;;
    --status)
        printf "%s\n   %s\n" \
            ":: CPU governors" \
            "$($auth cpufreqctl --governor)"
        printf "%s\n   %s\n" \
            ":: CPU energy/perfomance policies (EPP)" \
            "$($auth cpufreqctl --epp)"
        ;;
    --available)
        printf "%s\n   %s\n" \
            ":: CPU governors" \
            "$($auth cpufreqctl --governor --available)"
        printf "%s\n   %s\n" \
            ":: CPU energy/perfomance policies (EPP)" \
            "$($auth cpufreqctl --epp --available)"
        ;;
    *)
        printf "%s\n" "$help"
        ;;
esac
