#!/bin/bash
####
# @since 2019-05-28
# @author stev leibelt <artodeto@bazzline.net>
####

#begin of testing if we are on the right system
if [[ ! -f /usr/bin/pacman ]];
then
    echo ":: Can not install on your system."
    echo "   Sorry dude, I can only install things on a arch linux."

    exit 1
fi

sudo pacman -Syy
#end of testing if we are on the right system

CURRENT_WORKING_DIRECTORY=$(pwd)

if [[ ! -f /usr/bin/pactree ]];
then
#@see: https://wiki.archlinux.org/index.php/Pacman#Pactree
    echo ":: Pactree is missing but mandatory."
    echo ":: Installing pactree."

    sudo pacman -S pacman-contrib
fi

if [[ ! -f /usr/bin/keepassxc ]];
then
    echo ":: Installing keepassxc"
    sudo pacman -S keepassxc
fi

