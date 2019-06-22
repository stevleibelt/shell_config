#!/bin/bash
########
# Migration script for smaller changes
#
# @author stev leibelt
# @since 2017-01-31
########

CURRENT_WORKING_DIRECTORY=$(pwd)
PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)

cd "${PATH_TO_THIS_SCRIPT}"

echo ":: Updating repository."
git pull --quiet

echo ":: Reloading bash environment."
source ~/.bashrc && clear

cd "${CURRENT_WORKING_DIRECTORY}"
