#!/bin/sh

set -e -x

mkdir -p /work
cd /work

# Execute dummy subversion command to store password
if [ -n "$SVN_USERNAME" -a -n "$SVN_PASSWORD" ]; then
  svn info \
    --username $SVN_USERNAME --password $SVN_PASSWORD \
    --config-option servers:global:store-passwords=yes \
    --config-option servers:global:store-plaintext-passwords=yes \
    $SVN_REPOSITORY
fi

git init --bare
git svn init --stdlayout --prefix=svn/ $SVN_REPOSITORY
git remote add origin $GIT_REPOSITORY
git config --add remote.origin.push 'refs/remotes/svn/*:refs/heads/*'

if [ -e /root/authors.txt ]; then
  git config --add svn.authorsfile /root/authors.txt
fi

git svn fetch
git gc

# To sync remains of other (past) git-svn client
git pull
git push -u origin master

crond -f
