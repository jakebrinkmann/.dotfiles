#!/usr/bin/env bash

# TODO: checkout github.com/awslabs/aws-shell

# Install python dependency manager
if ! [ -x "$(command -v pip3)" ]; then
  wget -O- https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# Install AWS CLI Version 2
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --update -i ~/.local/lib/python3.8/site-packages/aws-cli -b ~/.local/bin
rm -rf aws awscliv2.zip

echo "AWS Version: $(aws --version)"

# Install AWS SAM ClI
cd /tmp
curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
./sam-installation/install --update -i ~/.local/lib/python3.8/site-packages/aws-sam-cli -b ~/.local/bin
rm -rf sam-installation aws-sam-cli-linux-x86_64.zip

echo "AWS SAM Version: $(sam --version)"

# Install cfn-lint
pip3 install --upgrade --user \
  awscurl \
  cfn-lint \
  aws-cdk.core \
  saws \
  pydot

echo "CloudFormation Linter: $(cfn-lint --version)"

# Install Amplify
sudo npm install -g \
    aws-cdk \
    @aws-amplify/cli

if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
  sudo yum install -y session-manager-plugin.rpm

elif [ -n "$(type dpkg 2>/dev/null)" ]; then ## Debian/Ubuntu ##
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb
fi
