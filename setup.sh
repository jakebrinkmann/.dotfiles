#!/bin/bash

function symlink_force(){
    # Runtime Configurations! (or, runcoms)
    ROOT=./dots
    for src in $(find -H "$ROOT" -name '*.symlink' -not -path '*.git*'); do
        dst="${PREFIX:-${HOME}}/.$(basename "${src%.*}")"
        ln -sf $(readlink -f $src) $dst
    done

    # Functions!
    ROOT=./bin
    CANSUDO=""
    command -v sudo > /dev/null && CANSUDO="sudo"
    for file in $(find "$ROOT" -type f ); do
	    f=$(basename $file);
	    $CANSUDO ln -sf $(readlink -f $file) ${PREFIX:-/usr/local/bin}/$f;
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

###### TODO: Really, will want to set this as the font in the terminal #####
# echo "Installing Nerd Fonts..."
# mkdir -p ~/.local/share/fonts
# cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
echo "Done."
