#!/bin/bash
####
# @see: https://wiki.archlinux.org/index.php/Reflector
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

##begin of test
if [[ -f /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook ]];
then
    echo ":: Reflector already configured."
    echo ""
    echo ":: Do you want to remove the configuration file? (y|n)"
    read YES_OR_NO

    if [[ ${YES_OR_NO} == "y" ]];
    then
        sudo rm /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook
    else
        echo "   If you want to rerun this script, remove following file:"
        echo "   /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook"

        exit 1
    fi
fi
##end of test

##begin of installation
#@todo only install if not installed
if [[ ! -f /usr/bin/reflector ]];
then
    echo ":: Installing reflector"
    sudo pacman -S reflector --noconfirm
fi
##end of installation

##begin of setup
echo ":: Please insert one of the following listed country names."
echo ""
cat /etc/pacman.d/mirrorlist | grep '## ' | tr '#' ' ' | sort | uniq | grep -v 'Arch\|Filtered\|Generated'
read COUNTRY_NAME

echo ":: Please insert the maximum number of used servers."
echo "   A good value is something between 50 and 200."
read MAXIMUM_NUBERS_OF_SERVERS_TO_USE

if [[ ! -d /etc/pacman.d/hooks ]];
then
    sudo /usr/bin/env mkdir -p /etc/pacman.d/hooks
fi

sudo touch /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook

sudo bash -c "cat > /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook <<DELIM
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /usr/bin/bash -c \"reflector --country '$(echo ${COUNTRY_NAME})' -l $(echo ${MAXIMUM_NUBERS_OF_SERVERS_TO_USE}) --sort rate --save /etc/pacman.d/mirrorlist && [[ -f /etc/pacman.d/mirrorlist.pacnew ]] && rm /etc/pacman.d/mirrorlist.pacnew\"
DELIM"
##end of setup
