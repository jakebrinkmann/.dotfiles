set -eoux

git clone git@github.com:jakebrinkmann/.dotfiles.git ~/.dotfiles

# https://brew.sh/
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

cd "$HOME" || exit
brew bundle install

# https://ohmyz.sh/
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change default shell to zsh
chsh -s $(which zsh)

cd "$HOME/.dotfiles/dots" || exit
stow -t ~ bash git nvim brew ripgrep python psql zsh bin ssh task
stow -t ~/.config/ vscode
[[ "$OSTYPE" == "darwin"* ]] && stow -t ~/Library/Application\ Support vscode
