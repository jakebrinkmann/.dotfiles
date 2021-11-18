#!/usr/bin/env bash

URL=https://github.com/mike-engel/jwt-cli/releases/download/5.0.0
SRC_FNAME=jwt-linux.tar.gz
SHA_FNAME=jwt-linux.sha256

cd /tmp
curl -OLv "$URL/$SRC_FNAME"
curl -OLv "$URL/$SHA_FNAME"
cat $SHA_FNAME | sha256sum --check
tar xz -f $SRC_FNAME
mv jwt ~/.local/bin/
rm -rf $SRC_FNAME

echo "JWT Version: $(jwt --version)"

# USAGE:
#
#     jwt encode --secret=fake '{"hello":"world"}'
# 
#     curl <auth API> | jq -r .access_token | jwt decode -
