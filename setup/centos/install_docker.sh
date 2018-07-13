#!/usr/bin/env bash

sudo yum install -y yum-utils \
     	device-mapper-persistent-data \
     	lvm2

sudo yum-config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum install -y docker-ce

sudo systemctl start docker
sudo curl -L \
	"https://raw.githubusercontent.com/docker/machine/v0.14.0/contrib/completion/bash/docker-machine.bash" \
	-o "/etc/bash_completion.d/docker-machine"

sudo curl -L \
	"https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m)" \
	-o "/usr/local/bin/docker-compose"

sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L \
	"https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose" \
	-o "/etc/bash_completion.d/docker-compose"

sudo usermod -aG docker $USER

