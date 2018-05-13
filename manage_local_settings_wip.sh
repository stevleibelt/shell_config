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
#echo ":: Listing available options."
#@todo
#   instead of simple listing the stuff, read it from the available and current setting
#   if set, always display the current value by sourcing in the setting and the local.setting
#cat ${PATH_TO_THIS_SCRIPT}/setting | grep NET_BAZZLINE_
#INDEX_OF_EQUAL_SIGN=$(expr index "${CURRENT_FULL_OPTION}" "=")
#remove NET_BAZZLINE_ (13) and all starting at =
#LENGTH_WE_WANT_TO_CUT_OUT=$(expr 13 - ${INDEX_OF_EQUAL_SIGN})
#CURRENT_OPTION="${CURRENT_FULL_OPTION:13:}"

echo ":: Do you want to automatically start ssh agent (if available?) (y|n)"
if [[ ${NET_BAZZLINE_AUTOSTART_SSH_AGENT} -eq 1 ]];
then
    echo "   Current value is yes."
else
    echo "   Current value is no."
fi
read YES_OR_NO;

if [[ ${YES_OR_NO} == "y" ]];
then
    NET_BAZZLINE_AUTOSTART_SSH_AGENT=1
else
    NET_BAZZLINE_AUTOSTART_SSH_AGENT=0
fi

if uname -r | grep -q lts;
then
    echo ":: Detected lts kernel."
    NET_BAZZLINE_IS_LTS_KERNEL=1
else
    echo ":: Detected regular kernel."
    NET_BAZZLINE_IS_LTS_KERNEL=0
fi


#add all you known interfaces in here
NET_BAZZLINE_INTERFACES=()
#allowed are [apk, apt, none, pacman, pacaur, pacget]
NET_BAZZLINE_PACKAGE_MANAGER='none'
#either write statistics of function usage or not
#1 turns it on, all other values disables it
NET_BAZZLINE_RECORD_FUNCTION_USAGE=0
#timeout in minutes to forget ssh password
NET_BAZZLINE_REMEMBER_SSH_PASSWORD_TIMEOUT_IN_MINUTES=30
#add port where your secure connection is listen on (via ssh -D)
NET_BAZZLINE_SECURE_CONNECTION_PORT=0
## end of fetch available option

#sed -i -e 's/abc/XYZ/g' /tmp/file.txt

echo ":: Reloading bash environment."
source ~/.bashrc && clear

cd ${CURRENT_WORKING_DIRECTORY}
