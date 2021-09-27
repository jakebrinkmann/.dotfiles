#!/usr/bin/env bash
# Install the python3 runtime
brew install python
brew upgrade python

# Do I have a Python 3 installed?
python3 --version

# Install Python environment manager.
pip3 install --upgrade virtualenv pip wheel setuptools
echo "VirtualEnv Version: $(virtualenv --version)"

#### NOTE:
####  To create an environment
####    cd project_folder
####    virtualenv venv
####    . venv/bin/activate
