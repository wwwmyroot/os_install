#!/bin/bash
#
# https://github.com/picodotdev/alis/blob/master/alis-packages.sh
#
# -- color
# RED="\033[0;91m"
# GREEN="\033[0;92m"
# BLUE="\033[0;96m"
# WHITE="\033[0;97m"
# NC="\033[0m"

# --------------------------------
RUN_SCRIPT_DIRECTORY="$(pwd)"
# ---- STAGE-00 ----
# -- include messages file
# source ./messages.sh         # direct command
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

source_msg
echo -e "$msg_line"
echo -e "$msg_001_plan"
echo -e "$msg_st02_1"
echo -e "$msg_line"
