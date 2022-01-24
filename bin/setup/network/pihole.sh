#!/bin/bash
####
# Installs or updates pi-hole-ftl
####
# @since 2020-02-25
# @author stev leibelt <artodeto.bazzline.net>
####


function install_or_update_pi_hole_ftl()
{
    PATH_TO_THE_PI_HOLE_FTL_SOURCE=${HOME}/software/source/net/archlinux/aur/pi-hole-ftl

    if [[ -f /usr/bin/pihole ]];
    then
        echo ":: Pihole is installed already, will upgrade it."
        local STOP_RUNNING_PROCESS=1;
    else
        echo ":: Pihole is not yet installed, will install it."
        local STOP_RUNNING_PROCESS=0;
    fi

    if [[ ! -d ${PATH_TO_THE_PI_HOLE_FTL_SOURCE} ]];
    then
        echo ":: Creating source path for repository."
        echo "   ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}"
        /usr/bin/mkdir -p ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}
        cd ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}
        git clone https://aur.archlinux.org/pi-hole-ftl.git .
    fi

    echo ":: Pulling latest commits from the repository."
    cd ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}
    git pull

    echo ":: Building package."
    makepkg -sri

    #echo ":: Installing package."
    #sudo pacman -U $.tar.xz

    if [[ ${STOP_RUNNING_PROCESS} -eq 1 ]];
    then
        echo ":: Stopping service."
        sudo systemctl stop pihole-FTL.service
    fi

    echo ":: Starting service."
    systemctl start pihole-FTL.service

    echo ":: Updating gravity."
    sudo pihole -g

    echo ":: Take a look into the path to clean things up from time to time."
    echo "   ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}"

    echo ":: Removing *.pkg.tar.xz files in ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}."
    rm -v ${PATH_TO_THE_PI_HOLE_FTL_SOURCE}/*.pkg.tar.xz
}

install_or_update_pi_hole_ftl
