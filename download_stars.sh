#!/usr/bin/env bash
SRC=~/dev/github
mkdir -p $SRC

for x in $(gh api user/starred | jq -r '.[].full_name'); do
  if [ ! -d $SRC/$x ]; then
    # NOTE: using 'blobless clone' to make it fast.
    git clone --filter=blob:none git@github.com:$x.git $SRC/$x
  fi
done
