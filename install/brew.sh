#!/usr/bin/env bash

# running Linux or WSL, install some pre-requisite packages
sudo apt-get update && \
  sudo apt-get --fix-missing --assume-yes install build-essential procps curl file git

# Create a "linuxbrew" user
sudo useradd --create-home linuxbrew

# Install Linuxbrew in /home/linuxbrew/.linuxbrew/ if possible so that you can use
# precompiled binary packages (known as bottles) for non-relocatable formula
cd /tmp
curl -OfsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
env NONINTERACTIVE="YES" CI="YES" /bin/bash -c install.sh
rm install.sh

# Add Homebrew to your PATH
CMD='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
echo $CMD >> ~/.extra
eval $(echo $CMD)

# Check if installed correctly
brew doctor

# Test Installation of package:
# https://formulae.brew.sh/formula/
brew install hello

# brew update && brew outdated
