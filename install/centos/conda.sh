#!/usr/bin/env bash

set -x
yum install -y bzip2

curl --silent https://repo.anaconda.com/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh > ~/miniconda.sh
bash ~/miniconda.sh -b -p /opt/conda 
rm ~/miniconda.sh

/opt/conda/bin/conda clean -tipsy
