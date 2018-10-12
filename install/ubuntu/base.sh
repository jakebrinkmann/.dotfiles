#!/bin/bash
# Installs apt packages needed by other packages

apt update
apt upgrade
apt install -y --fix-missing \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	openssl \
	jq \
	python-dev

