#!/bin/bash
#
# -- test for package list

source "malis-packages.conf"

PKGS=(
    "mc"
    "vim"
#    "kitty"
)
#
#
#
for PKG in "${PKGS[@]}"; do
   echo "#### #### #### ####"
   sudo pacman -Qs "$PACKAGES_PACMAN"
   echo "#### #### #### ####"
done
#
echo "---- sh-01 OK ----"
