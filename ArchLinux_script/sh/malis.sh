#!/usr/bin/env bash
#
# My Arch Linux Install Script (malis)
# Startup file for my cusom OS installation on my PC.
#
# See all TODO in .../org/malis.org
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
# ---- LATER: do you need it ?
# ---- Check CURRENT RUN DIRECTORY WITH ANCOR DIRECTORY ($HOME/malis) | [TEST: TODO] ----
# shellcheck disable=SC2154
function check_ancor_dir() {
  print_step "check_ancor_dir()"
  if [ "${RUN_SCRIPT_DIRECTORY}" == "${ANCOR_SCRIPT_DIRECTORY}" ]; then
  return
  else
    echo "---- ERROR: Script is started NOT from ANCOR DIRECTIRY. ----"
    echo "---- Ancor directory have to be: * \"$HOME/malis\" * ----"
    echo "---- Current directory is: * ${RUN_SCRIPT_DIRECTORY} * ----"
    read -r -p "---- Do you want to create ANCOR DIRECTORY and continue? [y/n] " yn
    case "$yn" in
      # MAYBE: syntax: "Y" | "e" )  .... ;; "N" | "n" ) .... ;;
      [Yy]* ) mkdir "$HOME/malis"; cp -R "$(pwd)/" "${ANCOR_SCRIPT_DIRECTORY}";;
      [Nn]* ) echo "---- EXITING ----"; sleep 3; exit 0;;
      * ) echo "---- Answer [Yy] or [Nn]"; execute_step "check_ancor_dir";;
    esac
    echo -e "${On_BRed}-- (!) ERROR: in ${On_BBlue} check_ancor_dir() ${On_BRed} ----${Color_Off}"
    exit 1
  fi
# ---- NOTE: from [2023-12-02] NOT IN USE.
#      Expedience depends from 'cd' behavior. Develop other stuff and make
#      a desigion about usage. Also, decide what to do if current run is not from
#      ancor directory.
# -- TODO: Make a decision. Develop appropriete scenarios. Include in malis-messages.sh.
}
#
# ---- [TEST: OKAY]
    # shellcheck disable=SC1090
