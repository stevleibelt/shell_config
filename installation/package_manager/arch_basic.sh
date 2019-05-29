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

if [[ ! -f /etc/pacman.d/hooks/trigger_cleanup_paccache.hook ]];
then
    echo ":: Installing trigger_cleanup_paccache.hook"
    #@see: https://bbs.archlinux.org/viewtopic.php?pid=1694743#p1694743
    sudo bash -c "cat > /etc/pacman.d/hooks/trigger_cleanup_paccache.hook <<DELIM
[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Keep the last cache and the currently installed.
When = PostTransaction
Exec = /usr/bin/paccache -rvk2
DELIM"
fi

if [[ ! -f /usr/bin/keepassxc ]];
then
    echo ":: Installing keepassxc"
    sudo pacman -S keepassxc
fi
