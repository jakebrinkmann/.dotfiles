#!/usr/bin/env bash
SRC=~/dev/github
mkdir -p $SRC

for x in $(gh api user/starred | jq -r '.[].full_name'); do
  if [ ! -d $SRC/$x ]; then
    # NOTE: using 'blobless clone' to make it fast.
    git clone --filter=blob:none git@github.com:$x.git $SRC/$x
  fi
done

for x in $(gh api user/repos | jq -r '.[].full_name'); do
  if [ ! -d $SRC/$x ]; then
    # NOTE: using 'blobless clone' to make it fast.
    git clone --filter=blob:none git@github.com:$x.git $SRC/$x
  fi
done

USER=$(gh api user | jq -r '.login')
for x in $(gh api gists | jq -r '.[].id'); do
  if [ ! -d $SRC/$USER/$x ]; then
    # NOTE: using 'blobless clone' to make it fast.
    git clone --filter=blob:none git@github.com:$x.git $SRC/$USER/$x
  fi
done
