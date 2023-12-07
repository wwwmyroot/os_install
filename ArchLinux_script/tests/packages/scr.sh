#!/usr/bin/env sh
#
#
PKG_LIST="./malis-packages.conf"
source "$PKG_LIST"
#
#
function sanitize_variable() {
    local VARIABLE="$1"
    local VARIABLE=$(echo "${VARIABLE}" | sed "s/![^ ]*//g") # remove disabled
    local VARIABLE=$(echo "${VARIABLE}" | sed -r "s/ {2,}/ /g") # remove unnecessary white spaces
    local VARIABLE=$(echo "${VARIABLE}" | sed 's/^[[:space:]]*//') # trim leading
    local VARIABLE=$(echo "${VARIABLE}" | sed 's/[[:space:]]*$//') # trim trailing
    echo "$VARIABLE"
}
#
function execute_step() {
    local STEP="$1"
    eval "${STEP}"
}
#
function print_step() {
    STEP="$1"
    echo ""
    echo -e "${BLUE}# ${STEP} step${NC}"
    echo ""
}
# -------------------
#
function sanitize_variables() {
    PACKAGES_PACMAN=$(sanitize_variable "${PACKAGES_PACMAN}")
    PACKAGES_PACMAN_PIPEWIRE=$(sanitize_variable "${PACKAGES_PACMAN_PIPEWIRE}")
    # PACKAGES_FLATPAK=$(sanitize_variable "$PACKAGES_FLATPAK")
    # PACKAGES_SDKMAN=$(sanitize_variable "$PACKAGES_SDKMAN")
    # PACKAGES_AUR_COMMAND=$(sanitize_variable "$PACKAGES_AUR_COMMAND")
    # PACKAGES_AUR=$(sanitize_variable "$PACKAGES_AUR")
    SYSTEMD_UNITS=$(sanitize_variable "${SYSTEMD_UNITS}")
}
#
function check_variables() {
    check_variables_boolean "PACKAGES_PACMAN_INSTALL" "${PACKAGES_PACMAN_INSTALL}"
    check_variables_boolean "PACKAGES_PACMAN_INSTALL_PIPEWIRE" "${PACKAGES_PACMAN_INSTALL_PIPEWIRE}"
}
#
function check_variables_boolean() {
    local NAME="$1"
    local VALUE="$2"
    check_variables_list "$NAME" "$VALUE" "true false" "true" "true"
}
#
function check_variables_list() {
    local NAME="$1"
    local VALUE="$2"
    local VALUES="$3"
    local REQUIRED="$4"
    local SINGLE="$5"

    if [ "${REQUIRED}" == "" ] || [ "${REQUIRED}" == "true" ]; then
        check_variables_value "${NAME}" "${VALUE}"
    fi

    if [[ ("${SINGLE}" == "" || "${SINGLE}" == "true") && "${VALUE}" != "" && "${VALUE}" =~ " " ]]; then
        echo "${NAME} environment variable value [${VALUE}] must be a single value of [${VALUES}]."
        exit 1
    fi

    if [ "${VALUE}" != "" ] && [ -z "$(echo "${VALUES}" | grep -F -w "${VALUE}")" ]; then #SC2143
        echo "${NAME} environment variable value [${VALUE}] must be in [${VALUES}]."
        exit 1
    fi
}
#
function check_variables_value() {
    local NAME="$1"
    local VALUE="$2"
    if [ -z "${VALUE}" ]; then
        echo "${NAME} environment variable must have a value."
        exit 1
    fi
}
#
function end() {
    echo ""
    echo -e "${GREEN}Arch Linux packages installed successfully"'!'"${NC}"
    echo ""
}
#
function main_scr() {
#     local START_TIMESTAMP=$(date -u +"%F %T")
#     set +u
#     if [ "$COMMOMS_LOADED" != "true" ]; then
#         PACKAGES_STANDALONE="true"
#     fi
#     set -u

#     init_config
    execute_step "sanitize_variables"
    execute_step "check_variables"
#     execute_step "init"
#     execute_step "facts"
#     execute_step "checks"
#     execute_step "prepare"
#     execute_step "packages"
#     execute_step "systemd_units"
#     local END_TIMESTAMP=$(date -u +"%F %T")
#     local INSTALLATION_TIME=$(date -u -d @$(($(date -d "$END_TIMESTAMP" '+%s') - $(date -d "$START_TIMESTAMP" '+%s'))) '+%T')
#     echo -e "Installation packages start ${WHITE}$START_TIMESTAMP${NC}, end ${WHITE}$END_TIMESTAMP${NC}, time ${WHITE}$INSTALLATION_TIME${NC}"
    # execute_step "end"
}

# main_scr
