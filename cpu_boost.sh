#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/cpu_boost.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/polybar
# date:       2020-06-15T22:52:30+0200

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas --"
file="/etc/tlp.d/69-klassiker.conf"

# toggle powersave <-> performance
if grep -q "CPU_SCALING_GOVERNOR_ON_AC=performance" "$file"; then
    $auth sed -i "/CPU_SCALING_GOVERNOR_ON_AC=performance/c\CPU_SCALING_GOVERNOR_ON_AC=powersave" "$file"
    $auth sed -i "/CPU_SCALING_GOVERNOR_ON_BAT=performance/c\CPU_SCALING_GOVERNOR_ON_BAT=powersave" "$file"
    echo "set scaling governor to powersave"
else
    $auth sed -i "/CPU_SCALING_GOVERNOR_ON_AC=powersave/c\CPU_SCALING_GOVERNOR_ON_AC=performance" "$file"
    $auth sed -i "/CPU_SCALING_GOVERNOR_ON_BAT=powersave/c\CPU_SCALING_GOVERNOR_ON_BAT=performance" "$file"
    echo "set scaling governor to performance"
fi

# restart tlp
$auth tlp start >/dev/null 2>&1
