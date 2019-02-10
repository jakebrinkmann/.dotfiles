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
echo "Done."
