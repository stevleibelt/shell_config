#!/bin/bash
####
# Manage installation of virtual box
####
# @see
#   https://wiki.archlinux.org/title/VirtualBox
# @since 2025-12-17
# @author stev leibelt <artodeto@arcor.de>
####

function _main() {
  local PACKAGE_MANAGER
  local OPERATION
  
  if [[ -f /usr/bin/virtualbox ]];
  then
    OPERATION="R"
  else
    OPERATION="S"
  fi

  if [[ -f /usr/bin/pacman ]];
  then
    if whoami | grep -q 'root';
    then
      PACKAGE_MANAGER="pacman"
    else
      PACKAGE_MANAGER="sudo pacman"
    fi
  elif [[ -f /usr/bin/yay ]];
  then
    PACKAGE_MANAGER="yay"
  elif [[ -f /usr/bin/paru ]];
  then
    PACKAGE_MANAGER="paru"
  else
    echo ":: Aborting."
    echo "   Neither /usr/bin/pacman, /usr/bin/yay nor /usr/bin/paru found."

    exit 1
  fi

  if uname -r | grep -q '\-lts';
  then
    ${PACKAGE_MANAGER} -${OPERATION} virtualbox virtualbox-host-modules-lts
  else
    ${PACKAGE_MANAGER} -${OPERATION} virtualbox virtualbox-host-modules-arch
  fi
}

_main "${@}"

