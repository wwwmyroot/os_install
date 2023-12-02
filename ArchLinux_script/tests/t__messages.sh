#!/bin/bash
#
# https://github.com/picodotdev/alis/blob/master/alis-packages.sh
#
# -- color
RED1="\033[0;91m"
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



# Reset
Color_Off="\033[0m"       # Text Reset

# Regular Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White

# Bold
BBlack="\033[1;30m"       # Black
BRed="\033[1;31m"         # Red
BGreen="\033[1;32m"       # Green
BYellow="\033[1;33m"      # Yellow
BBlue="\033[1;34m"        # Blue
BPurple="\033[1;35m"      # Purple
BCyan="\033[1;36m"        # Cyan
BWhite="\033[1;37m"       # White

# Underline
UBlack="\033[4;30m"       # Black
URed="\033[4;31m"         # Red
UGreen="\033[4;32m"       # Green
UYellow="\033[4;33m"      # Yellow
UBlue="\033[4;34m"        # Blue
UPurple="\033[4;35m"      # Purple
UCyan="\033[4;36m"        # Cyan
UWhite="\033[4;37m"       # White

# Background
On_Black="\033[40m"       # Black
On_Red="\033[41m"         # Red
On_Green="\033[42m"       # Green
On_Yellow="\033[43m"      # Yellow
On_Blue="\033[44m"        # Blue
On_Purple="\033[45m"      # Purple
On_Cyan="\033[46m"        # Cyan
On_White="\033[47m"       # White

# High Intensty
IBlack="\033[0;90m"       # Black
IRed="\033[0;91m"         # Red
IGreen="\033[0;92m"       # Green
IYellow="\033[0;93m"      # Yellow
IBlue="\033[0;94m"        # Blue
IPurple="\033[0;95m"      # Purple
ICyan="\033[0;96m"        # Cyan
IWhite="\033[0;97m"       # White

# Bold High Intensty
BIBlack="\033[1;90m"      # Black
BIRed="\033[1;91m"        # Red
BIGreen="\033[1;92m"      # Green
BIYellow="\033[1;93m"     # Yellow
BIBlue="\033[1;94m"       # Blue
BIPurple="\033[1;95m"     # Purple
BICyan="\033[1;96m"       # Cyan
BIWhite="\033[1;97m"      # White

# High Intensty backgrounds
On_IBlack="\033[0;100m"   # Black
On_IRed="\033[0;101m"     # Red
On_IGreen="\033[0;102m"   # Green
On_IYellow="\033[0;103m"  # Yellow
On_IBlue="\033[0;104m"    # Blue
On_IPurple="\033[10;95m"  # Purple
On_ICyan="\033[0;106m"    # Cyan
On_IWhite="\033[0;107m"   # White


#######################################################
#######################################################
source_msg
echo -e "${msg_line}"
echo -e "${RED1}---- Current RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${Red}---- Test REGULAR RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${BRed}---- Test BOLD RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${URed}---- Test UNDERLINE RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${On_Red}---- Test BACKGROUND RED 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${IRed}---- Test HI INTENSITY RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${BIRed}---- Test BOLD HI INTENSITY RED color 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "${On_IRed}---- Test High Intensty backgrounds RED 1234567890 ~!@#$%^&*()[] ----${Color_Off}"
echo -e "$msg_line"

echo -e "${On_IWhite}${Purple}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${BPurple}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${IPurple}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${BIPurple}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${Red}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${IRed}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${BRed}${msg_line}${Color_Off}"
echo -e "${On_IWhite}${BIRed}${msg_line}${Color_Off}"

# echo -e "$msg_line_small"
# echo -e "$msg_st02_1"
# echo -e "$msg_line_small"
echo -e "$msg_line"

