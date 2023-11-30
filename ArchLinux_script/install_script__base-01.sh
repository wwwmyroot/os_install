#!/bin/bash
#
# <2023-11-26> _ Base file to create script for my cusom OS installation
# this version is for monolith script to decompose further
#
# ---- sources
# arch-linux wiki: https://wiki.archlinux.org/title/Installation_guide
# alis script: https://github.com/picodotdev/alis
#
#
# TODO [0/4]
# - [ ] 1) dev LOG functional;
# - [ ] 2) dev additional info about packages for every stage;
# - [ ] 3) define what packages to install with official installer;
# - [ ] 4) NOTE: get & save .json from official installer;
# - [ ] 5) discover how to echo string to a proper section of a file (maybe "sed");
# - [ ]
#
#
# ---- BRIF ABOUT : ----
# 0) OS: Arch Linux
# 1) user name: al
# 2) x-tile manager: bspwm
# 3) keyboard manager: shxkd
# 4) terminal env: bash
# 5) terminal emulator: kitty
# 6) text editor: vim; nvim; emacs (doom emacs);
# 7) default browser: firefox
# 8) env manager: miniconda3
# 9) cli file manager: mc
# 10) Storage for user configs:
# - notabug.org ....
# - /mnt/hdd ....
# - ? usb (ventoy) ....
#
#
# ---- ABOUT PACKAGES ----
# ---- 0). additional packages during install (insert manually):
#
#
# ---- 1). list of hardware packages ----
# ## ---- INTEL drivers for PC (microcode);
#
#
# ## ---- VIDEO drivers for PC (NVIDIA 250);
#
#
# ## ---- AUDIO drivers for PC (pipeware);
#
#
# ## ---- WACOM drivers for PC (Wacom Intuos Pro)
#
#
# ---- 2). list of base packages (system-wide "evergreens")
# ## -- system
# base base-devel linux linux-firmware linux-headers
#
# ### -- ?? ntfs support ?
# |? ntfs-3g
#
# ## -- cmd line tools
# make cmake
# git wget curl
# zip unzip unrar p7zip
# tree htop neofetch
# |? bash-completion less
# |? scrot feh nnn
#
#
# -- cmd line media
# ffmpeg yt-dlp zathura
#
#
# ## --- ssh, vpn
# openssh openvpn
#
#
# ## -- Xorg
# xorg xorg-server xorg-xrandr
# xclip
#
#
# ## -- main terminal emulator
# kitty
#
# ## -- sys use
# dmenu
# |? xwallpaper
#
#
# ## -- for Emacs
# fd ripgrep
#
# ---- 3). System-wide software
# neovim                                # --- neovim
# elinks firefox                        # --- browser
# font-manager                          # --- OS tool
# gimp obs-studio mpv                   # --- media
# emacs-nativecomp                      # --- emacs
#
# ???? -- optional or postponed --
# tmux                                  # --- terminal multiplexer *2)
#
# ---- 1.2.) Setup base soft
# AIM: manage settings via dotfiles
# .. .. .. .. .. .. .. .. .. ..
# .. .. .. .. .. .. .. .. .. ..
# .. .. .. .. .. .. .. .. .. ..
#
#
#---- 2.1.) list of second packages ----
#
#
#
#
# ---- 2.2.) Setup second soft ----
# AIM: mamnsge settings via dotfiles
# .. .. .. .. .. .. .. .. .. ..
# .. .. .. .. .. .. .. .. .. ..
# .. .. .. .. .. .. .. .. .. ..
#
# ---- III) list of second packages ----
# -- for 'nnn', terminal file manager
# zathura libspectre zatura-cb          # --- for 'nnn' plugin 'nuke' to view documents
# zathura-djvu zathura-pdf-mupdf        # --- for 'nnn' plugin 'nuke' to view documents
# zathura-ps                            # --- for 'nnn' plugin 'nuke' to view documents
# atool                                 # --- for 'nnn' plugin 'nuke', a script to manage archives
# fish fisher                           # --- interactive shell *1) :have_settings:
# *1) NOTE: install for fish, run in terminal (ssh-agent utility; POSIX-compatible for bash):
# $ fisher install danhper/fish-ssh-agent
# $ fisher install jorgebucaran/fish-bax
# NOTE: changes in alacritty to start fish at launch -> !/.config/alacritty/alacritty.yml
# *2) NOTE: install tmux plugin manager
# plugin manager: https://github.com/tmux-plugins/tpm
#
# - to read: https://github.com/rothgar/awesome-tmux
#
#
#
#
# --- my: script to use file:
# https://habr.com/ru/companies/ruvds/articles/325928/
# important NOTE: sourse file contains only one value in line - no backspaces(!)
##!/bin/bash
# file="~/Stor/dotfiles/script/soft_list_01.xtx"      # file to read
# IFS=$'\n'                                           # divider for values - new line
# for var in $(cat $file)                             # read file, start cycle for variable 'var'
# do                                                  # do
# echo " $var"                                        # operation
# done                                                # end
#
# --- my: NOTE: to install nerd fonts use:
# $ sudo pacman -Qg nerd-fonts | wc -l && sudo pacman -S $(pacman -Sgq nerd-fonts)
#
# --- Storage for configs created by user: notabug.org ....
#
# #############################################################################################################
#
# ---- SCRIPT SELF PREPARATION ----
# ## x - display command before executing
# ## e - script stops on error
# ## u - error if undefined variable
# ## o pipefail - script fails if command piped fails
#
set -euo pipefail
# -- for debugging
# set -xeuo pipefail
#
# ---- COMMON STATIC VARIABLES ----
#
RUN_SCRIPT_DIRECTORY="$(pwd)"
USER_CONFIG_DIRECTORY="$HOME/.config"
USER_FONTS_DIRECTORY="/usr/share/fonts"
USER_SCRIPTS_DIRECTORY="/usr/local/bin"
# -- maybe:
RUN_SCRIPT_CONF_FILE="install__script.conf"
RUN_SCRIPT_LOG_FILE="install__script.log"
RECOVERY_CONF_FILE="install__recovery.conf"
RECOVERY_LOG_FILE="install__recovery.log"
PACKAGES_CONF_FILE="install__packages.conf"
PACKAGES_LOG_FILE="install__packages.log"
COMMONS_CONF_FILE="install__commons.conf"
PROVISION_DIRECTORY="$RUN_SCRIPT_DIRECTORY/files/"
# -- color
RED="\033[0;91m"
GREEN="\033[0;92m"
BLUE="\033[0;96m"
WHITE="\033[0;97m"
NC="\033[0m"

