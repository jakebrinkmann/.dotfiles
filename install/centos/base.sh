#!/usr/bin/env bash

set -x 
yum install -y \
	vim \
	git \
	which \
	wget \
	curl \
	httpie \
	sudo \
	tmux \
	epel-release \
	bash-completion \
	pv
