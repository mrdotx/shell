#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/sftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:48:48

sftpdir=$1
sftphost=<Hostname>
sftpuser=<Username>
sftppass=$(gpg -q --decrypt <passwordfile.gpg>)

# connect to sftp via sshfs
# host must be in .ssh/known_hosts
sshfs -o password_stdin $sftpuser@$sftphost:/ "$sftpdir" <<< "$sftppass" && exit 0
