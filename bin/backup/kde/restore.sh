#!/bin/bash
####
# Tries to backup most important kde user settings
####
# @since 2022-01-22
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
    declare -a ARRAY_OF_DIRECTORY_NAMES=("kdeconnect" "kdeglobals" "ktimezonedrc" "kwinrc" "kxkbrc" "plasma-localerc" "plasma-locale-settings.sh" "plasma-nm" "plasmarc")
    local BACKUP_DIRECTORY_PATH=${1:-"${HOME}/backup/kde"}
    local CURRENT_WORKING_DIRECTORY=$(pwd)
    local TAR_BACKUP_DIRECTORY=0

    if [[ ! -d "${HOME}/.config" ]];
    then
        echo ":: Expected path does not exist."
        echo "   Directory path >>${HOME}/.config<< does not exist."

        return 1
    fi

    cd $(dirname "${BACKUP_DIRECTORY_PATH}")

    if [[ ! -f "${BACKUP_DIRECTORY_PATH}.tar.gz" ]];
    then
        echo ":: Expected file does not exist."
        echo "   File path >>${BACKUP_DIRECTORY_PATH}.tar.gz<< does not exist."

        return 2
    fi

    tar -xzf "${BACKUP_DIRECTORY_PATH}.tar.gz"

    if [[ ! -d "${BACKUP_DIRECTORY_PATH}" ]];
    then
        echo ":: Expected path does not exist."
        echo "   Directory path >>${BACKUP_DIRECTORY_PATH}<< does not exist."

        return 3
    fi

    cd "${BACKUP_DIRECTORY_PATH}"

    for CURRENT_DIRECTORY in "${ARRAY_OF_DIRECTORY_NAMES[@]}";
    do
        if [[ -d "${CURRENT_DIRECTORY}" ]];
        then
            cp -r "${CURRENT_DIRECTORY}" "${HOME}/.config/"
        fi
    done

    cd "${CURRENT_WORKING_DIRECTORY}"
}

_main $@
