#!/bin/bash
####
# Installs firejail
####
# @see https://wiki.archlinux.org/index.php/Firejail#Using_Firejail_by_default
# @since 2020-05-16
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
    if [[ ! -f /usr/bin/pacman ]];
    then
        echo ":: Aborting."
        echo "   No /usr/bin/pacman installed."

        exit 1
    fi

    if [[ -f /usr/bin/firejail ]];
    then
        echo ":: Firejail is installed already"
    else
        sudo pacman -S firejail
    fi

    if [[ -f /etc/pacman.d/hooks/firejail.hook ]];
    then
        local CURRENT_DATETIME=$(date +'%Y%m%d.%H%M')

        echo ":: Moving existing file to /etc/pacman.d/hooks/firejail.hook.${CURRENT_DATETIME}."
        sudo mv /etc/pacman.d/hooks/firejail.hook "/etc/pacman.d/hooks/firejail.hook.${CURRENT_DATETIME}"
    fi

    sudo bash -c "cat >/etc/pacman.d/hooks/firejail.hook<<DELIM
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/bin/*
Target = usr/local/bin/*
Target = usr/share/applications/*.desktop

[Action]
Description = Configure symlinks in /usr/local/bin based on firecfg.config...
When = PostTransaction
Depends = firejail
Exec = /bin/sh -c 'firecfg &>/dev/null'
DELIM"

    sudo firecfg
}

install_if_needed

