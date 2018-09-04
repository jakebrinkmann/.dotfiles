#!/bin/bash
# Installs apt packages needed by other packages

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

