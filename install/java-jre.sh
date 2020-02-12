#!/usr/bin/env bash
# Install the OpenJDK variant of Java Runtime Environment (JRE) 

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Requirements which do not ship in minimal/docker distros
    exit 1
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    exit 1
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    apt-get install --assume-yes \
        default-jre
fi
# =================================================================

echo "Installed JAVA:"
java -version
