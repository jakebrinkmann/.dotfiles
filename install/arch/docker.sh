#!/usr/bin/env bash

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
	&& echo 'Must be run as root!' \
	&& exit 1

# Install (--sync/-S) docker container suite
pacman -S --noconfirm docker

# Also the docker-compose orchestra
pacman -S --noconfirm docker-compose

# Allow services/socket/daemon to start on boot
systemctl enable docker
systemctl start docker

# NOTE! I had this issue until after a system restart:
# 	"docker.socket: Failed with result 'service-start-limit-hit'"

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
echo '	sudo usermod -aG docker $USER'

