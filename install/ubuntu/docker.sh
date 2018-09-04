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
sudo curl -L \
	"https://github.com/docker/compose/releases/download/\
	${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
       	-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

