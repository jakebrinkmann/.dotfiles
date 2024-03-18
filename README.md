# dotfiles
> I'm going to lay this brick as perfectly as a brick can be laid 🧱

[![Build Status][travis-image]][travis-url]
[![Docker Hub Status][docker-image]][docker-url]
[![GitHub release][github-image]][github-url]

[travis-image]: https://img.shields.io/travis/jakebrinkmann/dotfiles/primary.svg?style=flat-square
[travis-url]: https://travis-ci.org/jakebrinkmann/dotfiles
[docker-image]: https://img.shields.io/docker/automated/jbrinkmann/dotfiles.svg?style=flat-square
[docker-url]: https://hub.docker.com/r/jbrinkmann/dotfiles/tags/
[github-image]: https://img.shields.io/github/last-commit/jakebrinkmann/dotfiles.svg?style=flat-square
[github-url]: https://github.com/jakebrinkmann/dotfiles

sensible hacker defaults focused towards a reusable Debian ([Stretch][deb-rel-url]) docker runtime environment

[deb-rel-url]: https://www.debian.org/releases/

![](https://user-images.githubusercontent.com/4110571/51054150-734f3700-15a1-11e9-9939-4a14269b2685.png)

#### Contents

* [About](#about-)
* [Dependencies](#dependencies-)
* [Usage](#usage-)
* [Development](#development-)
* [Contributing](#contributing-)
* [Meta](#meta-)

## About [&#x219F;](#contents)

The project has multiple main topics, summarized here:

* `dotfiles`: the "[runcoms](https://en.wikipedia.org/wiki/Run_commands)" (init configs) of the tools I use
* `setups`: scripts to bootstrap the installation of tools
* `docker`: pre-existing environment with all tools installed
* `ci`: run builds after every pushed commit

It is expected that this project only contains generic tools.
Other language-specific environments are then children of this base project.

However, the `dotfiles` and `setups` should work on any debian system, and not be coupled to Docker/CI.

## Dependencies [&#x219F;](#contents)

These tools must first be installed on the system:

* [Docker](https://docs.docker.com/install/), create, deploy, and run applications by using containers.
* [Brew](https://brew.sh/), manage software dependencies and installation.
* [GNU stow](http://www.gnu.org/software/stow/), a free, portable, lightweight symlink farm manager.

## Usage [&#x219F;](#contents)

To quickly run the pre-built environment:

```sh
docker pull jbrinkmann/dotfiles:latest
```

This project has a quick-start to jump into the latest image:

```sh
# Note: this will run a release version tag
#       which should match the `:latest` tag
make run
```


## Development  [&#x219F;](#contents)

To Download/Install this project directly onto a host machine (helpful when I want tofly native on a machine, without the additional overhead of containers... trading off for reproducibility in my environment, though):

```bash
# ssh-keygen -t ed25519 -C "your_email@example.com"
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# eval $(/opt/homebrew/bin/brew shellenv) && brew install stow

# https://ohmyz.sh/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# https://monaspace.githubnext.com/
# brew tap homebrew/cask-fonts
# brew install font-hack-nerd-font

git clone git@github.com:jakebrinkmann/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles/dots
stow -t ~ bash git nvim brew ripgrep python psql vim zsh bin ssh

cd ~
brew bundle install
```

To build the Docker image locally:

```sh
# docker build ...
make image
```


## Contributing  [&#x219F;](#contents)

No contribution is too small!

## Meta [&#x219F;](#contents)

Jake Brinkmann – [@jakebrinkmann](https://twitter.com/jakebrinkmann) – jakebrinkmann@gmail.com

Distributed under the MIT license. See ``LICENSE.txt`` for more information.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and [Conventional Commit Messages](https://www.conventionalcommits.org/en/v1.0.0-beta.2/#summary).

[https://github.com/jakebrinkmann/dotfiles](https://github.com/jakebrinkmann//dotfiles)

---
---

[&#x219F; Back to Top &#x219F;](#readme)
