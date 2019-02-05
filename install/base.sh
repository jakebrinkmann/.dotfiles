#!/usr/bin/env bash
# Installs baseline tools and dependencies
# (likely those needed by other packages)

# Common-names where possible to reduce distro-based complexity
COMMON_PKGS="
    vim
    git
    jq
    wget
	  curl
	  httpie
	  bash-completion
	  sudo
"

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
	  && echo 'Must be run as root!' \
	  && exit 1


# Distro-speciic Dependencies =====================================
if [ -n "$(type yum 2>/dev/null)" ]; then       ## CentOS/Fedora ##
    # Allow up-to-date version of git
    rpm -U http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
    # all common and extra-packages
    yum install --assumeyes \
        epel-release \
	      which \
        $COMMON_PKGS
elif [ -n "$(type pacman 2>/dev/null)" ]; then   ## Arch/Manjaro ##
    # NOTE: refreshing cached repo/mirrors metadata
    pacman -Syy
    pacman -S --noconfirm \
	         which \
           $COMMON_PKGS
elif [ -n "$(type apt-get 2>/dev/null)" ]; then ## Debian/Ubuntu ##
    # NOTE: need to refresh (not upgrade!) cache metadata
    #       (upgrade would cause non-deterministic builds!)
    apt-get update
    # Allow `--fix-missing` to fetch required deps not already installed.
    apt-get install --assume-yes --fix-missing \
            build-essential \
            software-properties-common \
            $COMMON_PKGS
fi
# =================================================================

# --------------------------------------------------------------
# Replace this section with any generic configuration/tooling...
# --------------------------------------------------------------
