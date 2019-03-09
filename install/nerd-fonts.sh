#!/usr/bin/env bash
# Installs Nerd Fonts, for more Glyph support
# //github.com/ryanoasis/nerd-fonts

FILENAME=DejaVuSansMono.zip
PKGVERSN=2.0.0
FILESHA1=701b7e1f6cf9461dfc29515943fa972e423e7251

# Must be run as root
[ $(/usr/bin/id -u) -ne 0 ] \
    && echo 'Must be run as root!' \
    && exit 1

# Download the TrueType font (.ttf) outline files
# (can handle multiple fonts wihtin a single file)
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v$PKGVERSN/$FILENAME

# Verify the data integrity
[ $(shasum $FILENAME | awk '{print $1}') == "$FILESHA1" ] || \
    { echo 'Checksum mismatch'; exit 1; }

# Extract the archive bundle
7z x $FILENAME

# Install into /usr/share/fonts
find . -iname "*.ttf" \
    -not -iname "*Windows Compatible.otf" \
    -execdir install -Dm644 {} "/usr/share/fonts/TTF/{}" \;

# Force a refresh of the font-cache (~/.cache)
fc-cache -f -v

# Check that the font subsitution is working
fc-match --verbose "DejaVuSansMono Nerd Font Mono" \
    |grep 'fullname: "DejaVu Sans Mono Nerd Font Complete Mono"(s)'
