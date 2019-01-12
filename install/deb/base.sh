#!/bin/bash
# Installs apt packages needed by other packages

# NOTE: avoid using `upgrade` to keep closer to immutable builds.
apt-get update

# Allow `--fix-missing` to fetch required deps not already installed.
apt-get install --assume-yes --fix-missing \
  build-essential \
  apt-transport-https \
  ca-certificates \
  curl \
  wget \
  software-properties-common \
  openssl \
  python-dev \
  git \
  vim \
  jq \
  httpie
