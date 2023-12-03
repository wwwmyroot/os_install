#!/usr/bin/env sh
#
# My Arch Linux Install Script (malis).
# Common functions and definitions.
#
set -eu
#
# common static variables
MALIS_CONF_FILE="malis.conf"
MALIS_LOG_FILE="malis.log"
#? MALIS_ASCIINEMA_FILE="malis.asciinema"
#? RECOVERY_CONF_FILE="malis-recovery.conf"
#? RECOVERY_LOG_FILE="malis-recovery.log"
#? RECOVERY_ASCIINEMA_FILE="malis-recovery.asciinema"
PACKAGES_CONF_FILE="malis-packages.conf"
PACKAGES_LOG_FILE="malis-packages.log"
COMMONS_CONF_FILE="malis-commons.conf"
PROVISION_DIRECTORY="files/"

RED='\033[0;91m'
GREEN='\033[0;92m'
BLUE='\033[0;96m'
WHITE='\033[0;97m'
NC='\033[0m'

function sanitize_variable() {
    local VARIABLE="$1"
    local VARIABLE=$(echo "$VARIABLE" | sed "s/![^ ]*//g") # remove disabled
    local VARIABLE=$(echo "$VARIABLE" | sed -r "s/ {2,}/ /g") # remove unnecessary white spaces
    local VARIABLE=$(echo "$VARIABLE" | sed 's/^[[:space:]]*//') # trim leading
    local VARIABLE=$(echo "$VARIABLE" | sed 's/[[:space:]]*$//') # trim trailing
    echo "$VARIABLE"
}

function trim_variable() {
    local VARIABLE="$1"
    local VARIABLE=$(echo "$VARIABLE" | sed 's/^[[:space:]]*//') # trim leading
    local VARIABLE=$(echo "$VARIABLE" | sed 's/[[:space:]]*$//') # trim trailing
    echo "$VARIABLE"
}

function check_variables_value() {
    local NAME="$1"
    local VALUE="$2"
    if [ -z "$VALUE" ]; then
        echo "$NAME environment variable must have a value."
        exit 1
    fi
}

function check_variables_boolean() {
    local NAME="$1"
    local VALUE="$2"
    check_variables_list "$NAME" "$VALUE" "true false" "true" "true"
}

function check_variables_list() {
    local NAME="$1"
    local VALUE="$2"
    local VALUES="$3"
    local REQUIRED="$4"
    local SINGLE="$5"

    if [ "$REQUIRED" == "" ] || [ "$REQUIRED" == "true" ]; then
        check_variables_value "$NAME" "$VALUE"
    fi

    if [[ ("$SINGLE" == "" || "$SINGLE" == "true") && "$VALUE" != "" && "$VALUE" =~ " " ]]; then
        echo "$NAME environment variable value [$VALUE] must be a single value of [$VALUES]."
        exit 1
    fi

    if [ "$VALUE" != "" ] && [ -z "$(echo "$VALUES" | grep -F -w "$VALUE")" ]; then #SC2143
        echo "$NAME environment variable value [$VALUE] must be in [$VALUES]."
        exit 1
    fi
}

function check_variables_equals() {
    local NAME1="$1"
    local NAME2="$2"
    local VALUE1="$3"
    local VALUE2="$4"
    if [ "$VALUE1" != "$VALUE2" ]; then
        echo "$NAME1 and $NAME2 must be equal [$VALUE1, $VALUE2]."
        exit 1
    fi
}

function check_variables_size() {
    local NAME="$1"
    local SIZE_EXPECT="$2"
    local SIZE="$3"
    if [ "$SIZE_EXPECT" != "$SIZE" ]; then
        echo "$NAME array size [$SIZE] must be [$SIZE_EXPECT]."
        exit 1
    fi
}

function configure_network() {
    if [ -n "$WIFI_INTERFACE" ]; then
        iwctl --passphrase "$WIFI_KEY" station "$WIFI_INTERFACE" connect "$WIFI_ESSID"
        sleep 10
    fi

    # only one ping -c 1, ping gets stuck if -c 5
    if ! ping -c 1 -i 2 -W 5 -w 30 "$PING_HOSTNAME"; then
        echo "Network ping check failed. Cannot continue."
        exit 1
    fi
}

