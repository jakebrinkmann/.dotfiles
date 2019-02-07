#!/usr/bin/env bash
# Installs docker libraries and tools
# NOTE: community edition is open-source (instead of enterprise)
# NOTE: edge (now nightly) channel allows experimental features

# I <3 living on the edge
DOCKER_CHANNEL=nightly
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+.*$" | tail -n 1`

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1


# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Dependencies for yum-config and devicemapper storage layer
    # TODO: overlay2 storage layer is recommended?
    # //docs.docker.com/install/linux/docker-ce/centos/
    yum install --assumeyes \
        yum-utils \
        device-mapper-persistent-data \
        lvm2
    # Configure Yum to allow Edge channel (for experimental features)
    yum-config-manager \
          --add-repo \
          https://download.docker.com/linux/centos/docker-ce.repo
    yum-config-manager --enable docker-ce-$DOCKER_CHANNEL
    yum install --assumeyes \
        docker-ce \
        docker-cli \
        containerd.io
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    # Install (--sync/-S) docker container suite
    pacman -S --noconfirm docker
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    # Allow APT to install from HTTPS repository
    apt-get install --assume-yes \
            apt-transport-https
    # Set environment variables for our distro, e.g. debian/ubuntu
    . /etc/*release
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/$ID/gpg | apt-key add -
    # Verify the fingerprint
    apt-key fingerprint 0EBFCD88
    # Setup the apt repository for e.g. bionic (18.04)
    # NOTE: some may not be supported yet, so need to fall-back
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$ID \
        $(lsb_release -cs) \
        $DOCKER_CHANNEL"
    # Update metadata cache, to find new repository
    apt-get update
    # Install Docker (from nightly repository)
    apt-get install --assume-yes \
            docker-ce \
            docker-ce-cli \
            containerd.io
fi
# =================================================================

# WARNING: experimental features might mean incompatabilities with peers...
tee /etc/docker/daemon.json <<__END__
{
     "experimental": true,
     "storage-driver": "overlay2"
}
__END__

# Install docker-compose (python script)
curl -fsSL -o /usr/local/bin/docker-compose \
     https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`
chmod +x /usr/local/bin/docker-compose

# Allow services/socket/daemon to start on boot
# TODO: make sure we're running behind an init'd system
systemctl enable docker.service
systemctl start docker.service

# Install bash-completion
# TODO: requires that docker-daemon is running (to get version)
curl -fsSL -o /usr/share/bash-completion/completions/docker \
     https://raw.githubusercontent.com/docker/cli/v$(docker version --format '{{.Server.Version}}' | sed 's/-.*//')/contrib/completion/bash/docker
curl -fsSL -o /usr/share/bash-completion/completions/docker-compose \
     https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose

# NOTE! I had this issue until after a system restart:
#       "docker.socket: Failed with result 'service-start-limit-hit'"

# Run a test image in a container
CMD="docker run hello-world"
echo -n "Running '$CMD'... "
eval $CMD &> /dev/null

# Display test OK/FAILED
[ $? = 0 ] \
    && echo -e '\E[32m'"\033[1m[OK]\033[0m" \
       || echo -e '\E[31m'"\033[1m[FAIL]\033[0m"

# Display some help for our future-self
echo
echo 'To allow users to run docker:'
echo '    sudo usermod -aG docker $USER'

