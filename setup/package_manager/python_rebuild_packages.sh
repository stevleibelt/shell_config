#!/bin/bash
####
# @see: https://linuxundich.de/gnu-linux/upgrade-auf-python-3-10-zeit-die-aur-pakete-neu-zu-bauen/
# @since 2018-07-22
# @author stev leibelt <artodeto@bazzline.net>
####

function _upgrade()
{
    local PACKAGEMANAGER='';
    local PATH_TO_OUTDATED_PYTHON_PACKAGE='/usr/lib/python3.9'

    #begin of testing if we are on the right system
    if [[ ! -f /usr/bin/pacman ]];
    then
        echo ":: Can not install on your system."
        echo "   Sorry dude, I can only install things on a arch linux."

        exit 1
    fi

    if [[ -f /usr/bin/yay ]];
    then
        PACKAGEMANAGER='yay';
    elif [[ -f /usr/bin/paru ]];
    then
        PACKAGEMANAGER='yay';
    else
        echo ":: Can not upgrade your aur python packages."
        echo "   Neither yay or paru was found."

        exit 2
    fi

    echo ":: Fetching python packages to upgrade."
    pacman -Qop "${PATH_TO_OUTDATED_PYTHON_PACKAGE}"

    echo ""
    echo ":: Rebuilding packages."
    pacman -Qop "${PATH_TO_OUTDATED_PYTHON_PACKAGE}" | ${PACKAGEMANAGER} -S - --rebuild

    echo ":: Just for testing ... fetching python packages to upgrade."
    pacman -Qop "${PATH_TO_OUTDATED_PYTHON_PACKAGE}"
}

_upgrade
