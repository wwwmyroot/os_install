#!/bin/bash
#
# https://github.com/picodotdev/alis/blob/master/alis-packages.sh
#
# --------------------------------
RUN_SCRIPT_DIRECTORY="$(pwd)"
## ---- ASK FOR SUDO | [TEST: OK] ----
function ask_sudo() {
  echo "$msg_st00_3"
  sudo pwd >> /dev/null
}
# ---- include messages file ----
#
#
function missing_firmware() {
  cd $HOME/tmp_firmware
  # for archive in *; do tar -xvf "${archive}"; done
  # find */ -maxdepth 0 -type d -exec makepkg -s -i {} \;
  # for pkg in (find */ -maxdepth 0 -type d); do makepkg -s -i; done
  # find */ -maxdepth 0 -type d -exec echo "-t- $(pwd) -t-" {} \;
  # find */ -maxdepth 0 -type d -exec makepkg -s -i {} \;
  # find */ -maxdepth 1 -type d -exec makepkg {} \;
  for f in *; do
    # if [ -d "$f" && ! -L "$f" ]; then
    if [ -d "$f" ]; then
      cd "$f"
    echo ""
    echo "-t- current folder:"
    pwd
    echo ""
    echo "-t- run makepkg:"
    makepkg -s -i
    echo ""
    cd ..
    fi
   done
}
#
#
echo "#### START ####"
echo "-t- run asking sudo -t-"
sleep 2
ask_sudo
echo "-t- OK asking sudo -t-"
sleep 2
echo "-t- run missing_firmware -t-"
missing_firmware
echo "-t- OK missing_firmware -t-"
sleep 2
echo "#### FINISH ####"
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
