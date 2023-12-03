#!/bin/bash
#
TEST_NAME=" -t- function 'check_ancor_dir' test."
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
  ANCOR_SCRIPT_DIRECTORY="$HOME/malis"
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
#
function check_ancor_dir() {
  echo " ---- if you need it - develop me more: 'check_ancor_dir' ----"
  if [ $RUN_SCRIPT_DIRECTORY == $ANCOR_SCRIPT_DIRECTORY ]; then
  continue
  else
    echo "---- ERROR: Script is started NOT from ANCOR DIRECTIRY. ----"
    echo "---- Current directory is: * $RUN_SCRIPT_DIRECTORY * ----"
    echo "---- Ancor directory have to be: * '\$HOME/malis' * ----"
    echo "---- Create '~/malis', copy all stuff there and run 'malis.sh' from ancor directory. ----"
    echo "---- EXITING ----"
    exit 1
    # TODO: dialor and autocopy to ancor dir
  fi
}
#
#
# -----------------------
echo -e "${TEST_NAME}"
def_script_variables
source_msg
msg_welcome
ask_sudo
echo -e "${TEST_NAME}"
echo -e "---- START TEST FUNCTION ----"
check_ancor_dir
echo -e "---- END TEST FUNCTION ----"
msg_welcome
#
#
