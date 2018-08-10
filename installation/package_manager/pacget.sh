#!/bin/bash
####
# @see: https://github.com/neurobin/pacget
# @since 2018-02-01
# @author stev leibelt <artodeto@bazzline.net>
####

#begin of testing if we are on the right system
if [[ ! -f /usr/bin/pacman ]];
then
    echo ":: Can not install on your system."
    echo "   Sorry dude, I can only install things on a arch linux."

    exit 1
fi
#end of testing if we are on the right system

CURRENT_WORKING_DIRECTORY=$(pwd)
PATH_TO_CURL=/usr/bin/curl
PATH_TO_PACTREE=/usr/bin/pactree

if [[ ! -f ${PATH_TO_CURL} ]];
then
    echo ":: Curl is missing but mandatory."
    echo ":: Installing curl."

    sudo pacman -S curl
fi

if [[ ! -f ${PATH_TO_PACTREE} ]];
then
    echo ":: Pactree is missing but mandatory."
    echo ":: Installing pactre."

    sudo pacman -S pacman-contrig
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
cd ${CURRENT_WORKING_DIRECTORY}
rm -fr ${TEMPORARY_DIRECTORY_PATH}
##end of clean up
