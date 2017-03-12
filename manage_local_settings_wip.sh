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
#ask for package manager backend (apt, pacman, pacaur, yaourt)

echo ":: Reloading bash environment."
source ~/.bashrc && clear

cd ${CURRENT_WORKING_DIRECTORY}
