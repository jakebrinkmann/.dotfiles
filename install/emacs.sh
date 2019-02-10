#!/usr/bin/env bash
# Script to install Emacs (and setup font locales)
# Usage:
#        sudo ./install/emacs.sh

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1


# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Emacs is included in epel-release
    # TODO: Currently, version 24.3, spacemacs requires 24.4+
    yum install --assumeyes \
        emacs
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    pacman -S --noconfirm \
           emacs
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    # Install emacs
    apt-get install --assume-yes \
            emacs
fi
# =================================================================

# Download & Install enabled spacemacs plugins
emacs -nw -batch -kill
emacs -nw -batch --load $HOME/.emacs.d/init.el
