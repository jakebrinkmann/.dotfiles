#!/bin/bash
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs

read -p "Install Vue-CLI?" yn
case $yn in
	[Yy]*) npm install --global @vue/cli; npm install -g @vue/cli-init;; 
	*) break;;
esac
