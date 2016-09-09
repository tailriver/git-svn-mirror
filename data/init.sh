#!/bin/sh

set -e

if [ "$DEBUG" == "1" ]; then
  set -x
fi

# Execute dummy subversion command to store password
if [ -n "$SVN_USERNAME" -a -n "$SVN_PASSWORD" ]; then
  svn info \
    --username $SVN_USERNAME --password $SVN_PASSWORD \
    --config-option servers:global:store-passwords=yes \
    --config-option servers:global:store-plaintext-passwords=yes \
    $SVN_REPOSITORY
fi

git init --bare
git svn init --prefix=svn/ $GIT_SVN_INIT_OPTIONS $SVN_REPOSITORY
git remote add origin $GIT_REPOSITORY
git config --add remote.origin.push 'refs/remotes/svn/*:refs/heads/*'

git svn fetch $GIT_SVN_FIRST_FETCH_OPTIONS
git gc

# To sync remains of other (past) git-svn client
git pull
git push -u origin master

crond -f
