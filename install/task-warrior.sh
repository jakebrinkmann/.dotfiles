#!/usr/bin/env bash
# WIP -- UBUNTU (WSL) ONLY
#
# Installs:
# * https://taskwarrior.org/docs/
# * https://bugwarrior.readthedocs.io/en/latest/
# * https://timewarrior.net/docs/

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

apt-get install --assume-yes --fix-missing \
        taskwarrior \
        timewarrior

python3.8 -m pip install --upgrade \
  "bugwarrior[jira]"

# I don't like timers, so I like to manually run `bugwarrior-pull`

# * https://timewarrior.net/docs/taskwarrior/
cp /usr/share/doc/timewarrior/ext/on-modify.timewarrior ~/.task/hooks/
chmod +x ~/.task/hooks/on-modify.timewarrior

task diagnostics

######
# task add "Be Awesome" +life
# task :LATEST start
# task :LATEST stop
# task :LATEST start
# task :LATEST done
# timew summary yesterday - now :ids
# timew track 9am for 2h 'Chat with coworker' +topic
# timew gaps
######
