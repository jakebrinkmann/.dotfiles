# WIP - ONLY FOR UBUNTU (WSL)

VERSION="3.9"
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
${PYTHON} -m pip install --upgrade pip wheel setuptools

# Install my favorite tools
${PYTHON} -m pip install --upgrade \
    pytest \
    pytest-mock \
    black \
    flake8 \
    mypy \
    isort
