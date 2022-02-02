#!/usr/bin/env bash

sudo apt update
sudo apt install --yes --no-install-recommends \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-xetex \
  pandoc
