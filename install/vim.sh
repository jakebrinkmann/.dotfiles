#!/usr/bin/env bash
# Script to install Vim (and setup Vundle)
# Usage:
#        ./install/vim.sh

# All must be run as root
[ $(/usr/bin/id -u) -eq 0 ] \
    && echo 'Must NOT be run as root!' \
    && exit 1


# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    sudo yum install --assumeyes \
        vim
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    sudo pacman -S --noconfirm \
           vim
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    sudo apt-get install --assume-yes \
            vim
fi
# =================================================================


echo "Installing Vundle for Vim..."
PREFIX=${PREFIX:-${HOME}}
mkdir -p ${PREFIX}/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ${PREFIX}/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

###### TODO: Really, will want to set this as the font in the terminal #####
# echo "Installing Nerd Fonts..."
# mkdir -p ~/.local/share/fonts
# cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
