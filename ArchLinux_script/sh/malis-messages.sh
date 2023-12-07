#!/usr/bin/env bash
#
# -- color
# RED="\033[0;91m"
# GREEN="\033[0;92m"
# BLUE="\033[0;96m"
# WHITE="\033[0;97m"
# NC="\033[0m"
#
# ---- ---- MESSAGES ---- ----
# -- COMMON MSG
msg_line="#### #### #### #### #### ####"
msg_ok="---- ---- OK ---- ----"
msg_stop="---- ---- STOP ---- ----"
msg_line_small="-----------------------------"
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
msg_st00_0="---- | STAGE-00 START | PREPARATION ---- "
msg_st01_0="---- | STAGE-01 START | UPDATE KEYRING AND SYSTEM; ---- "
msg_st02_0="---- | STAGE-02 START | INSTALL BASE PKG AND DRIVERS; ---- "
msg_st03_0="---- | STAGE-03 START | BASE CONFIGURATION AND SETTINGS; ---- "
msg_st04_0="---- | STAGE-04 START | INSTALL AND CONFIG SYSTEM-WIDE PKG; ---- "
msg_st05_0="---- | STAGE-05 START | INSTALL ENVIRONMENTS MANAGERS; ---- "
msg_st06_0="---- | STAGE-06 START | INSTALL ENVIRONMENTS; ---- "
#
# -- FINISH STAGE -- OK
msg_st00_f="---- | STAGE-00 FINISH | PREPARATION ---- "
msg_st01_f="---- | STAGE-01 FINISH | UPDATE KEYRING AND SYSTEM; ---- "
msg_st02_f="---- | STAGE-02 FINISH | INSTALL BASE PKG AND DRIVERS; ---- "
msg_st03_f="---- | STAGE-03 FINISH | BASE CONFIGURATION AND SETTINGS; ---- "
msg_st04_f="---- | STAGE-04 FINISH | INSTALL AND CONFIG SYSTEM-WIDE PKG; ---- "
msg_st05_f="---- | STAGE-05 FINISH | INSTALL ENVIRONMENTS MANAGERS; ---- "
msg_st06_f="---- | STAGE-06 FINISH | INSTALL ENVIRONMENTS; ---- "

# -- Stage_00
msg_st00_1="---- DEFINING VARIABLES ----"
msg_st00_2="---- VARIABLES SET OK ----"
msg_st00_3="---- Asking for sudo. Insert sudo password:"
msg_st00_4="---- CURRENT TIME SETTINGS:"
msg_st00_5="---- CONFIGURED TIME SETTINGS:"
msg_st00_6="---- TIME SERVER SET OK ----"
msg_st00_7="---- RU locale with CAPS_toggle SET OK ----"
#
# -- Stage_01
msg_st01_1="---- PACMAN-KEY INITIALISATION DONE (1/6) OK ----"
msg_st01_2="---- VERIFYING THE MASTER KEYS DONE (2/6) OK ----"
msg_st01_3="---- KEYS ACTUALISATION DONE (3/6) OK ----"
msg_st01_4="---- KEYS UPGRADE DONE (4/6) OK ----"
msg_st01_5="---- SYSTEM PARTIAL UPDATE DONE (5/6) OK ----"
msg_st01_6="---- SYSTEM UPDATE DONE (6/6) OK ----"
msg_st01_7="----  ----"
msg_st01_8="----  ----"
#
#
# -- Stage_02
msg_st02_1="---- MISSING FIRMWARE TO INSTALL [2023-12-02]:
|---+----------------+-----+-------------------------|
|   | Module         |     | Package                 |
|---+----------------+-----+-------------------------|
| 1 | aic94xx        | AUR | aic94xx-firmware        |
| 2 | wd719x         | AUR | wd719x-firmware         |
| 3 | xhci_pci       | AUR | upd72020x-fw            |
| 4 | bfa            |     | linux-firmware-qlogic   |
| 4 | qed            |     | linux-firmware-qlogic   |
| 4 | qla1280        |     | linux-firmware-qlogic   |
| 4 | qla2xxx        |     | linux-firmware-qlogic   |
|---+----------------+-----+-------------------------|

* v01: packages from AUR will be:
- downloaded by <curl> in ~/temp_firmware ;
- unpacked by <tar>;
- compiled by <make>;
- installed by <pacman -U [pkg-]>;

NOTE: package <lah> is needed to unpack, it will be installed;
"
msg_st02_2="---- Installing 'linux-firmware' from Arch repo DONE (1/6) ----"
msg_st02_3="---- Installing 'linux-firmware-qlogic' DONE (2/6) OK ----"
msg_st02_4="---- Installing 'curl make cmake base base-devel lha' DONE (3/6) OK ----"
msg_st02_5="---- Making lockal pakage from .tar and installing.
---- NOTE: Will need USER CONFIRMATION during install. ----"
msg_st02_6="---- Installing of package is DONE OK ----"
msg_st02_7="---- Installing 'aic94xx-firmware wd719x-firmware upd72020x-fw' from AUR DONE (6/6) OK ----"
#
#
# -- Stage_03


msg_st02_="----  DONE (5/10) OK ----"
msg_st02_="----  DONE (6/10) OK ----"
