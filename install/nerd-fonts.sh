#!/usr/bin/env bash
# Installs several fonts, for more Glyph support
#
#       Rebuild font-cache: fc-cache -f -v
#       Find a font: fc-match -v 'DejaVu Sans'

# Check that a non-root user is caller
[ $(/usr/bin/id -u) -eq 0 ] \
    && { echo 'Cannot run "makepkg" as root!'; exit 1; }

# Check for passwordless SUDO
CANSUDO=""
command -v sudo > /dev/null && CANSUDO="sudo"

# Use standard packages where possible
$CANSUDO pacman -S --noconfirm \
    ttf-freefont \
    adobe-source-code-pro-fonts \
    ttf-nerd-fonts-symbols-mono \
    nerd-fonts

# # Use AUR for community packages
# for pkgname in "nerd-fonts-dejavu-complete" "ttf-unifont"; do
#     ## only download source once
#     [ -d /tmp/$pkgname ] || \
#         git clone https://aur.archlinux.org/$pkgname.git /tmp/$pkgname
#
#     ## force recompile & install all
#     ## --skippgpcheck: ttf-unifont fails from unrecognized MIT pgp key...
#     cd /tmp/$pkgname
#     makepkg -Acsf --skippgpcheck \
#         && $CANSUDO pacman --noconfirm -U *.pkg.tar.xz
# done
