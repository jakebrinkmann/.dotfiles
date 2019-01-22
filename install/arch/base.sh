#!/usr/bin/env bash

# Update DB mirrors
pacman -Syy

# Install dependencies
pacman -S \
  vim \
  emacs \
  adobe-source-code-pro-fonts
