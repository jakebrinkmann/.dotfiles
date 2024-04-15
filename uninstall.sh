rm -rf ~/.dotfiles
rm -rf ~/.oh-my-zsh
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

pip uninstall --yes bugwarrior
