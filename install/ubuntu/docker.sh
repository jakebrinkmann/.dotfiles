#!/bin/bash
# Install the edge version of Docker

export DOCKER_CHANNEL=edge
export DOCKER_COMPOSE_VERSION=1.21.0

# Stop install if an error is encountered
set -e 

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint
sudo apt-key fingerprint 0EBFCD88

# Setup the apt repository for e.g. bionic (18.04)
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) $DOCKER_CHANNEL"

# Install Docker (from edge repository)
sudo apt update
sudo apt install -y docker-ce

# Start the docker daemon
sudo systemctl enable docker.service

# Allow the current user to run Docker without sudo
sudo usermod -aG docker ${USER}

# Install docker-compose
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+.*$" | tail -n 1`
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

