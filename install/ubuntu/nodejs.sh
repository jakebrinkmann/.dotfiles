#!/usr/bin/env bash
# Install the latest NodeJS in Ubuntu 1804 (bionic)

# Download and setup the APT repository PGP key
curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Install NodeJS
apt install -y nodejs

# Update to the latest npm
npm install --global npm

read -p "Install Vue-CLI? " yn
case $yn in
	[Yy]*) 
		npm install --global @vue/cli
		npm install --global @vue/cli-init
		;;
	*)
		break
		;;
esac
