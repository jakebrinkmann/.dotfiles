#!/bin/bash
# Install the edge version of Docker

export DOCKER_CHANNEL=edge
export COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+.*$" | tail -n 1`

# Stop install if an error is encountered
set -e 

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify the fingerprint
apt-key fingerprint 0EBFCD88

# Setup the apt repository for e.g. bionic (18.04)
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) $DOCKER_CHANNEL"

# Install Docker (from edge repository)
apt update
apt install -y docker-ce

# Start the docker daemon
systemctl enable docker.service

# Allow the current user to run Docker without sudo
usermod -aG docker ${USER}

# Install docker-compose
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

