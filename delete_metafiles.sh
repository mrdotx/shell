#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/delete_metafiles.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 14:12:34

# color variables
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
#magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

output=$HOME/delmetafile.txt

# files to delete
echo "[${blue} x ${reset}] Delete meta data"
sudo su -c "find /home -name ".DS_Store" > $output"
sudo su -c "find /home -name "._*" >> $output"
sudo su -c "find /home -name ".AppleDouble" >> $output"
sudo su -c "find /home -name ".AppleDB" >> $output"
sudo su -c "find /home -name ".@__thumb" >> $output"
sudo su -c "find /home -name ".@__qini" >> $output"
sudo su -c "find /home -name ":2e*" >> $output"

# set output file permissions
sudo su -c "chmod 755 $output"

# delete files
cat $output | while read f; do
    echo "[${yellow}info${reset}] delete $f"
    #rm -r "$f"
    gio trash "$f"
done

# output result
$EDITOR $output
