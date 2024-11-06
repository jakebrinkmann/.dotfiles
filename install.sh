set -eoux

# https://brew.sh/
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&
  brew install stow

# https://ohmyz.sh/
[ ! -e ~/.oh-my-zsh ] &&
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.oh-my-zsh/custom/plugins/you-should-use &&
  [ -f ~/.zshrc ] && mv ~/.zshrc{,.bak}

[ ! -e ~/.dotfiles ] &&
  git clone git@github.com:jakebrinkmann/.dotfiles.git ~/.dotfiles

cd "$HOME/.dotfiles/dots" || exit
stow --adopt -t ~ bash git nvim brew ripgrep python psql zsh bin ssh task jq alacritty
stow --adopt -t ~/.config/ vscode
[[ "$OSTYPE" == "darwin"* ]] && stow -t ~/Library/Application\ Support vscode

cd "$HOME" || exit
brew install --cask font-hack-nerd-font
brew bundle --global

if grep -qE '^ID=(arch|manjaro)$' /etc/os-release; then
  sudo pacman --noconfirm -S \
    base-devel \
    yay \
    alacritty
  yay -S ttf-hack-nerd --noconfirm
else
  xcode-select --install
fi

bob use stable # install nvim
