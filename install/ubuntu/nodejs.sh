#!/usr/bin/env bash
# Install the latest NodeJS in Ubuntu 1804 (bionic)

# Download and setup the APT repository PGP key
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Install NodeJS
sudo apt install -y nodejs

# Update to the latest npm
sudo npm install --global npm

read -p "Install Vue-CLI? " yn
case $yn in
	[Yy]*) 
		sudo npm install --global @vue/cli
		sudo npm install --global @vue/cli-init
		;;
	*)
		break
		;;
esac
