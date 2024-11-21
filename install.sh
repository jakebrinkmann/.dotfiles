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
stow --adopt -t ~ bash git nvim brew ripgrep python psql zsh bin ssh task jq alacritty act
stow --adopt -t ~/.config/ vscode
[[ "$OSTYPE" == "darwin"* ]] && stow -t ~/Library/Application\ Support vscode

cd "$HOME" || exit
brew install --cask font-hack-nerd-font
brew bundle --global

if grep -qE '^ID=(arch|manjaro)$' /etc/os-release; then

  sudo pacman -Syu --noconfirm $(grep -v ^# install/arch/packages.txt | xargs)
  yay -Syu --noconfirm "$pkg" $(grep -v ^# install/arch/AUR.txt | xargs)

  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER

  # Get hostname accessable on LAN
  sudo hostnamectl set-hostname thinkpad-t490s
  sudo systemctl enable --now avahi-daemon
  sudo systemctl disable --now systemd-resolved
  # sudo sed -i 's/mdns_minimal/mdns4_minimal/' /etc/nsswitch.conf
  # sudo sed -i 's/dns$/dns mdns4/' /etc/nsswitch.conf

  sudo systemctl daemon-reload
  sudo systemctl restart systemd-networkd

  ping thinkpad-t490s.local
else
  xcode-select --install
fi

echo '/home/linuxbrew/.linuxbrew/bin/zsh' | sudo tee -a /etc/shells >/dev/null &&
  chsh -s /home/linuxbrew/.linuxbrew/bin/zsh

bob use stable &&
  nvim --version
