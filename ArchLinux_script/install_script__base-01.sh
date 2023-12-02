#!/bin/bash
#
# <2023-11-26> _ Base file to create script for my cusom OS installation
# this version is for monolith script to decompose further
#
# TODO [0/7]
# - [ ] 1) ::dev: LOG functional;
# - [ ] 2) ::dev: additional info about packages for every stage (in LOG folder);
# - [ ] 3) define what packages to install with official installer;
# - [ ] 4) NOTE: get & save .json from official installer;
# - [ ] 5) discover how to echo string to a proper section of a file (maybe "sed");
# - [ ] 6) get list of missing firmware on PC;
# - [ ] 7) ::maybe: ? colorise messages ?
#
#
# #############################################################################################################
#
# ---- SCRIPT SELF PREPARATION ----
# ## x - display command before executing
# ## e - script stops on error
# ## u - error if undefined variable
# ## o pipefail - script fails if command piped fails
#
set -euo pipefail
# -- for debugging
# set -xeuo pipefail
#
##############################################
# | STAGE-00 | - PREPARATIONS;
##############################################
#
# ---- COMMON STATIC VARIABLES ----
#
function def_script_variables() {
  RUN_SCRIPT_DIRECTORY="$(pwd)"
  USER_CONFIG_DIRECTORY="$HOME/.config"
  USER_FONTS_DIRECTORY="/usr/share/fonts"
  USER_SCRIPTS_DIRECTORY="/usr/local/bin"
  # -- NOTE: maybe set this filnames:
  # RUN_SCRIPT_CONF_FILE="install__script.conf"
  # RUN_SCRIPT_LOG_FILE="install__script.log"
  # RECOVERY_CONF_FILE="install__recovery.conf"
  # RECOVERY_LOG_FILE="install__recovery.log"
  # PACKAGES_CONF_FILE="install__packages.conf"
  # PACKAGES_LOG_FILE="install__packages.log"
  # COMMONS_CONF_FILE="install__commons.conf"
  # PROVISION_DIRECTORY="$RUN_SCRIPT_DIRECTORY/files/"
  # # -- color
  RED="\033[0;91m"
  GREEN="\033[0;92m"
  BLUE="\033[0;96m"
  WHITE="\033[0;97m"
  NC="\033[0m"
}
#
# ---- INCLUDE MESSAGES FILE ----
# source ./messages.sh         # direct command
#
function source_msg() {
    local MSG_FILE="$RUN_SCRIPT_DIRECTORY/messages.sh"
    if [ -f $MSG_FILE ]; then
        source "$MSG_FILE"
    else
        # echo -e "${RED}-- (!) ERROR:${NC} MISSING $(MSG_FILE) TO SOURCE."
        echo -e "${RED}-- (!) ERROR:${NC} * ${BLUE}MISSING${NC} ${GREEN}${MSG_FILE1}${NC} ${BLUE}TO SOURCE.${NC} *"
        echo -e "${RED}-- CHECK SCRIPT STARTUP DIRECTORY: --${NC}"
        pwd | ls -la
        echo -e "---- ---- STOP ---- ----"
        exit 1
    fi
}
#
# ---- ECHO WELCOME MESSAGE | [TEST:OK]
function msg_welcome() {
  echo -e "$msg_line"
  echo -e "$msg_001_plan"
  echo -e "$msg_line"
  sleep 3
}
#
# ---- ASK FOR SUDO | [TEST: OK]
function ask_sudo() {
  echo "$msg_st00_3"
  sudo pwd >> /dev/null
}
#
# ---- CONFIGURE TIME | [TEST: TODO]
function configure_time() {
  echo "$msg_st00_4"
  timedatectl status
  timedatectl set-timezone UTC
  timedatectl set-timezone "Europe/Moscow"
  timedatectl set-ntp true
  echo "$msg_st00_5"
  timedatectl status
  echo "$msg_st00_6"
}
#
# ---- RU locale, keyboard [TEST: TODO]
#
function ru_locale() {
  sudo echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
  # :OR:
  # sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" << /etc/locale.gen
  sudo locale-gen
  cd $HOME
  touch .xinitrc
  echo "setxkbmap -lauout us,ru -option grp:caps_toggle" >> .xinitrc
  echo "$msg_st00_7"
}
#
# ---- SETUP PACMAN | [TEST: TODO]
#
function setup_pacman() {
  # TODO: choose --v1: to edit /etc/pacman.conf; --v2: copy dotfile as root;
  # --v1: uncomment and/or set values:
  # TODO: fix editing by .sh directly in proper section [options] of pacman.conf
  #       >> :OR: add to the end of file via ">>";
    # CheckSpace                # -> ? uncomment if default is commented;
    # VerbosePkgLists           # -> uncomment;
    # ParallelDownloads = 50    # uncomment and set to "50";
    # sudo sed -i "s/#Color/Color/" /etc/pacman.conf
    # sudo sed -i "s/#CheckSpace/CheckSpace/" /etc/pacman.conf
    # sudo sed -i "s/#ParallelDownloads = 5/ParallelDownloads = 50/" /etc/pacman.conf
    #
    #
    # -- v2:
    # sudo cp -f "$script_folder/pacman.conf" /etc/
    # :OR: ( ? overwrite without prompt? )
    #? sudo \cp "$script_folder/pacman.conf" /etc/
}
#
##############################################
# ---- STAGE_00 EXEC-FUNCTION ----
#
function stage_00() {
  def_script_variables
  source_msg
  msg_welcome
  ask_sudo
  configure_time
  ru_locale
}
#
# TODO: develop & add in stage_00:
#  1) infrastructure for script LOGGING;
#     # see "alis"
#  2) save additional info about packages at all stages;
#     # save package list: pacman -Q > $HOME/pkg_list__start_point.txt
#     # count packages:  pacman -Q | wc -l >> $HOME/pkg_list__start_point.txt
#
##############################################
# ---- STAGE-01 ----
##############################################
#
function stage_01() {
  echo -e "$msg_st01_0"
  # init keys;
  sudo pacman-key --init
  echo -e "$msg_st01_1"
  # verify master keys;
  sudo pacman-key --populate
  echo -e "$msg_st01_2"
  # actualize keys;
  sudo pacman-key --refresh-keys
  echo -e "$msg_st01_3"
  # upgrade keys;
  sudo pacman -Sy --noconfirm archlinux-keyring
  echo -e "$msg_st01_4"
  # partial system update;
  sudo pacman -Su --noconfirm
  echo -e "$msg_st01_5"
  # full system update;
  sudo pacman -Syu --noconfirm
  echo -e "$msg_st01_6"
  echo -e "$msg_st01_f"
}
#
##############################################
# ---- STAGE-02 ----
##############################################
# ---- SOLVE ERRORS FOR MISSING FIRMWARE ----
#
# see: /mnt/hdd3/AL/MyNotes/notes/00_rebase/soft/01_OS_install/PossiblyMissingFirmware.org
# TODO: explore what hardware are missing at PC after installation;
# NOTE: if you deside to use AUR repos - install firmware via AUR helpers;
#
function missing_firmware() {
  echo -e "${msg_st02_1}"
  sleep 3
  echo -e "${msg_st02_2}"
  sudo pacman -S linux-firmware-qlogic


  
  echo "---- Missing firmware (aic94xx, wd719x, xhci, bfa, qed, gla1280, qla2xxx ) ----"
  echo "---- Installing 'linux-firmware-qlogic' (4 missings) from arch repo ----"
  echo "---- Downloading, compiling & installing 3 firmwares from AUR repo ----"
  echo "---- (!) Note: curl, make, cmake, base-devel are requered."
  echo "---- Installing some prequistels ('lah' package for archives) ---- "
  sudo pacman -S lah
  cd ~
  mkdir -p ~/tmp_firmware
  cd ~ /tmp_firmware
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/aic94xx-firmware.tar.gz
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/wd719x-firmware.tar.gz
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/upd72020x-fw.tar.gz
  for file in "find *"; do
       sudo tar -xvf "${file}" ; done
  #
  # TODO: ? check // ? what about cd in dirs
# https://stackoverflow.com/questions/25042643/untar-all-gz-in-directories-and-subdirectories
# for pack in "find *.zst"; do          # <- ? will it find in all dirs ?
#       makepkg && sudo packman -U "${pack}" ; done
#
#
# ---- TODO: cycle to cd in every directory, run 'make' & run install.
# contence
# -> makepkg
# -> sudo pacman -U <.....>.zst
# -- v1:
# for d in ./*/ ; do (cd "$d" && make && sudo pacman -U "<................>"); done
#
# -- v2:
#
# for D in ./*; do
#    if [ -d "$D" ]; then
#        cd "$D"
#        run_something
#        cd ..
#    fi
# done
#
#
# -- v2-1
# for i in `ls -d ./*/`
# do
#  cd "$i"
#  command
#  cd ..
# done
#
#
#
#
# -- v3:
#
# cd -P .
# for dir in ./*/
# do cd -P "$dir" ||continue
#   printf %s\\n "$PWD" >&2
#   command && cd "$OLDPWD" ||
# ! break; done || ! cd - >&2
#
#
# ---- NAIL:
cd ~/tmp-firmware/aic94xx-firmware
makepkg
sudo pacman -U aic94xx-firmware-30-10-any.pkg.tar.zst
cd ~/tmp-firmware/wd719x-firmware
makepkg
sudo pacman -U wd719x-firmware-1-7-any.pkg.tar.zst
cd ~/tmp-firmware/upd72020x-fw
sudo pacman -U upd72020x-fw-1\:1.0.0-2-any.pkg.tar.zst
echo "---- Missing firmware installation complete ----"
}
#
#
#
#
#
#
#
#
#
#
#
#
#
#
##############################################
# ---- #### ---- MAIN WORKFLOW ---- #### ----
##############################################
#
#
# ---- #### ---- MAIN WORKFLOW ---- #### ----
#
#
#
#
function main() {
  stage_00
  stage_01
  stage_02
}
#
main
#
#
#
#
#
#
##############################################
##############################################
#
# -----------------------------------------------------------------------------
