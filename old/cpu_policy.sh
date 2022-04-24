#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/cpu_policy.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-24T08:07:55+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

script=$(basename "$0")
help="$script [-h/--help] -- script to change cpu policies
  Usage:
    $script [--toggle/--performance/--powersave/--info/--status]

  Settings:
    [--toggle]      = switch between powersave and performance
    [--performance] = switch to performance
    [--powersave]   = switch to powersave
    [--info]        = shows information about governor and epp
    [--status]      = shows performance or powersafe

  Examples:
    $script --toggle
    $script --performance
    $script --powersave
    $script --info
    $script --status"

get_status() {
    cpufreqctl --governor \
        | cut -d ' ' -f1
}

set_policy() {
    case "$1" in
        performance)
            $auth cpufreqctl --governor --set=performance
            $auth cpufreqctl --epp --set=performance
            ;;
        powersave)
            $auth cpufreqctl --governor --set=powersave
            $auth cpufreqctl --epp --set=balance_power
            ;;
    esac
}

case "$1" in
    --toggle)
        # toggle powersave <-> performance
        case "$(get_status)" in
            performance)
                set_policy "powersave"
                ;;
            powersave)
                set_policy "performance"
                ;;
        esac
        ;;
    --performance)
        # toggle powersave -> performance
        [ "$(get_status)" = "powersave" ] \
            && set_policy "performance" \
            || exit 0
        ;;
    --powersave)
        # toggle performance -> powersave
        [ "$(get_status)" = "performance" ] \
            && set_policy "powersave" \
            || exit 0
        ;;
    --info)
        printf "==> CPU governors\n"
        printf "  -> available: %s\n" \
            "$(cpufreqctl --governor --available)"
        printf "  -> current:   %s\n" \
            "$(get_status)"
        printf "==> CPU energy/perfomance policies (EPP)\n"
        printf "  -> available: %s\n" \
            "$(cpufreqctl --epp --available)"
        printf "  -> current:   %s\n" \
            "$(cpufreqctl --epp | cut -d ' ' -f1)"
        ;;
    --status)
        printf "%s\n" \
            "$(get_status)"
        ;;
    *)
        printf "%s\n" "$help"
        ;;
esac