function init_config() {
    local COMMONS_FILE; COMMONS_FILE="./malis-commons.sh"
    local COMMONS_CONF_FILE; COMMONS_CONF_FILE="./malis-commons.conf"
    local MALIS_CONF_FILE; MALIS_CONF_FILE="./malis.conf"
    local MALIS_MESSAGES_FILE; MALIS_MESSAGES_FILE="./malis-messages.sh"
    local TERMINAL_COLORS_CONF_FILE; TERMINAL_COLORS_CONF_FILE="./terminal-colors.conf"
    source "${COMMONS_FILE}"
    source "${COMMONS_CONF_FILE}"
    source "${MALIS_CONF_FILE}"
    source "${MALIS_MESSAGES_FILE}"
    source "${TERMINAL_COLORS_CONF_FILE}"
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
#}
#
#
# ---- TODO: fill a list of variables to sanitize in malis.sh ; example is below
function sanitize_variables() {
  print_step "sanitize_variables()"
  PACKAGES_PACMAN=$(sanitize_variable "${PACKAGES_PACMAN}")
  PACKAGES_PACMAN_PIPEWIRE=$(sanitize_variable "$PACKAGES_PACMAN_PIPEWIRE")
  SYSTEMD_UNITS=$(sanitize_variable "$SYSTEMD_UNITS")
  USER_NAME=$(sanitize_variable "${USER_NAME}")
  #
}
#
function check_variables() {
  print_step "check_variables()"
  check_variables_value "USER_NAME" "${USER_NAME}"                  # non zero
  check_variables_value "PACKAGES_PACMAN" "${PACKAGES_PACMAN}"      # non zero
  check_variables_boolean "PACKAGES_PACMAN_INSTALL" "$PACKAGES_PACMAN_INSTALL"
  check_variables_boolean "PACKAGES_PACMAN_INSTALL_PIPEWIRE" "$PACKAGES_PACMAN_INSTALL_PIPEWIRE"
}
#
function execute_sudo() {
  print_step "execute_sudo()"
  local COMMAND="$1"
  sudo bash -c "${COMMAND}"
}
#
# ---- ECHO WELCOME MESSAGE | [TEST: OKAY]
  # shellcheck disable=SC2154
function msg_welcome() {
  echo -e "$msg_line"
  echo -e "$msg_001_plan"
  echo -e "$msg_line"
  sleep 3
}
#
# ---- ASK FOR SUDO | [TEST: OKAY]
function ask_sudo() {
  # shellcheck disable=SC2154
  echo "$msg_st00_3"
  sudo pwd >> /dev/null
}
#
# ---- CONFIGURE TIME | [TEST: OKAY]
function configure_time() {
  print_step "configure_time()"
  timedatectl status
  timedatectl set-timezone UTC
  timedatectl set-timezone "Europe/Moscow"
  timedatectl set-ntp true
  timedatectl status
}
#
# ---- RU locale, keyboard [TEST: OKAY]
function ru_locale() {
  print_step "ru_locale()"
  execute_sudo "sed -i -e \"s/#ru_RU.UTF-8/ru_RU.UTF-8/\" /etc/locale.gen"
  # v2: sudo echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
  execute_sudo "locale-gen"
  # cd $HOME
  touch "$HOME/.xinitrc"
  echo "setxkbmap -lauout us,ru -option grp:caps_toggle" >> "$HOME/.xinitrc"
}
#
# ---- SETUP PACMAN | [TEST: TODO]
function setup_pacman() {
  print_step "setup_pacman"
    execute_sudo "sed -i \"s/#Color/Color/\" /etc/pacman.conf"
    execute_sudo "sed -i \"s/#CheckSpace/CheckSpace/\" /etc/pacman.conf"
    execute_sudo "sed -i \"s/#ParallelDownloads = 5/ParallelDownloads = 50/\" /etc/pacman.conf"
    #
    #
    # -- v2:
    # sudo cp -f "$script_folder/pacman.conf" /etc/
    # :OR: ( ? overwrite without prompt? )
    #? sudo \cp "$script_folder/pacman.conf" /etc/
}
#
# ---- UPDATE KEYRING , PARTIAL UPDATE SYSTEM
function update_keyring() {
  print_step "update_keyring()"
  # init keys;
  execute_sudo "pacman-key --init"
  # verify master keys;
  execute_sudo "pacman-key --populate"
  # actualize keys;
  execute_sudo "pacman-key --refresh-keys"
  # upgrade keys;
  execute_sudo "pacman -Sy --noconfirm archlinux-keyring"
  # partial system update;
  execute_sudo "pacman -Su --noconfirm"
  # full system update;
  execute_sudo "pacman -Syu --noconfirm"
}
#
# ---- NOTE: Use if you need it (check after official install).
# -- INSTALL PKG FOR MISSING FIRMWARE
# shellcheck disable=SC2154
function missing_firmware() {
  print_step "missing_firmware()"
  # [2023-12-02] Solution for missing firmware ""; ""; ""; "";
  sleep 3
  execute_sudo "pacman -S --noconfirm --needed linux-firmware"
  execute_sudo "pacman -S --noconfirm --needed linux-firmware-qlogic"
  # NOTE: may be 'base' 'curl' 'make' are already installed
  execute_sudo "pacman -S --noconfirm --needed lha curl make cmake base base-devel"
  cd "$HOME"
  mkdir -p "$HOME/tmp_firmware"
  cd "$HOME/tmp_firmware"
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
# -- TODO
function install_video_drivers() {
  print_step "install_video_drivers()"
  #
}
#
# -- TODO
function install_audio_drivers() {
  print_step "install_audio_drivers()"
  #
}
#
# -- TODO
function install_wacom_drivers() {
  print_step "install_wacom_drivers()"
  #
}
#
# -- TODO
function install_pkg_pacman() {
  print_step "install_pkg_pacman()"
  #
}
#
# shellcheck disable=SC2154
function pacman_install() {
    local ERROR; ERROR="true"
    local PACKAGES; PACKAGES=()
    set +e
    IFS=' ' read -ra PACKAGES <<< "$1"
    # FIXME: -- VARIABLE
    for VARIABLE in {1..5}
    do
        local COMMAND; COMMAND="pacman -Syu --noconfirm --needed ${PACKAGES[*]}"
       if execute_sudo "$COMMAND"; then
            local ERROR="false"
            break
        else
            sleep 10
        fi
    done
    set -e
    if [ "$ERROR" == "true" ]; then
      echo -e "${On_BRed}-- (!) ERROR: in ${On_BBlue} pacman_install() ${On_BRed} ----${Color_Off}"
        exit 1
    fi
}
#
# shellcheck disable=SC2154
function pacman_uninstall() {
  print_step "pacman_uninstall()"
  local ERROR="true"
  local PACKAGES=()
  set +e
  IFS=' ' read -ra PACKAGES <<< "$1"
  local PACKAGES_UNINSTALL=()
  for PACKAGE in "${PACKAGES[@]}"
  do
      execute_sudo "pacman -Qi ${PACKAGE} > /dev/null 2>&1"
      local PACKAGE_INSTALLED=$?
      if [ $PACKAGE_INSTALLED == 0 ]; then
          local PACKAGES_UNINSTALL+=("$PACKAGE")
      fi
  done
  if [ -z "${PACKAGES_UNINSTALL[*]}" ]; then
      return
  fi
  local COMMAND="pacman -Rdd --noconfirm ${PACKAGES_UNINSTALL[*]}"
  if execute_sudo "${COMMAND}"; then
      local ERROR="false"
  fi
  set -e
  if [ "$ERROR" == "true" ]; then
      echo -e "${On_BRed}-- (!) ERROR: in ${On_BBlue} pacman_uninstall() ${On_BRed} ----${Color_Off}"
      exit 1
  fi
}
#
function checks_pacman_pkg() {
    print_step "checks()"

    check_variables_value "USER_NAME" "$USER_NAME"

    if [ -n "$PACKAGES_PACMAN" ]; then
        execute_sudo "pacman -Syi $PACKAGES_PACMAN"
    fi

    if [ "$SYSTEM_INSTALLATION" == "false" ]; then
        ask_sudo
    fi
}
#
# -- TODO explore
function packages_pacman() {
    print_step "packages_pacman()"

    if [ "$PACKAGES_PACMAN_INSTALL" == "true" ]; then
        local CUSTOM_REPOSITORIES; CUSTOM_REPOSITORIES="$(echo "$PACKAGES_PACMAN_CUSTOM_REPOSITORIES" | grep -E "^[^#]|\n^$"; exit 0)"
        if [ -n "$CUSTOM_REPOSITORIES" ]; then
            execute_sudo "echo -e \"# alis\n$CUSTOM_REPOSITORIES\" >> /etc/pacman.conf"
        fi

        if [ -n "$PACKAGES_PACMAN" ]; then
            pacman_install "$PACKAGES_PACMAN"
        fi

        if [[ ("$PACKAGES_PIPEWIRE" == "true" || "$PACKAGES_PACMAN_INSTALL_PIPEWIRE" == "true") && -n "$PACKAGES_PACMAN_PIPEWIRE" ]]; then
            if echo "$PACKAGES_PACMAN_PIPEWIRE" | grep -F -qw "pipewire-pulse"; then
                pacman_uninstall "pulseaudio pulseaudio-bluetooth"
            fi
            if echo "$PACKAGES_PACMAN_PIPEWIRE" | grep -F -qw "pipewire-alsa"; then
                pacman_uninstall "pulseaudio pulseaudio-alsa"
            fi
            if echo "$PACKAGES_PACMAN_PIPEWIRE" | grep -F -qw "wireplumber"; then
                pacman_uninstall "pipewire-media-session"
            fi
            if echo "$PACKAGES_PACMAN_PIPEWIRE" | grep -F -qw "pipewire-jack"; then
                pacman_uninstall "jack2"
            fi
            pacman_install "$PACKAGES_PACMAN_PIPEWIRE"
            #if [ -n "$(echo "$PACKAGES_PACMAN_PIPEWIRE" | grep -F -w "pipewire-pulse")" ]; then
            #    execute_user "$USER_NAME" "systemctl enable --user pipewire-pulse.service"
            #fi
        fi
    fi
}
# ---- TODO: explore
# -- NOTE: experimental
function install_doom_emacs() {
  rm -r ~/.emacs.d
  mkdir -p ~/.emacs.d
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
  ~/.emacs.d/bin/doom install
  ~/.emacs.d/bin/doom sync
  ~/.emacs.d/bin/doom doctor
  # go to settings (Space - f - P) ang make your config; run sync;
  cp -R "$HOME/malis/.config/doom/*" "$HOME/.config/doom/"
}
# -- NOTE: experimental
function git_global_config(){
  git config --global user.name  "AL"
  git config --global user.email "wwwmyroot@gmail.com"
}
# -- TEST: OK
function user_wheel() {
  print_step "user_wheel()"
  # as root edit /etc/sudoers
  # uncomment line: %wheel ALL=(ALL:ALL) ALL
  # add line in 'User privilege specifications' under root: al ALL=(ALL:ALL) ALL
  execute_sudo "sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers"
  execute_sudo "sed -i \"s/# root ALL=(ALL:ALL) ALL/# root ALL=(ALL:ALL) ALL\nal ALL=(ALL:ALL) ALL/\" /etc/sudoers"
}
# -- TODO
function pacman_reflector() {
  print_step "pacman_reflector()"
  # use pacman_install() to install reflector
}
# -------------------------
#
#
#
# -- TODO
function copy_dotfiles() {
  print_step "install_pkg_pacman()"
  #
}
#
# -- TODO
function user_settings() {
  print_step "user_settings()"
  #
  execute_step "git_global_config"
  execute_step "user_wheel"
}
#
# -- NOTE: CONSTANT EDITING --
function main() {
  print_step "main()"
#
  local START_TIMESTAMP; START_TIMESTAMP=$(date -u +"%F %T")
  execute_step "check_ancor_dir"
  execute_step "init_config"
  execute_step "sanitize_variables"
  execute_step "check_variables"

  execute_step "msg_welcome"
  execute_step "ask_sudo"
  execute_step "configure_time"
  #t  execute_step "ru_locale"
  #t  execute_step "setup_pacman"
  #t  execute_step "update_keyring"
  #t  execute_step "missing_firmware"
  #t  execute_step "user_wheel"
  #t  execute_step "install_video_drivers"
  #t  execute_step "install_audio_drivers"
  #t  execute_step "install_wacom_drivers"
  #t  execute_step "checks_pacman_pkg"
  #t  execute_step "packages_pacman"
  #t  execute_step "install_doom_emacs"
  #t  execute_step "user_settings"
  #t  execute_step "copy_dotfiles"

# -- stage 01 -- install packages (pacman)


# -- stage 01 -- copy dotfiles



# -- FINISH --
    local END_TIMESTAMP; END_TIMESTAMP=$(date -u +"%F %T")
    local INSTALLATION_TIME; INSTALLATION_TIME=$(date -u -d @$(($(date -d "$END_TIMESTAMP" '+%s') - $(date -d "$START_TIMESTAMP" '+%s'))) '+%T')
    echo -e "Installation start ${WHITE}$START_TIMESTAMP${NC}, end ${WHITE}$END_TIMESTAMP${NC}, time ${WHITE}$INSTALLATION_TIME${NC}"
    # execute_step "end"
}
#
main "$@"
#
##############################################
##############################################

# WTF: [2023-12-03]. Two arrows in Emacs (electric-mode) insert symbols "EOF (end of file)"
#       and crash reading of a whole script. Switching 'sh-electric-here-document-mode'
#       gives nothing. Strange bullshit. Possible solution - set "<<<", but
#       i rewrite command to be a single call of 'sed'.
# sudo sed -i -e "s/#ru_RU.UTF-8/ru_RU.UTF-8/" << /etc/locale.gen
