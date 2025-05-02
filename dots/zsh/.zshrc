# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
	aliases
	archlinux
	aws
	bgnotify
	brew
	docker
	docker-compose
	fzf
	git
	history
	httpie
	isodate
	jira
	jump
	npm
	per-directory-history
	python
	taskwarrior
	web-search
	you-should-use
)
source $ZSH/oh-my-zsh.sh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[[ -f ~/.cargo/env ]] && source $HOME/.cargo/env

[[ -d $PYENV_ROOT ]] && export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init -)"
[[ -d ~/.local/share/bob/nvim-bin ]] && export PATH="${HOME}/.local/share/bob/nvim-bin:$PATH"

export NVIM_DIR=~/.nvim
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

autoload -Uz compinit
compinit

export PATH=$PATH:"$HOMEBREW_PREFIX/opt/php@8.2/bin"
export PATH=$PATH:"$HOMEBREW_PREFIX/opt/php@8.2/sbin"
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH="/opt/warden/bin:$PATH"
