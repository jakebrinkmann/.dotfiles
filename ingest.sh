#!/bin/bash

function symlink_reverse(){
    for file in `ls -A ${PWD}/dots`; do
        if [[ -a ~/${file} ]] ; then
            cp -r ~/${file} "${PWD}/dots/${file}"
        fi
    done
}

echo "Ingesting..."
symlink_reverse
echo "Done."