# --------------------------------
#
# ---- STAGE-00 ----
# -- include messages file
# source ./messages.sh         # direct command
#
function source_msg() {
    local MSG_FILE="$RUN_SCRIPT_DIRECTORY/messages.sh"
    if [ -f $MSG_FILE ]; then
        source "$MSG_FILE"
    else
        # echo -e "${RED}-- (!) ERROR:${NC} MISSING $(MSG_FILE) TO SOURCE."
        echo -e "${RED}-- (!) ERROR:${NC} * ${BLUE}MISSING${NC} ${GREEN}${MSG_FILE1}${NC} ${BLUE}TO SOURCE.${NC} *"
        echo -e "${RED}-- CHECK SCRIPT STARTUP DIRECTORY: --${NC}"
        pwd | ls -la
        echo -e "---- ---- STOP ---- ----"
        exit 1
    fi
}
#
# -- echo welcome message ----
function msg_welcome() {
  echo -e "$msg_line"
  echo -e "$msg_001_plan"
  echo -e "$msg_line"
  sleep 3
}
#
# -- ask for sudo | [test: OK]
function ask_sudo() {
  echo "$msg_st00_3"
  sudo pwd >> /dev/null
}
#
# -- configure time
function configure_time() {
  echo "$msg_st00_4"
  timedatectl status
  timedatectl set-timezone UTC
  timedatectl set-timezone "Europe/Moscow"
  timedatectl set-ntp true
  echo "$msg_st00_5"
  timedatectl status
  echo "$msg_st00_6"
}
#
# -- RU locale, keyboard
#
function ru_locale() {
  sudo echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
  # :OR:
  # sudo sed -i -e "s|#ru_RU.UTF-8|ru_RU.UTF-8|" << /etc/locale.gen
  sudo locale-gen
  cd $HOME
  touch .xinitrc
  echo "setxkbmap -lauout us,ru -option grp:caps_toggle" >> .xinitrc
  echo "$msg_st00_7"
}
#
# -- setup pacman
function setup_pacman() {
  # TODO: choose --v1: to edit /etc/pacman.conf; --v2: copy dotfile as root;
  # --v1: uncomment and/or set values:
  # TODO: fix editing by .sh directly in proper section [options] of pacman.conf
  #       >> :OR: add to the end of file via ">>";
    # CheckSpace                # -> ? uncomment if default is commented;
    # VerbosePkgLists           # -> uncomment;
    # ParallelDownloads = 50    # uncomment and set to "50";
    # sudo sed -i "s/#Color/Color/" /etc/pacman.conf
    # sudo sed -i "s/#CheckSpace/CheckSpace/" /etc/pacman.conf
    # sudo sed -i "s/#ParallelDownloads = 5/ParallelDownloads = 50/" /etc/pacman.conf
    #
    #
    # -- v2:
    # sudo cp -f "$script_folder/pacman.conf" /etc/
    # :OR: ( ? overwrite without prompt? )
    #? sudo \cp "$script_folder/pacman.conf" /etc/
}
#
# -- stage_00 exec-function
function stage_00() {
  def_script_variables
  source_msg
  msg_welcome
  ask_sudo
  configure_time
  ru_locale
}
#
# TODO: develop & add in stage_00:
#  1) infrastructure for script LOGGING;
#     # see "alis"
#  2) save additional info about packages at all stages;
#     # save package list: pacman -Q > $HOME/pkg_list__start_point.txt
#     # count packages:  pacman -Q | wc -l >> $HOME/pkg_list__start_point.txt
#
# TODO: ?? include network time protocol setup if is not done yet ??
#  ##? sudo timedatectl set-ntp true
#
# ---- STAGE-01 ----
#
function stage_01() {
  echo -e "$msg_st01_0"
  sudo pacman-key --init              # init keys;
  echo -e "$msg_st01_1"
  sudo pacman-key --populate          # verify master keys;
  echo -e "$msg_st01_2"
  sudo pacman-key --refresh-keys      # actualize keys;
  echo -e "$msg_st01_3"
  sudo pacman -Sy archlinux-keyring   # upgrade keys;
  echo -e "$msg_st01_4"
  sudo pacman -Su                     # partial system update;
  echo -e "$msg_st01_5"
  sudo pacman -Syu --noconfirm        # full system update;
  echo -e "$msg_st01_6"
  echo -e "$msg_st01_f"
}
#
#
#
#
# -- NOTE: ? to add additional info to LOG folder
# # versions
# flatpak list --app
#
# -- NOTE: read from txt and install
# sudo su -
# sudo pacman -Qe | awk '{print $1}' > package_list.txt
# # for x in $(cat package_list.txt); do sudo pacman -S $x; done
# -- to list packages without versions
# sudo pacman -Qqe
#
#
#
#
##############################################
##############################################
#
# ---- #### ---- MAIN WORKFLOW ---- #### ----

