#!/usr/bin/env bash
# Install python from source

PYTHON_VER="3.7.4"
SRC_DIR="Python-$PYTHON_VER"
SRC_URL="https://www.python.org/ftp/python/$PYTHON_VER/$SRC_DIR.tgz"
INSTALL_LOC="/opt/$SRC_DIR"

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    exit 1
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    exit 1
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    apt-get install --assume-yes \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        libsqlite3-dev \
        wget
fi
# =================================================================

# Download and extract source code
rm -rf $INSTALL_LOC
mkdir $INSTALL_LOC && cd $INSTALL_LOC
curl $SRC_URL | tar xz

# Configuration, Dependency checks, and Build
# NOTE: expected --prefix should already be on path
cd $SRC_DIR
./configure --enable-optimizations
make -j $(nproc)

# Install into system prefix (/usr/local/bin)
# `altinstall` directories include major/minor version and can thus live side by side
make altinstall

# Grab the major version number
PYTHON_EXEC="python${PYTHON_VER::-2}"
echo "PYTHON VERSION: $(${PYTHON_EXEC} --version)"

# Fix for pip "No module named 'pip._vendor.retrying'"
rm -rf /usr/local/lib/python3.7/site-packages/pip
${PYTHON_EXEC} -m ensurepip
curl -sS https://bootstrap.pypa.io/get-pip.py | ${PYTHON_EXEC}
