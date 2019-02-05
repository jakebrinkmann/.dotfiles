#!/usr/bin/env bash

# TODO: checkout github.com/awslabs/aws-shell

# Install python dependency manager
if ! [ -x "$(command -v pip)" ]; then
  wget -O- https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# Install required AWS CLI
pip install --user awscli