function print_step() {
    STEP="$1"
    echo ""
    echo -e "${BLUE}# ${STEP} step${NC}"
    echo ""
}

function execute_step() {
    local STEP="$1"
    eval "$STEP"
}



function main() {
  stage_00
  stage_01
}
#
main


#
##############################################
##############################################
#
# -----------------------------------------------------------------------------
# --- INSTALL DIALOG
# A tool to display dialog boxes from shell scripts
# https://invisible-island.net/dialog/
# -----------------------------------------------------------------------------
# sudo pacman --noconfirm --needed -Sy dialog

# -----------------------------------------------------------------------------
# --- SYSTEM UPDATE
# -----------------------------------------------------------------------------
# system_update(){
#     echo -e "${green}${bold}[*] DOING A SYSTEM UPDATE...${normal}${no_color}"
#     echo
#     sleep 1
#
#     sudo pacman -Sy --noconfirm archlinux-keyring
#     sudo pacman --noconfirm -Syu
#     sudo pacman -S --noconfirm --needed base-devel wget git curl
#
#     echo
#     echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
#     echo
# }
#
# -----------------------------------------------------------------------------
# --- INSTALL AUR HELPER
# -----------------------------------------------------------------------------
# install_aur_helper(){
#    if ! command -v "$aurhelper" &> /dev/null
#    then
#    echo -e "${green}${bold}[*] IT SEEMS THAT YOU DON'T HAVE $aurhelper INSTALLED, I'LL INSTALL THAT FOR YOU BEFORE CONTINUING.${normal}${no_color}"
#    echo
#    sleep 1
#
#    git clone https://aur.archlinux.org/"$aurhelper".git $HOME/.srcs/"$aurhelper"
#    (cd $HOME/.srcs/"$aurhelper"/ && makepkg -si)
#
#    else
#
#    echo -e "${green}[*] IT SEEMS THAT YOU ALREADY HAVE $aurhelper INSTALLED, SKIPPING.${no_color}"
#
#    echo
#    sleep 1
#
#    fi
#
#    echo
#    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
#    echo
# }

