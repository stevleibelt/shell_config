#!/bin/bash
####
# Installs and configures pipewire
####
# @see
#   https://wiki.archlinux.org/title/Bluetooth
# @since 2026-03-03
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
  local PACKAGE_MANAGER

  PACKAGE_MANAGER="pacman"

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Aborting."
    echo "   No /usr/bin/pacman installed."

    exit 1
  fi

  if [[ -f /usr/bin/paru ]];
  then
    PACKAGE_MANAGER="paru"
  fi

  if ! (systemctl list-units | grep -q bluetooth.service)
  then
    echo ":: Aborting."
    echo "   No bluetooth.service available"
  fi

  if ! (pacman -Ss bluez | grep -i inst | grep -q extra/bluez)
  then
    ${PACKAGE_MANAGER} -S bluez bluetui
  fi

  if ! (pacman -Ss bluetui | grep -q extra/bluetui)
  then
    ${PACKAGE_MANAGER} -S bluetui
  fi

  echo ":: HowTo"
  echo "   sudo systemctl start bluetooth.service"
  echo "   bluetui"
}

install_if_needed

