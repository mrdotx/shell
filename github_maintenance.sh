#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/github_maintenance.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 14:11:47

# color variables
#black=$(tput setaf 0)
#red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

echo "[${magenta}github${reset}] checkout"
git checkout --orphan latest_branch

echo "[${magenta}github${reset}] add all the files and folders"
git add -A

echo "[${magenta}github${reset}] commit the changes"
git commit -am "reset commits"

echo "[${magenta}github${reset}] delete the branch"
git branch -D master

echo "[${magenta}github${reset}] rename the current branch to master"
git branch -m master

echo "[${magenta}github${reset}] force update repository"
git push -f origin master

echo "[${magenta}github${reset}] set upstream"
git push --set-upstream origin master
