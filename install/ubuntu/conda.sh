#!/usr/bin/env bash

wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
	rm ~/miniconda.sh && \
	/opt/conda/bin/conda clean -tipsy && \
	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
	echo "##### Conda profile setup" >> /etc/profile.d/conda.sh && \
	echo 'export PATH=/opt/conda/bin:$PATH' >> /etc/profile.d/conda.sh
