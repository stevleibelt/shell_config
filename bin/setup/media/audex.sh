#!/bin/bash
####
# Installs and configures audex
####
# ref: https://apps.kde.org/audex/
# @since 2025-07-20
# @author stev leibelt <artodeto@arcor.de>
####

function _install_if_needed()
{
  local PACKAGE

  PACKAGE="audex"

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      return 10
  fi

  if [[ ! -f /usr/bin/${PACKAGE} ]];
  then
    sudo pacman -S ${PACKAGE} lame ffmpeg
  fi
}

_install_if_needed "${@}"

