#!/bin/bash
########
# Migration script for smaller changes
#
# @author stev leibelt
# @since 2017-03-12
########

CURRENT_WORKING_DIRECTORY=$(pwd)
PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)

cd ${PATH_TO_THIS_SCRIPT}

#backup existing local.setting file
#fetch all available option by cat setting
#ask for package manager backend (apt, pacman, pacaur, yaourt)

## begin of fetch available option
echo ":: Listing available options."
#@todo
#cat ${PATH_TO_THIS_SCRIPT}/setting | grep NET_BAZZLINE_
INDEX_OF_EQUAL_SIGN=$(expr index "${CURRENT_FULL_OPTION}" "=")
#remove NET_BAZZLINE_ (13) and all starting at =
LENGTH_WE_WANT_TO_CUT_OUT=$(expr 13 - ${INDEX_OF_EQUAL_SIGN})
CURRENT_OPTION="${CURRENT_FULL_OPTION:13:}"
## end of fetch available option

#sed -i -e 's/abc/XYZ/g' /tmp/file.txt

echo ":: Reloading bash environment."
source ~/.bashrc && clear

cd ${CURRENT_WORKING_DIRECTORY}
