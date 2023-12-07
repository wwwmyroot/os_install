#!/bin/bash
#
# [ ] - TODO: - statup dialog to ensure all prereqisites are done;
# [ ] - TODO: - on "source" check if file exist; ? stop if not ?;
# [ ] - TODO: - ? what about 'root' ? need tests
# [ ] - TODO: -
# [ ] - TODO: -
# [ ] - TODO: -
# [ ] - TODO: -
#
#
# ###############################################
# -------------- PLAN: --------------------------
# | STAGE-01 | - UPDATE KEYRING AND SYSTEM;       | 01_update.sh
# | STAGE-02 | - INSTALL BASE PKG AND DRIVERS;    | 02_pkg-01.sh
# | STAGE-03 | - BASE CONFIGURATION AND SETTINGS; | 03_cfg-01.sh
# | STAGE-04 | - INSTALL & CONFIG SYSTEMWIDE PKG; | 04_sys-01.sh
# | STAGE-05 | - INSTALL ENVIRONMENTS MANAGERS;   | 05_env-01.sh
# | STAGE-06 | - INSTALL ENVIRONMENTS;            | 06_env-02.sh
# -----------------------------------------------
# ###############################################
#
#
#
#
# ---- script's own settings
set -euo pipefail
# for testing add -x to parameters to see current command in output before execution:
# set -xeuo pipefail
#
# ---- include messages (massages.sh)
# echo "$msg_line"     # no
source messages.sh
echo "$msg_line"
echo "$msg_001_plan"
echo "$msg_line"
#
current_dir=$(pwd)
#
for f in "${current_dir[@]}; do
    source "$f/*.sh"
    source "$f/*.conf"
done






# ---- run STAGE-00 ----
echo "$msg_line"
echo "$msg_st00_0"
source ./<insert-proper-name>.sh  # correct name
echo "$msg_st00_f"
echo "$msg_line"
sleep 1
#
# ---- run STAGE-01 ----
echo "$msg_line"
source ./<insert-proper-name>.sh  # correct name
echo "$msg_line"
sleep 1
#
# ---- run STAGE-02 ----
echo "$msg_line"
source ./<insert-proper-name>.sh  # correct name
echo "$msg_line"
sleep 1
#
