#!/usr/bin/env bash
# Install the python3 runtime
brew install python
brew upgrade python

# Do I have a Python 3 installed?
python3 --version

# Install Python CLI tools via pipx (installed via Brewfile)
pipx ensurepath
pipx install virtualenv
pipx install strip-tags
echo "VirtualEnv Version: $(virtualenv --version)"

#### NOTE:
####  To create an environment
####    cd project_folder
####    virtualenv venv
####    . venv/bin/activate