# -----------------------------------------------------------------------------
# --- INSTALL PACKAGES WHITH PACMAN
# -----------------------------------------------------------------------------
install_pkgs(){
    echo -e "${green}${bold}[*] INSTALLING PACKAGES WITH PACMAN...${normal}${no_color}"
    echo
    sleep 1

    PKGS=(
    # INSTALLING XORG ---------------------------------------------------------

#   'xorg'
#   'xorg-server'
#   'xorg-apps'
#   'xorg-xinit'
#   'xf86-video-intel'
#   'mesa'
#   'acpi'            # ACPI (Advanced Configuration and Power Interface)
#   'pacman-contrib'  # Contributed scripts and tools for pacman systems

    # TERMINAL EMULATOR -------------------------------------------------------

    'alacritty'
 #   'kitty'

    # TERMINAL UTILITES -------------------------------------------------------

    'htop'
    'neovim'
    'neofetch'
    'xclip'
    'feh'
    'scrot'
    'openssh'
    'ripgrep'
    'fd'
    'yt-dlp'
#    'dunst'
#    'flameshot'
#    'fish'
#    'file-roller'
#    'sbxkb'
#    'gufw'
#    'hardinfo'
#    'inxi'
#    'jq'
#    'jshon'
#    'ntp'
#    'numlockx'
#    'rsync'
#    'tlp'
#    'pass'
#    'fzf'
#    'picom'
#    'tmux'
#    'man-db'
#    'cmatrix'
#    'ncdu'
#    'calcurse'
#    'unclutter'
#    'bat'
#    'exa'
#    'dosfstools'
#    'brightnessctl'
#    'lazygit'

    # MEDIA -------------------------------------------------------------------

    'alsa-utils'
    'ffmpeg'
    'pavucontrol'
    'mpv'
#    'mpd'
#    'ncmpcpp'
#    'cmus'

    # PRODUCTIVITY ------------------------------------------------------------

#    'galculator'
#    'zathura'
#    'zathura-pdf-mupdf'
#    'obsidian'

    # FILEMANAGER -------------------------------------------------------------

    'nnn'
#    'nemo'
#    'ranger'
#    'mc'
#    'thunar'
#    'thunar-archive-plugin'
#    'thunar-volman'

    # WEB TOOLS ---------------------------------------------------------------

    'firefox'
    # 'links'

    # ARCHIVE -----------------------------------------------------------------

    'unrar'
    'unzip'
    'zip'
    'p7zip'

    # DISK UTILITIES ----------------------------------------------------------

#    'autofs'
#    'exfat-utils'
#    'gparted'
#    'gnome-disks'
#    'ntfs-3g'
#    'parted'
#    'gvfs'
#    'gvfs-mtp'
#    'gvfs-afc'
#    'gvfs-gphoto2'
#    'gvfs-nfs'
#    'gvfs-smb'
#    'xdg-utils'
#    'xdg-user-dirs-gtk'

    # GENERAL UTILITIES -------------------------------------------------------

 #   'veracrypt' # Disc encryption utility
 #   'keepassxc' # Pass manager
 #   'catfish'   # Filesystem search

    # GENERAL UTILITIES -------------------------------------------------------

#    'arc-gtk-theme'
    # 'lxappearance'

    # SYSTEM UTILITIES -------------------------------------------------------

#    'psutils'

    # FONTS -------------------------------------------------------

    'adobe-source-code-pro-fonts'
    'nerd-fonts'
    'noto-fonts'
    'noto-fonts-emoji'
    'noto-fonts-cjk'
    'ttf-jetbrains-mono'
    'ttf-joypixels'
    'ttf-font-awesome'
    'ttf-hack'
    'terminus-font'
    )

    for PKG in "${PKGS[@]}"; do
        sudo pacman -S "$PKG" --noconfirm --needed
    done

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# --- INSTALL PACKAGES WITH $aurhelper
# -----------------------------------------------------------------------------
# install_aur_pkgs(){
#    echo -e "${green}${bold}[*] INSTALLING PACKAGES WITH $aurhelper...${normal}${no_color}"
#    echo
#    sleep 1
#
#    PKGS=(
#        'cava'
#        'ueberzug'
#        'volctl'
#        'caffeine-ng'
#        'picom-git'
#        'brother-hl1210w'
#    )
#
#    for PKG in "${PKGS[@]}"; do
#        "$aurhelper" -S "$PKG" --noconfirm --needed
#    done
#
#    echo
#    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
#    echo
# }

# -----------------------------------------------------------------------------
# --- INSTALL DEVELOPMENT
# -----------------------------------------------------------------------------
install_development(){
  echo -e "${green}${bold}[*] INSTALLING DEVELOPMENT...${normal}${no_color}"
  echo
  sleep 1

  PKGS=(
    'dbeaver'
#    'nodejs'
#    'npm',
#    'yarn'
#    'pyenv'
#    'filezilla'
#    'code'
#    'tmux'
#    'neovim'
    # NOTE: add docker, postgresql
  )

  for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
  done

  echo
  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
  echo
}

# -----------------------------------------------------------------------------
# --- INSTALL GRAPHICS AND DESIGN
# -----------------------------------------------------------------------------
install_graphics(){
  echo -e "${green}${bold}[*] INSTALLING GRAPHICS AND DESIGN...${normal}${no_color}"
  echo
  sleep 1

  PKGS=(
#    'gcolor2'
#    'gcolor3'
    'gimp'
#    'inkscape'
#    'krita'
#    'imagemagick'
#    'nomacs'
#    'pngcrush'
#    'ristretto'
#    'sxiv'
  )

  for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
  done

  echo
  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
  echo
}

# -----------------------------------------------------------------------------
# --- INSTALL NETWORK
# -----------------------------------------------------------------------------
install_network(){
  echo -e "${green}${bold}[*] INSTALLING NETWORK...${normal}${no_color}"
  echo
  sleep 1

  PKGS=(
    'openvpn'
#    'wpa_supplicant'
#    'dialog'
#    'networkmanager'
#    'networkmanager-openvpn'
#    'networkmanager-vpnc'
#    'network-manager-applet'
#    'dhclient'
#    'libsecret'
#    'dnsutils'
#    'dhcpcd'
  )

  for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
  done

  # sudo systemctl enable NetworkManager.service
  # sudo systemctl start NetworkManager.service

  echo
  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
  echo
}

# -----------------------------------------------------------------------------
# --- INSTALL PRINTERS & SACANNERS
# -----------------------------------------------------------------------------
# install_printers_scanners(){
#  echo -e "${green}${bold}[*] INSTALLING PRINTERS & SACANNERS...${normal}${no_color}"
#  echo
#  sleep 1

#  PKGS=(
#    'cups'
#    'cups-pdf'
#    'ghostscript'
#    'gsfonts'
#    'system-config-printer'
#    'skanlite'
#    'simple-scan'
#    'sane'
#    'sane-airscan'
#  )

#  for PKG in "${PKGS[@]}"; do
#    sudo pacman -S "$PKG" --noconfirm --needed
#  done

  # sudo systemctl enable org.cups.cupsd.service
  # sudo systemctl start org.cups.cupsd.service
  # sudo systemctl enable --now cups

#  echo
#  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
#  echo
# }

# -----------------------------------------------------------------------------
# --- INSTALL BLUETOOTH
# -----------------------------------------------------------------------------
# install_bluetooth(){
#  echo -e "${green}${bold}[*] INSTALLING BLUETOOTH...${normal}${no_color}"
#  echo
#  sleep 1

#  PKGS=(
#    'bluez'
#    'bluez-utils'
#    'bluez-firmware'
#    'blueberry'
#    'pulseaudio-bluetooth'
#    'blueman'
#  )

 # for PKG in "${PKGS[@]}"; do
 #   sudo pacman -S "$PKG" --noconfirm --needed
 # done

  # sudo systemctl enable bluetooth
  # sudo systemctl start bluetooth

#  echo
#  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
#  echo
# }

# -----------------------------------------------------------------------------
# --- INSTALL VIRTUAL MACHINE NOTE: to check
# -----------------------------------------------------------------------------
install_vm(){
  echo -e "${green}${bold}[*] INSTALLING QEMU A GENERIC AND OPEN SOURCE MACHINE EMULATOR AND VIRTUALIZER...${normal}${no_color}"
  echo
  sleep 1

  PKGS=(
    'virt-manager'
    'qemu'
    'bridge-utils'
    'ebtables'
  )

  for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
  done

  # sudo systemctl enable libvirtd
  # sudo systemctl enable ebtables
  # sudo systemctl enable dnsmasq
  # sudo gpasswd -a user libvirt
  # sudo gpasswd -a user kvm

  echo
  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
  echo
}

# -----------------------------------------------------------------------------
# --- CREATE DEFAULT DIRECTORIES
# -----------------------------------------------------------------------------
create_default_directories(){
    echo -e "${green}${bold}[*] COPYING CONFIGS TO $config_directory...${normal}${no_color}"
    echo
    sleep 1

    mkdir -p "$HOME"/.config && echo -e "${magenta}- [+] DONE -> .config/"
    sudo mkdir -p  /usr/local/bin && echo -e "${magenta}- [+] DONE -> /usr/local/bin"
    sudo mkdir -p  /usr/share/themes && echo -e "${magenta}- [+] DONE -> /usr/share/themes"
    mkdir -p "$HOME"/Pictures/wallpapers && echo -e "${magenta}- [+] DONE -> /Pictures/wallpapers"

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# --- CREATE BACKUP
# -----------------------------------------------------------------------------
create_backup(){
    echo -e "${green}${bold}[*] INSTALLING CREATING BACKUP OF EXISTING CONFIGS...${normal}${no_color}"
    echo
    sleep 1

    [ -d "$config_directory"/alacritty ] && mv "$config_directory"/alacritty "$config_directory"/alacritty_$date && echo "alacritty configs detected, backing up."
    [ -d "$config_directory"/kitty ] && mv "$config_directory"/kitty "$config_directory"/kitty_$date && echo "alacritty configs detected, backing up."
    [ -d "$config_directory"/dunst ] && mv "$config_directory"/dunst "$config_directory"/dunst_$date && echo "dunst configs detected, backing up."
    [ -d "$config_directory"/mpd ] && mv "$config_directory"/mpd "$config_directory"/mpd_$date && echo "mpd configs detected, backing up."
    [ -d "$config_directory"/ncmpcpp ] && mv "$config_directory"/ncmpcpp "$config_directory"/ncmpcpp_$date && echo "ncmpcpp configs detected, backing up."
    [ -d "$config_directory"/ranger ] && mv "$config_directory"/ranger "$config_directory"/ranger_$date && echo "ranger configs detected, backing up."
    [ -d "$config_directory"/zathura ] && mv "$config_directory"/zathura "$config_directory"/zathura_$date && echo "zathura configs detected, backing up."
    [ -d "$config_directory"/picom ] && mv "$config_directory"/picom "$config_directory"/picom_$date && echo "picom configs detected, backing up."

    [ -f "$config_directory"/Code\ -\ OSS/User/settings.json ] && mv "$config_directory"/Code\ -\ OSS/User/settings.json "$config_directory"/Code\ -\ OSS/User/settings.json_$date && echo "Vsc configs detected, backing up."

    # [ -d "$config_directory"/neofetch ] && mv "$config_directory"/neofetch "$config_directory"/neofetch_$date && echo "neofetch configs detected, backing up."
    # [ -d "$config_directory"/nvim ] && mv "$config_directory"/nvim "$config_directory"/nvim_$date && echo "nvim configs detected, backing up."
    # [ -d "$config_directory"/polybar ] && mv "$config_directory"/polybar "$config_directory"/polybar_$date && echo "polybar configs detected, backing up."

    # [ -d "$scripts_directory" ] && sudo mv "$scripts_directory" "$scripts_directory"_$date && echo "scripts ($scripts_directory) detected, backing up."

    # [ -f /etc/fonts/local.conf ] && sudo mv /etc/fonts/local.conf /etc/fonts/local.conf_$date && echo "Fonts configs detected, backing up."

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# ---  COPY CONFIGS
# -----------------------------------------------------------------------------
copy_configs(){
    echo -e "${green}${bold}[*] COPYING CONFIG TO... $config_directory ${normal}${no_color}"
    echo
    sleep 1

    cp -r $HOME/.dotfiles/config/* "$config_directory"

    # Symlinks Config
    ln -s $HOME/.dotfiles/other_config/alias ~/.alias
    ln -s $HOME/.dotfiles/other_config/tmux.conf ~/.tmux.conf
    ln -s $HOME/.dotfiles/other_config/xinitrc ~/.xinitrc
    ln -s $HOME/.dotfiles/other_config/Xresources ~/.Xresources

    cp -r $HOME/.dotfiles/other_config/gtkrc-2.0 ~/.gtkrc-2.0
    cp -r $HOME/.dotfiles/config/gtk-2.0 ~/.config
    cp -r $HOME/.dotfiles/config/gtk-3.0 ~/.config

    rm $HOME/.config/alacritty/alacritty.yml
    ln -s $HOME/.dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
    rm $HOME/.config/cava/config
    ln -s $HOME/.dotfiles/config/cava/config $HOME/.config/cava/config
    rm $HOME/.config/dunst/dunstrc
    ln -s $HOME/.dotfiles/config/dunst/dunstrc $HOME/.config/dunst/dunstrc
    rm $HOME/.config/kitty/kitty.conf
    ln -s $HOME/.dotfiles/config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
    rm $HOME/.config/mpd/mpd.conf
    ln -s $HOME/.dotfiles/config/mpd/mpd.conf $HOME/.config/mpd/mpd.conf
    rm $HOME/.config/mpv/mpv.conf
    ln -s $HOME/.dotfiles/config/mpv/mpv.conf $HOME/.config/mpv/mpv.conf
    rm $HOME/.config/ncmpcpp/config
    ln -s $HOME/.dotfiles/config/ncmpcpp/config $HOME/.config/ncmpcpp/config
    rm $HOME/.config/ranger/rc.conf
    ln -s $HOME/.dotfiles/config/ranger/rc.conf $HOME/.config/ranger/rc.conf
    rm $HOME/.config/zathura/zathurarc
    ln -s $HOME/.dotfiles/config/zathura/zathurarc $HOME/.config/zathura/zathurarc
    rm $HOME/.config/picom/picom.conf
    ln -s $HOME/.dotfiles/config/picom/picom.conf $HOME/.config/picom/picom.conf

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# --- COPY SCRIPTS
# -----------------------------------------------------------------------------
copy_scripts(){
    echo -e "${green}[*] COPYING SCRIPTS TO... $scripts_directory.${no_color}"
    echo
    sleep 1

    # sudo cp -r ./scripts/* "$scripts_directory"
    echo "COPY MY SCRIPTS ..."

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# --- FINISHING
# -----------------------------------------------------------------------------
finishing(){
    echo -e "${green}[*] FINISHING... $scripts_directory.${no_color}"
    echo
    sleep 1

    fc-cache -fv

    echo "[ -f ~/.alias ] && source ~/.alias" >> $HOME/.bashrc
    echo "[ -f ~/.alias ] && source ~/.alias" >> $HOME/.config/fish/config.fish

#    sudo systemctl enable NetworkManager.service
#    sudo systemctl start NetworkManager.service
#    sudo systemctl enable org.cups.cupsd.service
#    sudo systemctl start org.cups.cupsd.service
#    sudo systemctl enable --now cups
#    sudo systemctl enable bluetooth
#    sudo systemctl start bluetooth
#    sudo systemctl enable libvirtd
#    sudo systemctl enable ebtables
#    sudo systemctl enable dnsmasq
#    sudo gpasswd -a user libvirt
#    sudo gpasswd -a user kvm

    cp -r $HOME/.dotfiles/wallpaper/* $HOME/Pictures/wallpapers
    cp -r $HOME/.dotfiles/ThemeIcons/kora-1-5-6 $HOME/.icons

    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# TODO: INSTALL WM TODIALOG DWM DWM_FLEXIPATCH QTILE BSPWM

# -----------------------------------------------------------------------------
# --- INSTALL DWM
# -----------------------------------------------------------------------------
install_dwm(){
    echo -e "${green}[*] INSTALL DWM...${no_color}"
    echo
    sleep 1

    [ -d "$config_directory"/suckless ] && rm -rf "$config_directory"/suckless

    cp -r $HOME/.dotfiles/WM/suckless/ "$config_directory"/suckless

    cd $HOME/.config/suckless/dwm-6.4
    sudo make uninstall
    sudo make clean install
    echo -e "${magenta}[+] DWM INSTALLED ---${normal}${no_color}"

    cd $HOME/.config/suckless/dmenu-5.2
    sudo make uninstall
    sudo make clean install
    echo -e "${magenta}[+] DMENU INSTALLED ---${normal}${no_color}"

    cd $HOME/.config/suckless/st-0.9
    sudo make uninstall
    sudo make clean install
    echo -e "${magenta}[+] ST INSTALLED ---${normal}${no_color}"

    cd $HOME/.config/suckless/slstatus
    sudo make uninstall
    sudo make clean install
    echo -e "${magenta}[+] SLSTATUS INSTALLED ---${normal}${no_color}"

    cd $HOME/.config/suckless/slock-1.5
    sudo make uninstall
    sudo make clean install
    echo -e "${magenta}[+] SLOCK INSTALLED ---${normal}${no_color}"

    cd

    echo
    echo -e "${magenta}${bold}[+] DONE ----------------------------------------${normal}${no_color}"
    echo
}

# -----------------------------------------------------------------------------
# --- INSTALL QTILE
# -----------------------------------------------------------------------------
install_qtile(){
  echo -e "${green}${bold}[*] INSTALLING QTILE WM ...${normal}${no_color}"
  echo
  sleep 1

  PKGS=(
      'qtile'
  )

  for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
  done

  echo
  echo -e "${magenta}${bold}[+] DONE ------------------------------------------${normal}${no_color}"
  echo
}

cmd=(dialog --clear --title "Aur helper" --menu "Firstly, select the aur helper you want to install (or have already installed)." 10 50 16)
options=(1 "yay" 2 "paru")
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

case $choices in
    1) aurhelper="yay";;
    2) aurhelper="paru";;
esac

cmd=(dialog --clear --separate-output --checklist "Select (with space) what script should do.\\nChecked options are required for proper installation, do not uncheck them if you do not know what you are doing." 26 86 16)
options=(
    1 "System update" on
    2 "Install aur helper" on
    3 "Install basic packages" on
    4 "Install basic packages (aur)" on
    5 "Install development" off
    6 "Install graphics and design" off
    7 "Install network" on
    8 "Install printers & sacanners" off
    9 "Install bluetooth" off
    10 "Install virtual machine" off
    11 "Create default directories" on
    12 "Create backup of existing configs (to prevent overwritting)" off
    13 "Copy configs" off
    14 "Copy scripts" off
    15 "Alias, Enable Services" on
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear

for choice in $choices
do
    case $choice in
        1) system_update;;
        2) install_aur_helper;;
        3) install_pkgs;;
        4) install_aur_pkgs;;
        5) install_development;;
        6) install_graphics;;
        7) install_network;;
        8) install_printers_scanners;;
        9) install_bluetooth;;
        10) install_vm;;
        11) create_default_directories;;
        12) create_backup;;
        13) copy_configs;;
        14) copy_scripts;;
        15) finishing;;
    esac
done

cmd=(dialog --clear --separate-output --checklist "Select (with space) what script should do.\\nChecked options are required for proper installation, do not uncheck them if you do not know what you are doing." 26 86 16)
options=(
    1 "Install DWM 6.4 (Window Manager)" on
    2 "Install Qtile (Window Manager)" off
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear

for choice in $choices
do
    case $choice in
        1) install_dwm;;
        2) install_qtile;;
    esac
done
