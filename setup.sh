#!/bin/bash

function symlink_force(){
    for file in `ls -A ${PWD}/dots`; do
        if [[ -d ~/${file} ]] ; then
            if [[ ! -L ~/${file} ]]; then
                echo "Moving ~/${file} to ~/${file}.backup"
                mv -f ~/${file} ~/${file}.backup
            fi
        fi
        ln -sf "${PWD}/dots/${file}" ~/${file}
    done
}

echo "Installing..."

cd ~/.dotfiles

echo "Forcing symlink creation. Godspeed!"
symlink_force

echo "Done."
