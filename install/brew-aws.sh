#!/usr/bin/env bash
brew install awscli
brew upgrade awscli

echo "AWS Version: $(aws --version)"

brew tap aws/tap

brew install aws-sam-cli
brew upgrade aws-sam-cli

echo "AWS SAM Version: $(sam --version)"

brew install cfn-lint
brew upgrade cfn-lint

echo "CloudFormation Linter: $(cfn-lint --version)"
