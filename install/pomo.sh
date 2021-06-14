#!/usr/bin/env bash

# https://github.com/kevinschoon/pomo/releases
curl -L https://github.com/kevinschoon/pomo/releases/download/0.7.1/pomo-0.7.1-linux-amd64 \
  -o ~/.local/bin/pomo

chmod +x ~/.local/bin/pomo
pomo init

# ~/.pomo/config.json
# pomo s  -d "25m" -p "4" -t "my-project" "descriptive name of task"
# pomo l -d "24h"
# pomo st
