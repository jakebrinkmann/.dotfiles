#!/usr/bin/env bash
# Install the python3 packge manager

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
        python-pydot \
        python-pydot-ng \
        python-pygraphviz \
        graphviz
fi
# =================================================================

echo "Installed GRAPHVIZ: $(dot -V)"

#### NOTE:
####  To create an environment
####    cd project_folder
####    virtualenv venv
####    . venv/bin/activate
