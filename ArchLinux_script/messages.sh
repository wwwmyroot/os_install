#!/bin/bash
#
# ---- ---- MESSAGES ---- ----
# -- COMMON MSG
msg_line="#### #### #### #### #### ####"
msg_ok="---- ---- OK ---- ----"
msg_stop="---- ---- STOP ---- ----"
#
#
#
#
#
#
#
# -- p00 -- greeting
msg_001_plan="
-------------- PLAN: --------------------------
| STAGE-00 | - PREPARATIONS;
| STAGE-01 | - UPDATE KEYRING AND SYSTEM;
| STAGE-02 | - INSTALL BASE PKG AND DRIVERS;
| STAGE-03 | - BASE CONFIGURATION AND SETTINGS;
| STAGE-04 | - INSTALL AND CONFIG SYSTEM-WIDE PKG;
| STAGE-05 | - INSTALL ENVIRONMENTS MANAGERS;
| STAGE-06 | - INSTALL ENVIRONMENTS;
-----------------------------------------------
"
# -- START STAGE
msg_st00_0="---- |STAGE-00 START| PREPARATION ---- "
msg_st01_0="---- |STAGE-01 START| UPDATE KEYRING AND SYSTEM; ---- "
msg_st02_0="---- |STAGE-02 START| INSTALL BASE PKG AND DRIVERS; ---- "
msg_st03_0="---- |STAGE-03 START| BASE CONFIGURATION AND SETTINGS; ---- "
msg_st04_0="---- |STAGE-04 START| INSTALL AND CONFIG SYSTEM-WIDE PKG; ---- "
msg_st05_0="---- |STAGE-05 START| INSTALL ENVIRONMENTS MANAGERS; ---- "
msg_st06_0="---- |STAGE-06 START| INSTALL ENVIRONMENTS; ---- "
#
# -- FINISH STAGE -- OK
msg_st00_f="---- |STAGE-00 FINISH| PREPARATION ---- "
msg_st01_f="---- |STAGE-01 FINISH| UPDATE KEYRING AND SYSTEM; ---- "
msg_st02_f="---- |STAGE-02 FINISH| INSTALL BASE PKG AND DRIVERS; ---- "
msg_st03_f="---- |STAGE-03 FINISH| BASE CONFIGURATION AND SETTINGS; ---- "
msg_st04_f="---- |STAGE-04 FINISH| INSTALL AND CONFIG SYSTEM-WIDE PKG; ---- "
msg_st05_f="---- |STAGE-05 FINISH| INSTALL ENVIRONMENTS MANAGERS; ---- "
msg_st06_f="---- |STAGE-06 FINISH| INSTALL ENVIRONMENTS; ---- "

#
msg_st00_1="---- DEFINING VARIABLES ----"
msg_st00_2="---- VARIABLES SET OK ----"
#
#
