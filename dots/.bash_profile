# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

alias ll='ls -l'                              # long list

export HISTSIZE=1000
export HISTFILESIZE=2000
#### export HISTFILE=~/.bash_eternal_history
#### PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

alias GIT_BRANCH_CMD="sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'"
PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]\t\[\e[0m\]; else echo \[\e[31m\]\t\[\e[0m\]; fi\`"'\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]`GIT_BRANCH_CMD`\$ '

alias d='date "+%j/%Y [%m/%d] %H:%M:%S (%I:%M%p) %Z"'
alias c='clear; cal -j; d'
alias t="top -M -u ${USER}; c"

if [ -f ~/.custom.bashrc ]; then
        . ~/.custom.bashrc
fi
