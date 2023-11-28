#!/bin/bash
#
#
# ---- ---- RUN INCLUDED ---- ----
#
set -euo pipefail
# set -xeuo pipefail
#
script_folder="$(pwd)"
#
#
function list_pwd_3() {
    local wpath="$script_folder/*"
    for file in $wpath
    do
        if [ -d "$file" ]
        then
            echo "$file |--###-> is a directory"
        elif [ -f "$file" ]
        then
            echo "$file |--###-> is a file"
        fi
    done
}
#
#
# ---- ---- INCLUDE MESSAGES ---- ----
function source_msg() {
    local MSG_FILE="$script_folder/messages.sh"
#
    if [ -f $MSG_FILE ]; then
        source "$MSG_FILE"
    else
        echo -e "-- (!) ERROR: NO $(MSG_FILE) TARGET FILE IN $(script_folder) --";
        echo "---- first pwd:"
        list_pwd_1
        echo "---- second pwd:"
        list_pwd_2
        echo "---- third pwd:"
        list_pwd_3
        echo -e "-- STOP --"
        exit 1
    fi
}

# ---- test messages
function msg_welcome() {
  echo -e "$msg_line"
  echo -e "$msg_001_plan"
  echo -e "$msg_line"
}

# ---- run section
echo -e "source_msg:"
source_msg
echo -e "msg_welcome:"
msg_welcome
echo -e "list_pwd:"
list_pwd_1
echo -e "list_pwd_2:"
list_pwd_2
echo -e "list_pwd_3:"
list_pwd_3
echo -e "$msg_line"

#
#
