#!/bin/bash
#
# -- test for correct reading of a package list
RED='\033[0;91m'
GREEN='\033[0;92m'
BLUE='\033[0;96m'
WHITE='\033[0;97m'
NC='\033[0m'
#
function init() {
    SCRIPTS="./scr.sh"
    source "${SCRIPTS}"
    MSG_END="---- sh-01 OK ----"
    PKG_LIST="./malis-packages.conf"
    source "${PKG_LIST}"
}
#
function end_pkg() {
    end_pkg="echo ${MSG_END}"
}
#
function main() {
    for PKG in "${PACKAGES_PACMAN}"; do
       sleep 2
       echo "#### ---- current pkg:"
       echo "${PACKAGES_PACMAN}"
       echo "---- ####"
       sleep 2
       # sudo pacman -Qs "$VARIABLE"
       echo "#### ---- cycle done ---- ####"
    done
}
#
#
echo "---- init ----"
init
echo "---- init DONE ----"
sleep 1
echo "---- list of raw pkg ----"
echo "${PACKAGES_PACMAN}"
echo "---- print raw pkg DONE ----"
sleep 1
echo "---- start sanitize variables ----"
sanitize_variables
echo "---- end sanitize variables ----"
echo "---- sanitaized list: "
echo "${PACKAGES_PACMAN}"
sleep 1
# sanitize_variables
# echo "---- run main_scr ----"
# main_scr
# echo "---- run main_scr DONE----"
# sleep 1
echo "---- run main ----"
main
echo "---- run main DONE----"
sleep 1
echo "Stupido bambino"
# vvvv
#
