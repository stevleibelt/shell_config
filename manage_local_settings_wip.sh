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
cat ${PATH_TO_THIS_SCRIPT}/setting | grep NET_BAZZLINE_
## end of fetch available option

#sed -i -e 's/abc/XYZ/g' /tmp/file.txt

echo ":: Reloading bash environment."
source ~/.bashrc && clear

cd ${CURRENT_WORKING_DIRECTORY}
