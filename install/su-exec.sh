#!/usr/bin/env bash
# Installer for utility to downgrade from root-permissions
# This is a smaller alternative (10KB) to gosu (1.8MB), keeping
# the docker build as root, and avoiding use of "USER" commands.

# The latest release tag, pinned for stability
SU_EXEC_VERSION=v0.2

# Ensure this script is run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

# Clone only the HEAD of the branch/tag (depth 1 === HEAD)
cd /tmp
git clone https://github.com/ncopa/su-exec.git \
    --branch $SU_EXEC_VERSION \
    --depth 1 \
    ./su-exec/

# Compile binary (gcc)
cd ./su-exec/
make all

# Install executable
chmod a+x su-exec
mv ./su-exec /usr/local/bin

# Cleanup
rm -rf /tmp/*
