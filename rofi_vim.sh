#!/bin/sh

# path:       ~/projects/shell/rofi_vim.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:16:37+0100

# exit if rofi is running
pgrep -x rofi && exit

netrc() {
    rmt_name=$1
    gpg -o "$HOME/.netrc" "$HOME/cloud/webde/Keys/netrc.gpg" \
        && chmod 600 "$HOME/.netrc" \
        && $TERMINAL -e vim "$rmt_name" -c "Lexplore" \
        && rm -f "$HOME/.netrc"
}

# menu for vim shortcuts
case $(printf "%s\n" \
    "nvim" \
    "notes" \
    "middlefinger-streetwear.com" \
    "prinzipal-kreuzberg.com" \
    "klassiker.online.de" \
    "marcusreith.de" \
    "pi" \
    "pi2" \
    "firetv" \
    "firetv4k" \
    "p9" \
    "m3" \
    "explore" | rofi -monitor -1 -lines 13 -theme klassiker-center -dmenu -i -p "") in
    "nvim") $TERMINAL -e vim ;;
    "notes") $TERMINAL -e vim "$HOME/Dokumente/Notes/index.md" ;;
    "middlefinger-streetwear.com") $TERMINAL -e vim scp://middlefinger/ -c "Lexplore" ;;
    "prinzipal-kreuzberg.com") $TERMINAL -e vim scp://prinzipal/ -c "Lexplore" ;;
    "klassiker.online.de") netrc ftp://klassiker.online.de/ ;;
    "marcusreith.de") netrc ftp://marcusreith.de/ ;;
    "pi") $TERMINAL -e vim scp://hermes/ -c "Lexplore" ;;
    "pi2") $TERMINAL -e vim scp://prometheus/ -c "Lexplore" ;;
    "firetv") $TERMINAL -e vim scp://firetv/ -c "Lexplore" ;;
    "firetv4k") $TERMINAL -e vim scp://firetv4k/ -c "Lexplore" ;;
    "p9") $TERMINAL -e vim scp://p9/ -c "Lexplore" ;;
    "m3") $TERMINAL -e vim scp://m3/ -c "Lexplore" ;;
    "explore") $TERMINAL -e vim -c "Lexplore" ;;
esac
