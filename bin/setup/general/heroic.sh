#!/bin/bash
####
# Installs and configures heroic
####
# @see
#   https://wiki.archlinux.org/title/Gaming
#   https://wiki.archlinux.org/title/Steam#Proton_Steam-Play
# @since 2025-12-04
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
  if [[ ! -f /usr/bin/paru ]];
  then
      echo ":: Aborting."
      echo "   No /usr/bin/paru installed."

      exit 1
  fi

  paru -S heroic wine wine-gecko wine-mono proton-ge-custom-bin protontricks

}

install_if_needed

