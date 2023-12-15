#!/bin/bash
#
# -- to test multiline insertion
execute_sudo "echo -e \"# alis\n$CUSTOM_REPOSITORIES\" >> /etc/pacman.conf"
#
# -- constant variables
#
function init() {
    print_step "init()"
    if [ -f "$(pwd)/source.txt" ]; then
    echo "-- source.txt is present"
    break
    else
        echo -e "-- (!) ERROR: No source.txt file in current directory. --"
        echo -e "-- check current directory: --"
        ls -lah
        echo -e "---- TERMINATE ----"
        exit 1
    fi
    #
    execute_sudo "cat ./source.txt > target.txt"
    #
    if [ -f "$(pwd)/target.txt" ]; then
    echo "-- target.txt owerriten as root to default source.txt"
    break
    else
        echo -e "-- (!) ERROR: No target.txt file in current directory. --"
        echo -e "-- check current directory: --"
        ls -lah
        echo -e "---- TERMINATE ----"
        exit 1
    fi
    #
    execute_sudo "chown root:root ./target.txt"
    ls -lah
    echo " -- -- -- --"
}
#
function execute_step() {
    local STEP="$1"
    eval "$STEP"
}
#
function print_step() {
    STEP="$1"
    echo -e "${UBYellow}-- ${STEP} step --${Color_Off}"
}
#
function execute_sudo() {
    local COMMAND="$1"
    sudo bash -c "${COMMAND}"
}
#
#
#
#
function test_sed_newline() {
    print_step "test_sed()"
    execute_sudo "sed -i 's/line 2. Some text. bb bb cc/line 2. Some text. bb bb cc\n--SUCCESS if is in new line/' ./target.txt"
}
#
function test_echo_newline() {
    print_step "test_echo_newline()"
    execute_sudo "echo -e \"# AAA BBB\nCCC DDD\nEEE FFF\" >> ./target.txt"
}
#
#
#
#
function main() {
    print_step "-- START"
    execute_step "init"
    execute_step "test_sed_newline"
    execute_step "test_echo_newline"
    # execute_step "v3"
    # execute_step "v3"
}



main "$@"
# main
