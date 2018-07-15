#!/usr/bin/env bash

sudo yum install -y yum-utils \
     	device-mapper-persistent-data \
     	lvm2
sudo yum-config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum install -y docker-ce
sudo systemctl start docker

sudo curl -L https://raw.githubusercontent.com/docker/cli/v$(docker version --format '{{.Server.Version}}')/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+.*$" | tail -n 1`
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

sudo usermod -aG docker $USER

