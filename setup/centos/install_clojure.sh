#!/usr/bin/env bash
set -e
yum install -y emacs java-1.8.0openjdk
curl -fsSLo /usr/local/bin/boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh 
chmod 755 /usr/local/bin/boot

