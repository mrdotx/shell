#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/cpu_boost.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-18T11:22:48+0200

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas"
file="/etc/tlp.d/99-xiaomi-mi.conf"

# toggle powersave <-> performance
if grep -q "CPU_SCALING_GOVERNOR_ON_AC=performance" "$file"; then
    $auth sed -i '/CPU_SCALING_GOVERNOR_ON_AC=performance/c\CPU_SCALING_GOVERNOR_ON_AC=powersave' "$file"
    $auth sed -i '/CPU_SCALING_GOVERNOR_ON_BAT=performance/c\CPU_SCALING_GOVERNOR_ON_BAT=powersave' "$file"
    printf "set scaling governor to powersave\n"
else
    $auth sed -i '/CPU_SCALING_GOVERNOR_ON_AC=powersave/c\CPU_SCALING_GOVERNOR_ON_AC=performance' "$file"
    $auth sed -i '/CPU_SCALING_GOVERNOR_ON_BAT=powersave/c\CPU_SCALING_GOVERNOR_ON_BAT=performance' "$file"
    printf "set scaling governor to performance\n"
fi

# restart tlp
$auth tlp start >/dev/null 2>&1
