#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/test_march.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-10-16T05:52:27+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
cpu_flags=$(grep "^flags\s*:" "/proc/cpuinfo" | head -n1 | cut -d ':' -f2)

# color variables
reset="\033[0m"
bold="\033[1m"
green="\033[32m"
blue="\033[94m"

# functions
check_cpu_flags() {
    title="$1"
    shift

    printf "%b%b==>%b %s\n" \
        "$bold" "$green" "$reset" "$title"

    for required_flag in $*; do
        case "$cpu_flags" in
            *"$required_flag"*)
                [ -z "$found" ] \
                    && found="$required_flag: found" \
                    || found="$found\n$required_flag: found"
                ;;
            *)
                [ -z "$found" ] \
                    && found="$required_flag: missing" \
                    || found="$found\n$required_flag: missing"
                ;;
        esac
    done

    [ -n "$found" ] \
        && printf "%b\n" "$found" \
            | column --separator ':' --output-separator ' =' --table

    unset found
}

# main
printf "%b%b::%b %brequired cpu flags for -march:%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset"
check_cpu_flags "x86-64-v1" "lm cmov cx8 fpu fxsr mmx syscall sse2"
check_cpu_flags "x86-64-v2" "cx16 lahf_lm popcnt sse4_1 sse4_2 ssse3"
check_cpu_flags "x86-64-v3" "avx avx2 bmi1 bmi2 f16c fma abm movbe xsave"
check_cpu_flags "x86-64-v4" "avx512f avx512bw avx512cd avx512dq avx512vl"