function facts_commons() {
    if [ -d /sys/firmware/efi ]; then
        BIOS_TYPE="uefi"
    else
        BIOS_TYPE="bios"
    fi

    if [ -f "$MALIS_ASCIINEMA_FILE" ] || [ -f "$RECOVERY_ASCIINEMA_FILE" ]; then
        ASCIINEMA="true"
    else
        ASCIINEMA="false"
    fi

    if lscpu | grep -q "GenuineIntel"; then
        CPU_VENDOR="intel"
    elif lscpu | grep -q "AuthenticAMD"; then
        CPU_VENDOR="amd"
    else
        CPU_VENDOR=""
    fi

    if lspci -nn | grep "\[03" | grep -qi "intel"; then
        GPU_VENDOR="intel"
    elif lspci -nn | grep "\[03" | grep -qi "amd"; then
        GPU_VENDOR="amd"
    elif lspci -nn | grep "\[03" | grep -qi "nvidia"; then
        GPU_VENDOR="nvidia"
    elif lspci -nn | grep "\[03" | grep -qi "vmware"; then
        GPU_VENDOR="vmware"
    else
        GPU_VENDOR=""
    fi

    if systemd-detect-virt | grep -qi "oracle"; then
        VIRTUALBOX="true"
    else
        VIRTUALBOX="false"
    fi

    if systemd-detect-virt | grep -qi "vmware"; then
        VMWARE="true"
    else
        VMWARE="false"
    fi

    INITRD_MICROCODE=""
    if [ "$VIRTUALBOX" != "true" ] && [ "$VMWARE" != "true" ]; then
        if [ "$CPU_VENDOR" == "intel" ]; then
            INITRD_MICROCODE="intel-ucode.img"
        elif [ "$CPU_VENDOR" == "amd" ]; then
            INITRD_MICROCODE="amd-ucode.img"
        fi
    fi

    USER_NAME_INSTALL="$(whoami)"
    if [ "$USER_NAME_INSTALL" == "root" ]; then
        SYSTEM_INSTALLATION="true"
    else
        SYSTEM_INSTALLATION="false"
    fi
}

function init_log_trace() {
    local ENABLE="$1"
    if [ "$ENABLE" == "true" ]; then
        set -o xtrace
    fi
}

function init_log_file() {
    local ENABLE="$1"
    local FILE="$2"
    if [ "$ENABLE" == "true" ]; then
        exec &> >(tee -a "$FILE")
    fi
}

function pacman_uninstall() {
    local ERROR="true"
    local PACKAGES=()
    set +e
    IFS=' ' read -ra PACKAGES <<< "$1"
    local PACKAGES_UNINSTALL=()
    for PACKAGE in "${PACKAGES[@]}"
    do
        execute_sudo "pacman -Qi $PACKAGE > /dev/null 2>&1"
        local PACKAGE_INSTALLED=$?
        if [ $PACKAGE_INSTALLED == 0 ]; then
            local PACKAGES_UNINSTALL+=("$PACKAGE")
        fi
    done
    if [ -z "${PACKAGES_UNINSTALL[*]}" ]; then
        return
    fi
    local COMMAND="pacman -Rdd --noconfirm ${PACKAGES_UNINSTALL[*]}"
    if execute_sudo "$COMMAND"; then
        local ERROR="false"
    fi
    set -e
    if [ "$ERROR" == "true" ]; then
        exit 1
    fi
}

function pacman_install() {
    local ERROR="true"
    local PACKAGES=()
    set +e
    IFS=' ' read -ra PACKAGES <<< "$1"
    for VARIABLE in {1..5}
    do
        local COMMAND="pacman -Syu --noconfirm --needed ${PACKAGES[*]}"
       if execute_sudo "$COMMAND"; then
            local ERROR="false"
            break
        else
            sleep 10
        fi
    done
    set -e
    if [ "$ERROR" == "true" ]; then
        exit 1
    fi
}

