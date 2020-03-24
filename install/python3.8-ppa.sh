# WIP

INSTALL_PYTHON="3.8"

apt update
apt install software-properties-common
add-apt-repository ppa:deadsnakes/ppa -y
apt install "python${INSTALL_PYTHON}" -y

curl -sS https://bootstrap.pypa.io/get-pip.py | "python${INSTALL_PYTHON}"
