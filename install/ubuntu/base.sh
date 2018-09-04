#!/bin/bash
# Installs apt packages needed by other packages

apt update
apt install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	openssl

