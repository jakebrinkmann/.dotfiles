#!/usr/bin/env bash
# Install the latest miniconda package manager

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
    true
fi
# =================================================================

# Download & run installer
curl -fsSL -o /tmp/miniconda.sh \
     https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
/bin/bash /tmp/miniconda.sh -b -p /opt/miniconda3
rm /tmp/miniconda.sh

# Cleanup install artifacts
/opt/miniconda3/bin/conda clean -tipsy

# Configure environment
ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo "##### Conda profile setup" >> /etc/profile.d/conda.sh
echo 'export PATH=/opt/miniconda3/bin:$PATH' >> /etc/profile.d/conda.sh
