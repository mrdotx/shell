#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/padd_update.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:50:32+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

output="$HOME/.local/share/bin/padd.sh"
url="https://raw.githubusercontent.com/pi-hole/PADD/master/padd.sh"

replace() {
    sed -i "s?$1?$2?" "$output"
}

# download and set permissions
curl -o "$output" "$url"
chmod 755 "$output"

# replace shebang (\e[0K problem)
replace "#!/usr/bin/env sh" "#!/usr/bin/env bash"
