#!/bin/bash
#
# -- test for package list

PKGS=(
    "mc"
    "vim"
#    "kitty"
)
#
#
#
for PKG in "${PKGS[@]}"; do
   sudo pacman -Qs "$PKG"
done
#
echo "---- sh-01 OK ----"
