rm -rf ~/.dotfiles
rm -rf ~/.oh-my-zsh
rm -rf ~/.zshrc
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
