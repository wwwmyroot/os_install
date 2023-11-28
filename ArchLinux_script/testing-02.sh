#!/bin/bash
#
# https://github.com/picodotdev/alis/blob/master/alis-packages.sh
#
# построено на функциях, которые друг-друга вызывают
# хороший уровень, но пока не потяну

VAR_RUN="false"

function init_config() {
    local COMMONS_FILE="alis-commons.sh"

    source "$COMMONS_FILE"
    if [ "$PACKAGES_STANDALONE" == "true" ]; then
        source "$COMMONS_CONF_FILE"
    fi
    source "$PACKAGES_CONF_FILE"
}

function main() {
    local START_TIMESTAMP=$(date -u +"%F %T")
    set +u
    if [ "$COMMOMS_LOADED" != "true" ]; then
        VAR_RUN="true"
    fi
    set -u

    init_config



}
