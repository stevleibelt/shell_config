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

    local BACKUP_TAR_PATH="${BACKUP_DIRECTORY_PATH}.tar.gz"

    if [[ ! -d "${HOME}/.config" ]];
    then
        echo ":: Expected path does not exist."
        echo "   Directory path >>${HOME}/.config<< does not exist."

        return 1
    fi

    cd "${HOME}/.config"

    for CURRENT_DIRECTORY in "${ARRAY_OF_DIRECTORY_NAMES[@]}";
    do
        if [[ -d "${CURRENT_DIRECTORY}" ]];
        then
            TAR_BACKUP_DIRECTORY=1
            cp -r "${CURRENT_DIRECTORY}" "${BACKUP_DIRECTORY_PATH}/"
        fi
    done

    if [[ ${TAR_BACKUP_DIRECTORY} -eq 1 ]];
    then
        tar -czf "${BACKUP_TAR_PATH}" "${BACKUP_DIRECTORY_PATH}"

        if [[ $? -ne 0 ]];
        then
            echo ":: Something bad has happened."
            echo "   Backup path not deleted."
            echo "   Path is >>${BACKUP_DIRECTORY_PATH}<<."
            echo "   Please check if tar archive still exists in path >>${BACKUP_TAR_PATH}<<."

            return 2
        fi
    fi

    cd "${CURRENT_WORKING_DIRECTORY}"
}

_main $@
