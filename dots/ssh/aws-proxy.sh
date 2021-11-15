#!/usr/bin/env sh
######## Usage #################################################################
#
# Install Proxy Command
#   - Move this script to ~/.ssh/aws-proxy.sh
#   - Ensure it is executable (chmod +x ~/.ssh/aws-proxy.sh)
#
# Add following SSH Config Entry to ~/.ssh/config
#   host EC2-SSM-Bastion
#     IdentityFile ~/.ssh/id_rsa
#     ProxyCommand ~/.ssh/aws-proxy.sh %h %r %p ~/.ssh/id_rsa.pub
#     StrictHostKeyChecking no
#
# Ensure SSM Permissions for Target Instance Profile
#   https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-profile.html
#
# Open SSH Connection
#   ssh EC2-SSM-Bastion
#
#   Ensure AWS CLI environemnt variables are set properly
#   e.g. AWS_PROFILE='default' ssh EC2-SSM-Bastion
#
################################################################################
set -eu

ec2_instance_id="$1"
ssh_user="$2"
ssh_port="$3"
ssh_public_key_path="$4"
ssh_public_key="$(cat "${ssh_public_key_path}")"

ec2_instance_id=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=Bastion" \
        --query 'Reservations[*].Instances[*].{Instance:InstanceId}' \
        --output text)

>/dev/stderr echo "Add public key ${ssh_public_key_path} to instance ${ec2_instance_id} for 60 seconds"
aws ssm send-command \
  --document-name "Bastion-CreateUser" \
  --document-version "1" \
  --targets '[{"Key":"tag:Name","Values":["Bastion"]}]' \
  --parameters '{"PublicKey":["'"$ssh_public_key"'"],"UserName":["'"$ssh_user"'"]}' \
  --timeout-seconds 60 \
  --max-concurrency "50" \
  --max-errors "0"

>/dev/stderr echo "Start ssm session to instance ${ec2_instance_id}"
aws ssm start-session \
  --target "${ec2_instance_id}" \
  --document-name 'AWS-StartSSHSession' \
  --parameters "portNumber=${ssh_port}"
