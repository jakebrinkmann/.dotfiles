#!/usr/bin/env bash
# WIP -- UBUNTU (WSL) ONLY
#
# Installs:
# * https://taskwarrior.org/docs/
# * https://bugwarrior.readthedocs.io/en/latest/

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

apt-get install --assume-yes --fix-missing \
        taskwarrior

python3.8 -m pip install --upgrade \
  "bugwarrior[jira]"

# I don't like timers, so I like to manually run `bugwarrior-pull`
