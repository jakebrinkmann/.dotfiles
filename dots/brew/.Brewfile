# Get latest everything:
# 	brew update && brew bundle
#
# updates homebrew itself:
# 	brew update
# upgrade all individual packages:
# 	brew upgrade <package>
#
# brew bundle install
# brew bundle check --debug
# brew bundle cleanup --force

# set arguments for all "brew install --cask" commands
cask_args appdir: "/Applications", no_quarantine: true

# ---------------------------------------------------------------------------------------------------
tap "homebrew/bundle"
tap "buo/cask-upgrade"
# ------------------------------------------------------------------------------
brew "zsh"
brew "zsh-autosuggestions"
brew "powerlevel10k"
brew "fortune"
cask "alacritty"
brew "terminal-notifier" # for bgnotify on OSX
# ------------------------------------------------------------------------------
brew "coreutils"
brew "stow"
brew "cmake"
brew "zip"
brew "tree"
brew "gcc"
brew "llvm"
brew "bash"
brew "gsed"
brew "watch"
brew "zlib"
brew "fd"
brew "fzf"
brew "bat"
brew "bat-extras"
brew "ripgrep"
brew "bob" # neovim version manager
brew "netcat"
brew "telnet"
brew "doggo"
brew "nmap"
brew "ansifilter"
brew "ncdu"
# ------------------------------------------------------------------------------
brew "lazygit"
brew "gh"
brew "act" # github actions local runner
brew "pre-commit"
brew "git-secrets"
brew "git-lfs"
brew "git-delta"
# ------------------------------------------------------------------------------
brew "w3m"
brew "httpie"
# cask "httpie"  # httpie desktop
brew "jq"
tap "noahgorstein/tap"
brew "noahgorstein/tap/jqp"
brew "yq"
brew "speedtest-cli"
brew "ffmpeg"
tap "lucapette/tap"
brew "lucapette/tap/fakedata"
cask "postman"
cask "devtoys"
cask "docker"
brew "diffoci"
# brew "jmeter"
cask "chatgpt"
brew "yt-dlp"
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
brew "pgformatter"
brew "postgresql@14"
brew "libpq"
brew "pyenv" # python version manager
brew "poetry"
brew "ruff"
brew "cookiecutter"
brew "rustup"
# brew "node@20"
brew "nvm" # node version manager
brew "prettier"
brew "yarn"
brew "typescript"
brew "golang"
# brew "dotnet-sdk"
# ------------------------------------------------------------------------------
brew "awscli", link: true
brew "awslogs"
brew "aws-sso-cli"
brew "aws-nuke"
cask "session-manager-plugin"
tap "lucagrulla/tap"
brew "lucagrulla/tap/cw" # CloudWatch logs
brew "cfn-lint"
# ------------------------------------------------------------------------------
brew "stylua"
brew "yamllint"
brew "codespell"
brew "shellcheck"
# ------------------------------------------------------------------------------
brew "task"
brew "timewarrior"
# ------------------------------------------------------------------------------
brew "scrcpy"
cask "android-platform-tools"
# ------------------------------------------------------------------------------
brew "zk", args: ["HEAD"]
cask "obsidian"
cask "vscodium"
cask "chromium"
cask "keepingyouawake"

# brew remove --force $(brew list --formula)
# brew remove --cask --force $(brew list)
