#!/bin/bash
########
# Migration script for bigger changes
#
# @author stev leibelt
# @since 2016-04-23
########

LOCAL_CURRENT_WORKING_DIRECTORY=$(pwd)
LOCAL_PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
LOCAL_PATH_TO_CURRENT_VERSION_FILE=${LOCAL_PATH_TO_THIS_SCRIPT}"/.current_version"
LOCAL_PATH_TO_CURRENT_INSTALLED_VERSION_FILE=${LOCAL_PATH_TO_THIS_SCRIPT}"/.current_installed_version"

cd ${LOCAL_PATH_TO_THIS_SCRIPT}

echo ":: Updating repository."
git pull --quiet

if [[ ! -f ${LOCAL_PATH_TO_CURRENT_INSTALLED_VERSION_FILE} ]]
then
    #version 0
    echo 0 > ${LOCAL_PATH_TO_CURRENT_INSTALLED_VERSION_FILE}
fi

LOCAL_CURRENT_VERSION=$(cat ${LOCAL_PATH_TO_CURRENT_VERSION_FILE})
LOCAL_CURRENT_INSTALLED_VERSION=$(cat ${LOCAL_PATH_TO_CURRENT_INSTALLED_VERSION_FILE})

if [[ ${LOCAL_CURRENT_VERSION} -eq ${LOCAL_CURRENT_INSTALLED_VERSION} ]]
then
    echo ":: Latest version already installed. Nothing to do."
else
    #begin of version 0 migration
    if [[ ${LOCAL_CURRENT_INSTALLED_VERSION} -eq 0 ]]
    then
        echo ":: Migrating from version ${LOCAL_CURRENT_INSTALLED_VERSION} to "$((${LOCAL_CURRENT_INSTALLED_VERSION} + 1))

        declare -a LOCAL_FILES_TO_RENAME=('setting' 'variable' 'source' 'export' 'function' 'alias' 'automatic_start')

        for LOCAL_FILE_TO_RENAME in ${LOCAL_FILES_TO_RENAME[@]}; do
            LOCAL_DESTINATION_FILE_PATH=${LOCAL_PATH_TO_THIS_SCRIPT}"/local."${LOCAL_FILE_TO_RENAME}
            LOCAL_SOURCE_FILE_PATH=${LOCAL_PATH_TO_THIS_SCRIPT}"/"${LOCAL_FILE_TO_RENAME}".local"

            #does local source file exist?
            if [[ -f ${LOCAL_SOURCE_FILE_PATH} ]]
            then
                #does local destionation file exist?
                if [[ -f ${LOCAL_DESTINATION_FILE_PATH} ]]
                then
                    echo ":: Note!"
                    echo ":: File ${LOCAL_DESTINATION_FILE_PATH} already exist"
                    echo ":: Can not move ${LOCAL_SOURCE_FILE_PATH}"
                    echo ":: Please merge it manually"
                    echo ""
                else
                    mv ${LOCAL_SOURCE_FILE_PATH} ${LOCAL_DESTINATION_FILE_PATH}
                fi
            fi
        done;

        LOCAL_CURRENT_INSTALLED_VERSION=$((LOCAL_CURRENT_VERSION + 1))
    fi
    #end of version 0 migration

    #begin of updating currently installed version
    echo ${LOCAL_CURRENT_VERSION} > ${LOCAL_PATH_TO_CURRENT_INSTALLED_VERSION_FILE}
    #end of updating currently installed version
fi

cd ${LOCAL_CURRENT_WORKING_DIRECTORY}
