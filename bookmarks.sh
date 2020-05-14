#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/bookmarks.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:40:37+0200

# copy bookmarks from firefox to st
# printf 'select url from moz_bookmarks, moz_places where moz_places.id=moz_bookmarks.fk;\n' \
#     | sqlite3 ~/.mozilla/firefox/*.default-*/places.sqlite \
#     | awk -F '//' '{print $2}' \
#     | sed '/^$/d' \
#     | sort > ~/.config/surf/bookmarks

printf ":: copy bookmarks from brave to st\n"
grep \"url\": ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks \
    | awk -F '"' '{print $4}' \
    | awk -F '//' '{print $2}' \
    | sort > ~/.config/surf/bookmarks

printf ":: copy bookmarks from brave to qutebrowser\n"
grep \"url\": ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks \
    | awk -F '"' '{print $4}' \
    | sort > ~/.config/qutebrowser/bookmarks/urls
