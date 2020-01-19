#!/bin/sh

# path:       ~/projects/shell/maintenance_github.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-20T00:47:40+0100

echo ":: github"
echo " checkout..."
git checkout --orphan latest_branch

echo " add all the files and folders..."
git add -A

echo " commit the changes..."
git commit -am "reset commits"

echo " delete the branch..."
git branch -D master

echo " rename the current branch to master..."
git branch -m master

echo " force update repository..."
git push -f origin master

echo " set upstream..."
git push --set-upstream origin master
