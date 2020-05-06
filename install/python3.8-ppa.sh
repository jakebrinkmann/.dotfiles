# WIP - ONLY FOR UBUNTU (WSL)

VERSION="3.8"
PYTHON="python${VERSION}"

# Install from PPA
apt update
apt install software-properties-common
add-apt-repository ppa:deadsnakes/ppa -y
apt install -y \
    "${PYTHON}" \
    "${PYTHON}-venv"

# Install PIP
curl -sS https://bootstrap.pypa.io/get-pip.py | "${PYTHON}"
${PYTHON} -m pip install --upgrade pip

# Install my favorite tools
${PYTHON} -m pip install --upgrade \
    pytest \
    pytest-sugar \
    pytest-mock \
    black \
    poetry

# Enable bash completions for poetry
${PYTHON} -m poetry completions bash > /etc/bash_completion.d/poetry.bash-completion
