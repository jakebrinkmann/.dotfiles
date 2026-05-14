# Make sure we can sudo, to install homebrew
sudo whoami

set -eoux

confirm() {
  local msg="$1" default="${2:-Y}"
  local prompt
  [[ "$default" == "Y" ]] && prompt="[Y/n]" || prompt="[y/N]"
  read -r -p "  --> $msg $prompt " response
  response="${response:-$default}"
  [[ "$response" =~ ^[Yy]$ ]]
}

# https://brew.sh/
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || true
eval "$(/opt/homebrew/bin/brew shellenv)" || true
brew install stow

# https://ohmyz.sh/
[ ! -e ~/.oh-my-zsh ] &&
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.oh-my-zsh/custom/plugins/you-should-use &&
  [ -f ~/.zshrc ] && mv ~/.zshrc{,.bak}

[ ! -e ~/.dotfiles ] &&
  git clone git@github.com:jakebrinkmann/.dotfiles.git ~/.dotfiles

cd "$HOME/.dotfiles/dots" || exit
stow --adopt -t ~ bash git nvim brew ripgrep python psql zsh bin ssh task jq alacritty act copilot
stow --adopt -t ~/.config/ vscode
[[ "$OSTYPE" == "darwin"* ]] &&
  stow -t ~/Library/Application\ Support vscode &&
  defaults write com.apple.finder AppleShowAllFiles TRUE &&
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2

cd "$HOME" || exit
brew bundle --file ~/.Brewfile

confirm "Install global Python packages (virtualenv, pip, strip-tags)?" &&
  bash ~/.dotfiles/install/brew-python.sh

confirm "Install AWS tooling (awscli, sam, cfn-lint)?" "n" &&
  bash ~/.dotfiles/install/brew-aws.sh

if grep -qE '^ID=(arch|manjaro)$' /etc/os-release; then

  sudo pacman -Syu --noconfirm $(grep -v ^# install/arch/packages.txt | xargs)
  yay -Syu --noconfirm "$pkg" $(grep -v ^# install/arch/AUR.txt | xargs)

  sudo systemctl enable --now docker
  # # add resource limits to a Docker service using systemd
  # [Service]
  # MemoryLimit=10G
  # CPUShares=50
  sudo usermod -aG docker $USER

  # Mouse mode for systemctl (browser resource explorer)
  sudo systemctl enable --now cockpit.socket

  # Get hostname accessable on LAN
  sudo hostnamectl set-hostname thinkpad-t490s
  sudo systemctl enable --now avahi-daemon
  sudo systemctl disable --now systemd-resolved
  # sudo sed -i 's/mdns_minimal/mdns4_minimal/' /etc/nsswitch.conf
  # sudo sed -i 's/dns$/dns mdns4/' /etc/nsswitch.conf

  sudo systemctl daemon-reload
  sudo systemctl restart systemd-networkd

  ping thinkpad-t490s.local
  echo '/home/linuxbrew/.linuxbrew/bin/zsh' | sudo tee -a /etc/shells >/dev/null &&
    chsh -s /home/linuxbrew/.linuxbrew/bin/zsh
else
  xcode-select --install || true
fi

confirm "Set up Neovim via bob?" &&
  bob use stable &&
  nvim --version
confirm "Install Node.js LTS via nvm?" &&
  nvm install --lts &&
  node --version &&
  npm install -g gitnexus
