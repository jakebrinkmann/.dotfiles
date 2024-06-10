#!/bin/bash

set -e # Exit on error
set -u # Treat unset variable as error
set -x # Trace commands
set -o pipefail

install() {
	echo Hello World
}

# Call the requested function and pass the arguments as-is
"$@"
