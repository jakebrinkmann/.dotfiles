#!/usr/bin/env bash

# TODO: checkout github.com/awslabs/aws-shell

# Install python dependency manager
if ! [ -x "$(command -v pip3)" ]; then
  wget -O- https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# Install required AWS CLI
pip3 install --upgrade --user \
  awscli \
  awscurl \
  aws-sam-cli \
  cfn-lint \
  aws-cdk.core

sudo npm install -g \
    aws-cdk \
    @aws-amplify/cli

echo "AWS Version: $(aws --version)"
echo "AWS SAM Version: $(sam --version)"
echo "CloudFormation Linter: $(cfn-lint --version)"

if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
  sudo yum install -y session-manager-plugin.rpm

elif [ -n "$(type dpkg 2>/dev/null)" ]; then ## Debian/Ubuntu ##
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb
fi
