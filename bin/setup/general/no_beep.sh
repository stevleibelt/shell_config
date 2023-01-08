#!/bin/bash
####
# @see
#   https://wiki.archlinux.org/index.php/PC_speaker#Disable_PC_Speaker
####
# @since 2019-05-31
# @author stev leibelt <artodeto@bazzline.net>
####

if [[  -f /etc/modprobe.d/nobeeb.conf ]];
then
    echo ":: File >>/etc/modeprobe.conf/nobeeb.conf<< exists already!"
else
    sudo bash -c "cat > /etc/modprobe.d/nobeeb.conf <<DELIM
#@see: https://wiki.archlinux.org/index.php/PC_speaker#Disable_PC_Speaker
blacklist pcspkr
DELIM"

    echo ":: File >>/etc/modeprobe.conf/nobeeb.conf<< created."
fi

