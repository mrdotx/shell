#!/bin/sh

# path:       ~/projects/shell/delete_metafiles.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-23T19:04:14+0100

output=$HOME/deleted_metafiles.txt

# files to delete
sudo su -c "find /home -name \".DS_Store\" > $output"
sudo su -c "find /home -name \"._*\" >> $output"
sudo su -c "find /home -name \".AppleDouble\" >> $output"
sudo su -c "find /home -name \".AppleDB\" >> $output"
sudo su -c "find /home -name \".@__thumb\" >> $output"
sudo su -c "find /home -name \".@__qini\" >> $output"
sudo su -c "find /home -name \":2e*\" >> $output"

# set output file permissions
sudo su -c "chmod 755 $output"

# delete files
while read -r f; do
    #echo "[info] delete $f"
    #rm -r "$f"
    trash-put "$f"
done < "$output"

# output result
$EDITOR "$output"
