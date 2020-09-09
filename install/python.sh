#!/usr/bin/env bash
# Install the python3 packge manager

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Requirements which do not ship in minimal/docker distros
    yum install --assumeyes \
        bzip2 \
        ca-certificates
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    true
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    apt update;
    apt install --assume-yes \
        exuberant-ctags \
        python3-pip \
        python3-venv
fi
# =================================================================

# Install Python environment manager.
pip3 install --upgrade virtualenv pip wheel setuptools
echo "VirtualEnv Version: $(virtualenv --version)"

#### NOTE:
####  To create an environment
####    cd project_folder
####    virtualenv venv
####    . venv/bin/activate
