#!/bin/bash
####
# @see: https://github.com/neurobin/pacget
####

CURRENT_WORKING_DIRECTORY=$(pwd)
PATH_TO_CURL=/usr/bin/curl

if [[ ! -f ${PATH_TO_CURL} ]];
then
    echo ":: Curl is missing but mandatory"

    exit 1
fi

##begin of temporary path creation
TEMPORARY_DIRECTORY_PATH=$(mktemp -d)
cd ${TEMPORARY_DIRECTORY_PATH}
##begin of temporary path creation

##begin of downloading
${PATH_TO_CURL} -O https://raw.githubusercontent.com/neurobin/pacget/release/install.sh
##end of downloading

##begin of preparation and installation
chmod +x install.sh
./install.sh
##end of preparation and installation

##begin of clean up
cd -
rm -fr ${TEMPORARY_DIRECTORY_PATH}
##end of clean up
