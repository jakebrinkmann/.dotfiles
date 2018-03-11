#!/bin/bash

PREFIX=${PREFIX:-${HOME}}
DOTFILES_ROOT=./dots

function symlink_force(){
    for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
      do
        dst="${PREFIX}/.$(basename "${src%.*}")"
        ln -sf $(readlink -f ${src}) ${dst}
    done
}

echo "Installing..."
echo "Forcing symlink creation. Godspeed!"
symlink_force
echo "Installing Vundle for Vim..."
mkdir -p ${PREFIX}/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ${PREFIX}/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "Done."
