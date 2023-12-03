#!/usr/bin/env bash
#
# My Arch Linux Install Script (malis)
# Startup file for my cusom OS installation on my PC.
#
# * Current todo [2023-12-02]
# TODO [0/7]
# - [ ] #dev: ? LOG functional;
# - [ ] #dev: ? additional info about packages for every stage;
# - [ ] #define: After official installer [0/4]
#   - [ ] save .json from official installer;
#   - [ ] get list of missing firmware after official install on PC;
#   - [ ] may be 'base' 'curl' 'make' are already installed by official installation;
#   - [ ] what packages to install with official installer;
#         : candidates: curl make cmake base base-devel lha linux-firmware linux-firmware-qlogic
# - [ ] discover how to echo string to a proper section of a file (maybe "sed");
# - [ ] #maybe: ? colorise messages ?
# - [ ] global execution as root is needed to function 'ru_locale'.
#       It needs an access to '/etc/locale.gen' and func 'ask_sudo' has no effect to command 'sed');
# - [ ] check syntax in 'sed' (use "s/pattern-find/pattarn-replace/" or "s|pattern-find|pattarn-replace|")
#
#
# ---- SCRIPT SELF PREPARATION ----
set -euo pipefail
# x - display command before executing
# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
# -- for debugging
# set -xeuo pipefail
#
#
# ---- | STAGE-00 | - PREPARATIONS;
#
function init_config() {
    local COMMONS_FILE="malis-commons__v01.sh"
    # local MESSAGES_FILE="malis-messages__v01.sh"

    source "$COMMONS_FILE"
    source "$COMMONS_CONF_FILE"
    source "$MALIS_CONF_FILE"
    source "$MALIS_MESSAGES_FILE"
}
#
#
# ---- CHECK CURRENT RUN DIRECTORY WITH ANCOR DIRECTORY ($HOME/malis) | [TEST: OK] ----
function check_ancor_dir() {
  echo " ---- if you need it - develop me more: 'check_ancor_dir' ----"
  if [ $RUN_SCRIPT_DIRECTORY == $ANCOR_SCRIPT_DIRECTORY ]; then
  continue
  else
    echo "---- ERROR: Script is started NOT from ANCOR DIRECTIRY. ----"
    echo "---- Current directory is:\n * $RUN_SCRIPT_DIRECTORY \n* ----"
    echo "---- Ancor directory have to be: * '\$HOME/malis' * ----"
    echo "---- Create '~/malis', copy all stuff there and run 'malis.sh' from ancor directory. ----"
    echo "---- EXITING ----"
    exit 1
    # TODO: dialor and autocopy to ancor dir
  fi
# ---- NOTE: from [2023-12-02] NOT IN USE.
#      Expedience depends from 'cd' behavior. Develop other stuff and make
#      a desigion about usage. Also, decide what to do if current run is not from
#      ancor directory.
# -- TODO: Make a decision. Develop appropriete scenarios. Include in malis-messages.sh.
}
#
# ---- TODO: check access to files | [TEST: TODO] ----
#function checkout_files() {
#    local f1="$RUN_SCRIPT_DIRECTORY/$MALIS_MESSAGES_FILE"
#    if [ -f $MALIS_MESSAGES_FILE ]; then
#        source "$MALIS_MESSAGES_FILE"
#    else
#        # echo -e "${RED}-- (!) ERROR:${NC} MISSING $(MSG_FILE) TO SOURCE."
#        echo -e "${RED}-- (!) ERROR:${NC} * ${BLUE}MISSING${NC} ${GREEN}${MSG_FILE}${NC} ${BLUE}TO SOURCE.${NC} *"
#        echo -e "${RED}-- CHECK SCRIPT STARTUP DIRECTORY: --${NC}"
#        pwd | ls -la
#        echo -e "---- ---- STOP ---- ----"
#        exit 1
#    fi
# source ./malis-messages.sh         # direct command
#}
#
#
# ---- ECHO WELCOME MESSAGE | [TEST: OK]
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
# ---- TOCHECK: execute sudo
# /mnt/hdd3/AL/0W/My_OS_Install_Script/example/alis/alis-commons.sh
#
# function execute_sudo() {
#     local COMMAND="$1"
#     if [ "$SYSTEM_INSTALLATION" == "true" ]; then
#         arch-chroot "${MNT_DIR}" bash -c "$COMMAND"
#     else
#         sudo bash -c "$COMMAND"
#     fi
# }
# ---- end TOCHECK ----
#
#
# ---- CONFIGURE TIME | [TEST: OK]
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
# ---- RU locale, keyboard [TEST: OK] (!) need root execution for whole script;
function ru_locale() {
  # v1: simple as a nail;
  # sudo echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
  # v2: more elegant
  sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" "/etc/locale.gen"
  #
  sudo locale-gen
  # cd $HOME
  touch $HOME/.xinitrc
  echo "setxkbmap -lauout us,ru -option grp:caps_toggle" >> $HOME/.xinitrc
  echo "$msg_st00_7"
  # NOTE: [2023-12-03] #MY. Two arrows in Emacs (electric-mode) insert symbols "EOF (end of file)"
  #       and crash reading of a whole script. Switching 'sh-electric-here-document-mode'
  #       gives nothing. Strange bullshit. Possible solution - set "<<<", but
  #       i rewrite command to be a single call of 'sed'.
  # sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" << /etc/locale.gen
# -- NOTE: Need to execute of main script (mail.sh) as root at the begining;
#          'ask_root' function does not solve access as root to '/etc/local.gen'.
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
    sudo sed -i "s|#Color|Color|" "/etc/pacman.conf"
    sudo sed -i "s|#CheckSpace|CheckSpace|" "/etc/pacman.conf"
    sudo sed -i "s|#ParallelDownloads = 5|ParallelDownloads = 50|" "/etc/pacman.conf"
    #
    #
    # -- v2:
    # sudo cp -f "$script_folder/pacman.conf" /etc/
    # :OR: ( ? overwrite without prompt? )
    #? sudo \cp "$script_folder/pacman.conf" /etc/
}
#
# ---- STAGE_00 EXEC-FUNCTION ----
#
function stage_00() {
  msg_welcome
  ask_sudo
  configure_time
  ru_locale
  setup_pacman
}
#
# TODO: develop & add in stage_00:
#  1) infrastructure for script LOGGING;
#     # see "alis"
#  2) save additional info about packages at all stages;
#     # save package list: pacman -Q > $HOME/pkg_list__start_point.txt
#     # count packages:  pacman -Q | wc -l >> $HOME/pkg_list__start_point.txt
#
#
# ---- STAGE-01 ----
#
# ---- STAGE_01 EXEC-FUNCTION ----
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
#
# ---- SOLVE ERRORS FOR MISSING FIRMWARE | [TEST: OK]----
#
# see: /mnt/hdd3/AL/MyNotes/notes/00_rebase/soft/01_OS_install/PossiblyMissingFirmware.org
# TODO: explore what hardware are missing at PC after installation;
# NOTE: if you deside to use AUR repos - install firmware via AUR helpers;
#
function missing_firmware() {
  # [2023-12-02] Solution for missing firmware ""; ""; ""; "";
  echo -e "${msg_st02_1}"
  sleep 3
  sudo pacman -S --noconfirm --needed linux-firmware
  echo -e "${msg_st02_2}"
  sudo pacman -S --noconfirm --needed linux-firmware-qlogic
  echo -e "${msg_st02_3}"
  # NOTE: may be 'base' 'curl' 'make' are already installed
  sudo pacman -S --noconfirm --needed lha curl make cmake base base-devel
  echo -e "${msg_st02_4}"
  cd $HOME
  mkdir -p $HOME/tmp_firmware
  cd $HOME/tmp_firmware
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/aic94xx-firmware.tar.gz
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/wd719x-firmware.tar.gz
  curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/upd72020x-fw.tar.gz
  # -- untar
  for archive in *; do tar -xvf "${archive}"; done
  # ---- TODO: ? check for success ?
  # -- makepkg & install
  for pkg in *; do
    if [ -d "$pkg" ]; then
      cd "$pkg"
      echo -e "${msg_st02_5}"
      makepkg -s -i
      # makepkg -si --noconfirm
      # see #NAIL_01 in .org
      #
      echo -e "${msg_st02_6}"
      cd ..
    fi
  done
  echo -e "${msg_st02_7}"
}
#
function base_pkg() {
echo ""
}
#
#
#
##############################################
# ---- STAGE_00 EXEC-FUNCTION ----
#
#
function stage_02() {
  missing_firmware
}
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
    local START_TIMESTAMP=$(date -u +"%F %T")
    init_config

    execute_step "sanitize_variables"
    execute_step "check_variables"




    execute_step "stage_00"
    execute_step "stage_01"
    execute_step "stage_02"





    local END_TIMESTAMP=$(date -u +"%F %T")
    local INSTALLATION_TIME=$(date -u -d @$(($(date -d "$END_TIMESTAMP" '+%s') - $(date -d "$START_TIMESTAMP" '+%s'))) '+%T')
    echo -e "Installation start ${WHITE}$START_TIMESTAMP${NC}, end ${WHITE}$END_TIMESTAMP${NC}, time ${WHITE}$INSTALLATION_TIME${NC}"
    execute_step "end"
}
#
main "$@"
#
##############################################
##############################################
