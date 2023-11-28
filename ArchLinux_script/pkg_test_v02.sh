#!/bin/bash

#
# -- test for package list

PKGS=(
#    "mc"
#    "vim"
    "kitty"
    "emacs"
)
#
#
#
for PKG in "${PKGS[@]}"; do
   sudo pacman -Qs "$PKG"
done
#
echo "--- sh-2 OK ----"
