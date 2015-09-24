#!/bin/bash

function symlink_force(){
    for file in `ls -A ${PWD}/dots`; do
        if [[ -a ~/${file} ]] ; then
            if [[ ! -L ~/${file} ]]; then
                echo "Moving ~/${file} to ~/${file}.backup"
                mv -f ~/${file} ~/${file}.backup
            fi
        fi
        ln -sf "${PWD}/dots/${file}" ~/${file}
    done
}

echo "Installing..."

cd ~/.dots

echo "Forcing symlink creation. Godspeed!"
symlink_force

echo "Done."
