#!/usr/bin/env bash

# TODO: checkout github.com/awslabs/aws-shell

# Install python dependency manager
if ! [ -x "$(command -v pip3)" ]; then
  wget -O- https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# Install required AWS CLI
pip3 install --user \
  awscli \
  aws-sam-cli

echo "AWS Version: $(aws --version)"
echo "AWS SAM Version: $(sam --version)"
