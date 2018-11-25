#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
BRANCH=${BRANCH}-ud

if [ $# -lt 1 ]; then
  TEMP_DIR=ud
else
  TEMP_DIR=$1
fi
[ -d $TEMP_DIR ] || exit 1
git checkout --orphan $BRANCH
git reset -q
git pull origin $BRANCH
rm -f *.*
mv -f $TEMP_DIR/* ./
rmdir $TEMP_DIR
git add *.conllu

