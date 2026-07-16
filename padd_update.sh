#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/padd_update.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:53:55+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

output="$HOME/Projects/repos/shell/padd.sh"
url="https://raw.githubusercontent.com/pi-hole/PADD/master/padd.sh"

replace() {
    sed -i "s?$1?$2?" "$output"
}

# download and set permissions
curl -o "$output" "$url"
chmod 755 "$output"

# replace shebang (\e[0K problem)
replace "#!/usr/bin/env sh" "#!/bin/bash"