function aur_install() {
    local ERROR="true"
    local PACKAGES=()
    set +e
    which "$AUR_COMMAND"
    if [ "$AUR_COMMAND" != "0" ]; then
        aur_command_install "$USER_NAME" "$AUR_PACKAGE"
    fi
    IFS=' ' read -ra PACKAGES <<< "$1"
    for VARIABLE in {1..5}
    do
        local COMMAND="$AUR_COMMAND -Syu --noconfirm --needed ${PACKAGES[*]}"
        if execute_aur "$COMMAND"; then
            local ERROR="false"
            break
        else
            sleep 10
        fi
    done
    set -e
    if [ "$ERROR" == "true" ]; then
        return
    fi
}

function aur_command_install() {
    pacman_install "git"
    local USER_NAME="$1"
    local COMMAND="$2"
    execute_aur "rm -rf /home/$USER_NAME/.alis && mkdir -p /home/$USER_NAME/.alis/aur && cd /home/$USER_NAME/.alis/aur && git clone https://aur.archlinux.org/${COMMAND}.git && (cd $COMMAND && makepkg -si --noconfirm) && rm -rf /home/$USER_NAME/.alis"
}

function systemd_units() {
    local UNITS=()
    IFS=' ' read -ra UNITS <<< "$SYSTEMD_UNITS"
    for U in "${UNITS[@]}"; do
        local ACTION=""
        local UNIT=${U}
        if [[ $UNIT == -* ]]; then
            local ACTION="disable"
            local UNIT=$(echo "$UNIT" | sed "s/^-//g")
        elif [[ $UNIT == +* ]]; then
            local ACTION="enable"
            local UNIT=$(echo "$UNIT" | sed "s/^+//g")
        elif [[ $UNIT =~ ^[a-zA-Z0-9]+ ]]; then
            local ACTION="enable"
            local UNIT=$UNIT
        fi

        if [ -n "$ACTION" ]; then
            execute_sudo "systemctl $ACTION $UNIT"
        fi
    done
}

function execute_flatpak() {
    local COMMAND="$1"
    if [ "$SYSTEM_INSTALLATION" == "true" ]; then
        arch-chroot "${MNT_DIR}" bash -c "$COMMAND"
    else
        bash -c "$COMMAND"
    fi
}

function execute_aur() {
    local COMMAND="$1"
    if [ "$SYSTEM_INSTALLATION" == "true" ]; then
        arch-chroot "${MNT_DIR}" sed -i 's/^%wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
        arch-chroot "${MNT_DIR}" bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -s /usr/bin/bash -c \"$COMMAND\""
        arch-chroot "${MNT_DIR}" sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL$/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    else
        bash -c "$COMMAND"
    fi
}

function execute_sudo() {
    local COMMAND="$1"
    if [ "$SYSTEM_INSTALLATION" == "true" ]; then
        arch-chroot "${MNT_DIR}" bash -c "$COMMAND"
    else
        sudo bash -c "$COMMAND"
    fi
}

function execute_user() {
    local USER_NAME="$1"
    local COMMAND="$2"
    if [ "$SYSTEM_INSTALLATION" == "true" ]; then
        arch-chroot "${MNT_DIR}" bash -c "su $USER_NAME -s /usr/bin/bash -c \"$COMMAND\""
    else
        bash -c "$COMMAND"
    fi
}

function do_reboot() {
    umount -R "${MNT_DIR}"/boot
    umount -R "${MNT_DIR}"
    reboot
}

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

function ask_password() {
    PASSWORD_NAME="$1"
    PASSWORD_VARIABLE="$2"
    read -r -sp "Type ${PASSWORD_NAME} password: " PASSWORD1
    echo ""
    read -r -sp "Retype ${PASSWORD_NAME} password: " PASSWORD2
    echo ""
    if [[ "$PASSWORD1" == "$PASSWORD2" ]]; then
        declare -n VARIABLE="${PASSWORD_VARIABLE}"
        VARIABLE="$PASSWORD1"
    else
        echo "${PASSWORD_NAME} password don't match. Please, type again."
        ask_password "${PASSWORD_NAME}" "${PASSWORD_VARIABLE}"
    fi
}
