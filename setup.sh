#!/bin/bash

PREFIX=${PREFIX:-${HOME}}

function symlink_force(){
    for file in `ls -A ${PWD}/dots`; do
        if [[ -a ${PREFIX}/${file} ]] ; then
            if [[ ! -L ${PREFIX}/${file} ]]; then
                echo "Moving ${PREFIX}/${file} to ${PREFIX}/${file}.backup"
                mv -f ${PREFIX}/${file} ${PREFIX}/${file}.backup
            fi
        fi
        ln -sf "${PWD}/dots/${file}" ${PREFIX}/${file}
    done
}

echo "Installing..."
echo "Forcing symlink creation. Godspeed!"
symlink_force
echo "Installing Vundle for Vim..."
git clone https://github.com/VundleVim/Vundle.vim.git ${PREFIX}/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "Done."
