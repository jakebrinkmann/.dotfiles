#!/usr/bin/env bash
# Install the latest NodeJS and other utilities

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1


# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Download and setup the YUM repository PGP key
    curl -sL https://rpm.nodesource.com/setup_12.x | bash -
    # Install NodeJS
    yum install --assumeyes \
        nodejs
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    # Arch (appropriately) treats node and npm separately
    pacman -S --noconfirm \
           nodejs \
           npm
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    # Download and setup the APT repository PGP key
    curl -sL https://deb.nodesource.com/setup_12.x | bash -
    # Install NodeJS
    apt-get install --assume-yes \
            nodejs
fi
# =================================================================

# Update to the latest npm
npm install --global npm

# TODO: vue/cli is not a requirement...
npm install --global @vue/cli
npm install --global @vue/cli-init
