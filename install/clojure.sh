#!/usr/bin/env bash
# Generic script to install Clojure compiler on many Linux flavors
# Usage:
#        sudo ./install/clojure.sh
CLOJURE_VERSION=1.10.0.411

# Use common-names where possible to reduce distro-specific entropy
COMMON_PKGS=rlwrap

# All must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
	  && echo 'Must be run as root!' \
	  && exit 1


# Distro-speciic Dependencies =========================
## CentOS/Fedora ##
if [ -n "$(type yum 2>/dev/null)" ]; then
    yum install --assumeyes \
        java-1.8.0openjdk \
        $COMMON_PKGS
## Arch/Manjaro ##
elif [ -n "$(type pacman 2>/dev/null)" ]; then
    pacman -S --noconfirm \
           jdk10-openjdk \
           $COMMON_PKGS
## Debian/Ubuntu ##
elif [ -n "$(type apt-get 2>/dev/null)" ]; then
    apt-get install --assume-yes \
        openjdk-8-jdk-headless \
        $COMMON_PKGS
fi
# =====================================================

# Install Clojure Compiler and clj-wrapper JARs
# //clojure.org/guides/getting_started
curl -O https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh
bash ./linux-install-$CLOJURE_VERSION.sh
rm ./linux-install-$CLOJURE_VERSION.sh

# Leiningen is a very popular plugin/build tool
# //leiningen.org
curl -fsSLo /usr/local/bin/lein \
    https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod 755 /usr/local/bin/lein

# Boot is also a popular build/task runner
# //boot-clj.com
curl -fsSLo /usr/local/bin/boot \
     https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh
chmod 755 /usr/local/bin/boot

# Verify installation, and download any required core libraries
for CMD in \
    'clojure -e "(clojure-version)"' \
        'LEIN_ROOT=1 lein self-install' \
        'BOOT_AS_ROOT=yes boot -V'; do
    echo -n "Running '$CMD' ... "
    eval $CMD &>/dev/null

    # Display test OK/FAILED
    [ $? = 0 ] \
        && echo -e '\E[32m'"\033[1m[OK]\033[0m" \
        || echo -e '\E[31m'"\033[1m[FAIL]\033[0m"
done
