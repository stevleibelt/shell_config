#!/bin/bash
####
# @see: https://wiki.archlinux.org/index.php/Reflector
# @since 2018-02-01
# @author stev leibelt <artodeto@bazzline.net>
####

##begin of installation
sudo pacman -S reflector
##end of installation

##begin of setup
echo ":: Please insert one of the following listed country names."
echo ""
cat /etc/pacman.d/mirrorlist | grep '## ' | tr '#' ' ' | sort | uniq | grep -v 'Arch\|Filtered\|Generated'
read COUNTRY_NAME

echo ":: Please insert the maximum number of used servers."
echo "   A good value is something between 50 and 200."
read MAXIMUM_NUBERS_OF_SERVERS_TO_USE

if [[ ! - d /etc/pacman.d/hooks ]];
then
    sudo /usr/bin/mkdir -p /etc/pacman.d/hooks
fi

sudo cat > /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook <<DELIM
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /usr/bin/bash -c "reflector --country '$(echo ${COUNTRY_NAME})' -l $(echo ${MAXIMUM_NUBERS_OF_SERVERS_TO_USE}) --sort rate --save /etc/pacman.d/mirrorlist && [[ -f /etc/pacman.d/mirrorlist.pacnew ]] && rm /etc/pacman.d/mirrorlist.pacnew"
DELIM
##end of setup
