#!/bin/bash
########
# Migration script for bigger changes
#
# @author stev leibelt
# @since 2016-04-23
########

CURRENT_WORKING_DIRECTORY=$(pwd)
PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
PATH_TO_CURRENT_VERSION_FILE=${PATH_TO_THIS_SCRIPT}"/.current_version"
PATH_TO_CURRENT_INSTALLED_VERSION_FILE=${PATH_TO_THIS_SCRIPT}"/.current_installed_version"

cd "${PATH_TO_THIS_SCRIPT}"

echo ":: Updating repository."
git pull --quiet

if [[ ! -f ${PATH_TO_CURRENT_INSTALLED_VERSION_FILE} ]]
then
    #version 0
    echo 0 > ${PATH_TO_CURRENT_INSTALLED_VERSION_FILE}
fi

CURRENT_VERSION=$(cat ${PATH_TO_CURRENT_VERSION_FILE})
CURRENT_INSTALLED_VERSION=$(cat ${PATH_TO_CURRENT_INSTALLED_VERSION_FILE})

if [[ ${CURRENT_VERSION} -eq ${CURRENT_INSTALLED_VERSION} ]]
then
    echo ":: Latest version already installed. Nothing to do."
else
    #begin of version 0 migration
    if [[ ${CURRENT_INSTALLED_VERSION} -eq 0 ]]
    then
        echo ":: Migrating from version ${CURRENT_INSTALLED_VERSION} to "$((${CURRENT_INSTALLED_VERSION} + 1))"."

        declare -a FILES_TO_RENAME=('setting' 'variable' 'source' 'export' 'function' 'alias' 'automatic_start')

        for FILE_TO_RENAME in ${FILES_TO_RENAME[@]}; do
            DESTINATION_FILE_PATH=${PATH_TO_THIS_SCRIPT}"/local."${FILE_TO_RENAME}
            SOURCE_FILE_PATH=${PATH_TO_THIS_SCRIPT}"/"${FILE_TO_RENAME}".local"

            #does local source file exist?
            if [[ -f ${SOURCE_FILE_PATH} ]]
            then
                #does local destionation file exist?
                if [[ -f ${DESTINATION_FILE_PATH} ]]
                then
                    echo ":: Note!"
                    echo ":: File ${DESTINATION_FILE_PATH} already exist."
                    echo ":: Can not move ${SOURCE_FILE_PATH}."
                    echo ":: Please merge it manually."
                    echo ""
                else
                    mv ${SOURCE_FILE_PATH} ${DESTINATION_FILE_PATH}
                fi
            fi
        done;

        CURRENT_INSTALLED_VERSION=$((CURRENT_VERSION + 1))
    fi
    #end of version 0 migration

    #begin of version 1 migration
    if [[ ${CURRENT_INSTALLED_VERSION} -eq 1 ]]
    then
        CURRENT_INSTALLED_VERSION=$((CURRENT_VERSION + 1))
    fi
    #end of version 1 migration

    #begin of updating currently installed version
    echo ${CURRENT_VERSION} > ${PATH_TO_CURRENT_INSTALLED_VERSION_FILE}
    #end of updating currently installed version
fi

echo ":: Reloading bash environment."
source "${PATH_TO_THIS_SCRIPT}/bootstrap" && clear
#source ~/.bashrc && clear

cd ${CURRENT_WORKING_DIRECTORY}
