#!/bin/bash
#
# https://github.com/picodotdev/alis/blob/master/alis-packages.sh
#
# -- color
RED="\033[0;91m"
GREEN="\033[0;92m"
BLUE="\033[0;96m"
WHITE="\033[0;97m"
NC="\033[0m"

# --------------------------------
RUN_SCRIPT_DIRECTORY="$(pwd)"
## ---- ASK FOR SUDO | [TEST: OK] ----
function ask_sudo() {
  echo "$msg_st00_3"
  sudo pwd >> /dev/null
}
# ---- include messages file ----
#
function source_msg() {
    local MSG_FILE="$RUN_SCRIPT_DIRECTORY/messages.sh"
    if [ -f $MSG_FILE ]; then
        source "$MSG_FILE"
    else
        echo -e "${RED}-- (!) ERROR:${NC} MISSING $(MSG_FILE) TO SOURCE."
        echo -e "${RED}-- CHECK SCRIPT STARTUP DIRECTORY: --${NC}"
        pwd | ls -la
        echo -e "---- ---- STOP ---- ----"
        exit 1
    fi
}
#
function missing_firmware() {
  # [2023-12-02] Solution for missing firmware ""; ""; ""; "";
 # --t_OK-- echo -e "${msg_st02_1}"
 # --t_OK-- sleep 3
 # --t_OK-- # sudo pacman -S --noconfirm --needed linux-firmware
 # --t_OK-- sudo pacman -Q linux-firmware
 # --t_OK-- echo -e "${msg_st02_2}"
 # --t_OK-- # sudo pacman -S --noconfirm --needed linux-firmware-qlogic
 # --t_OK-- sudo pacman -Q linux-firmware-qlogic
 # --t_OK-- echo -e "${msg_st02_3}"
  # NOTE: may be 'base' 'curl' 'make' are already installed
  # sudo pacman -S --noconfirm --needed lah curl make cmake base base-devel
  # sudo pacman -S lha
  # echo -e "${msg_st02_4}"
  cd $HOME
  # mkdir -p $HOME/tmp_firmware
  cd $HOME/tmp_firmware
# --t_OK--  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/aic94xx-firmware.tar.gz
# --t_OK--  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/wd719x-firmware.tar.gz
# --t_OK--  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/upd72020x-fw.tar.gz
# --t_OK--  # for archive in "find *"; do sudo tar -xvf "${archive}"; done
  for archive in *; do tar -xvf "${archive}"; done
  # find */ -maxdepth 0 -type d -exec makepkg -s -i {} \;
  find -path './*' -prune -type d -print0 | xargs -0 makepkg -s -i
   # for pkg in (find */ -maxdepth 0 -type d); do makepkg -s -i; done

  #
#   for pkg in */ ; do
#     if [ -d "$pkg" && ! -L "$pkg" ]; then
#       echo "-t- i am in: $(pwd) "
# #-t      makepkg -s -i
#     fi
#   done


  # for pkg in *; do
  #   let zst_file_name="find -type -f -name '*pkg.tar.zst'"
  #   if [ -d "$pkg" ]; then
  #       # Will not run if no directories are available
  #       echo "-- making pakage for: $pkg ; installing --"
  #       makepkg
  #       # makepkg && sudo pacman -U --noconfirm --needed $zst_file_name
  #       echo "--t-- ZST file: $zst_file_name"
  #       makepkg && sudo pacman -Q $zst_file_name
  #       echo "-- installing of $pkg DONE OK --"
  #   fi
  # done
}
#
#
echo "-t- run asking sudo -t-"
sleep 2
ask_sudo
echo "-t- OK asking sudo -t-"
sleep 2
echo "-t- run source messages.sh -t-"
source_msg
echo "-t- OK source messages.sh -t-"
sleep 2
echo "-t- run missing_firmware -t-"
missing_firmware
echo "-t- OK missing_firmware -t-"
sleep 2
find */ -maxdepth 0 -type d -exec echo {} \;
sleep 2
#
#



# ---------------------------
# TEST_001 -- NO
#
# tar: find *: Cannot open: No such file or directory
# tar: Error is not recoverable: exiting now
# t__missing_firmware.sh: line 57: let: zst_file_name=find -type -f -name '*pkg.tar.zst': syntax error: invalid arithmetic operator (error token is "'*pkg.tar.zst'")
# t__missing_firmware.sh: line 57: let: zst_file_name=find -type -f -name '*pkg.tar.zst': syntax error: invalid arithmetic operator (error token is "'*pkg.tar.zst'")
# t__missing_firmware.sh: line 57: let: zst_file_name=find -type -f -name '*pkg.tar.zst': syntax error: invalid arithmetic operator (error token is "'*pkg.tar.zst'")
# -t- OK missing_firmware -t-
# t__missing_firmware.sh: line 85: let: aic94xx-firmware.tar.gz: syntax error: invalid arithmetic operator (error token is ".tar.gz")
# t__missing_firmware.sh: line 85: let: upd72020x-fw.tar.gz: syntax error: invalid arithmetic operator (error token is ".tar.gz")
# t__missing_firmware.sh: line 85: let: wd719x-firmware.tar.gz: syntax error: invalid arithmetic operator (error token is ".tar.gz")
# [al@pc|tests]$
# ----------------------------
