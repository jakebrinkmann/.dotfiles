#!/bin/bash


function symlink_force(){
    # Runtime Configurations! (or, runcoms)
    ROOT=./dots
    PREFIX=${PREFIX:-${HOME}}
    mkdir -p $PREFIX
    for src in $(find -H "$ROOT" -name '*.symlink' -not -path '*.git*'); do
        dst="${PREFIX}/.$(basename "${src%.*}")"
        ln -sf $(readlink -f ${src}) ${dst}
    done

    # Functions!
    ROOT=./bin
    PREFIX=${PREFIX:-/usr/local/bin}
    mkdir -p $PREFIX
    for file in $(find "${ROOT}" -type f ); do
	    f=$(basename $file);
	    ln -sf $(readlink -f $file) ${PREFIX}/$f; 
    done
}
echo "Installing..."
echo "Forcing symlink creation. Godspeed!"
symlink_force

echo "Installing Vundle for Vim..."
PREFIX=${PREFIX:-${HOME}}
mkdir -p ${PREFIX}/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ${PREFIX}/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Done."
