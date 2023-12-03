#!/bin/bash
#
TEST_NAME=" -t- function 'configure_time' test. (with sudo at start and without)"
#
# ---- ---- RUN INCLUDED ---- ----
#
set -euo pipefail
# set -xeuo pipefail
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
# ---- INCLUDE MESSAGES FILE | [TEST: OK]----
# source ./malis-messages.sh         # direct command
function source_msg() {
    local MSG_FILE="$RUN_SCRIPT_DIRECTORY/malis-messages__v01.sh"
    if [ -f $MSG_FILE ]; then
        source "$MSG_FILE"
    else
        # echo -e "${RED}-- (!) ERROR:${NC} MISSING $(MSG_FILE) TO SOURCE."
        echo -e "${RED}-- (!) ERROR:${NC} * ${BLUE}MISSING${NC} ${GREEN}${MSG_FILE}${NC} ${BLUE}TO SOURCE.${NC} *"
        echo -e "${RED}-- CHECK SCRIPT STARTUP DIRECTORY: --${NC}"
        pwd | ls -la
        echo -e "---- ---- STOP ---- ----"
        exit 1
    fi
}
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
# ---- CONFIGURE TIME | [TEST: OK]
# function configure_time() {
#   echo "$msg_st00_4"
#   timedatectl status
#   timedatectl set-timezone UTC
#   timedatectl set-timezone "Europe/Moscow"
#   timedatectl set-ntp true
#   echo "$msg_st00_5"
#   timedatectl status
#   echo "$msg_st00_6"
# }
#
#
# ---- RU locale, keyboard [TEST: TODO]
#
function ru_locale() {
  ask_sudo
  #-to-test-# sudo echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
  #-t -- command 1
  echo "-t- START 1-st test (locale_1.gen add to the rnd of file)"
  #
  sudo echo "ru_RU.UTF-8 UTF-8" >> ./locale_1.gen
  # eval "(sudo echo 'ru_RU.UTF-8 UTF-8' >> ./locale_1.gen)"
  #
  echo "-t- END 1-st test (locale_1 add to the rnd of file)"
  echo "-- result for command_1: <<target string have to be at the end of a file>> :"
  cat ./locale_1.gen | grep "ru_RU"
  #
  #-t -- command 2
  echo "-t- START 2-nd test (sed locale_2.gen with absolute path)"
  #
  sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" "/mnt/hdd3/AL/0W/My_OS_Install_Script/os_install/ArchLinux_script/tests/t__ru_locale/locale_2.gen"
  #
  echo "-t- END 2-nd test (sed locale_2.gen with absolute path)"
  echo "-- result for command_2: <<target string have to be corrected in te middle of a file>> :"
  cat ./locale_1.gen | grep "ru_RU"
  #
  #-t -- command 3
  echo "-t- START 3-rd test (sed locale_3.gen with relative path)"
  #
  sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" "./locale_3.gen"
  #
  echo "-t- END 3-rd test (sed locale_3.gen with relative path)"
  echo "-- result for command_2: <<target string have to be corrected in te middle of a file>> :"
  cat ./locale_1.gen | grep "ru_RU"
  #
  # sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" <<< ./locale_2.gen
  # sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" << /etc/locale.gen
  # sudo locale-gen
  #
  # cd $HOME
  # touch .xinitrc
  # echo "setxkbmap -lauout us,ru -option grp:caps_toggle" >> .xinitrc
  echo "$msg_st00_7"
}

#
# -----------------------
echo -e "${TEST_NAME}"
def_script_variables
source_msg
# msg_welcome
ask_sudo
echo -e "---- START TEST FUNCTION ----"
ru_locale
echo -e "---- END TEST FUNCTION ----
"
#
# NOTE: TEST RESULTS:
# 1) main script have to be executed as 'root' to work correcly.
# 2) local function 'ask root' do not give apprpriate permission to funsction 'sed'
#    to operate as root with locale.gen file. Even additional execution inside function
#    does not solve accsses problem.
