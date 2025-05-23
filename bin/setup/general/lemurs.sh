#!/bin/bash
####
# Installs and configures lemurs
#   lemurs solves an unknown issue in rustdesk
#   If I just use xinit, I can not serve rustdesk sessions
#   >>Unsupported display server tty, x11 expected<<
####
# ref: https://github.com/coastalwhite/lemurs
# @since 2025-04-22
# @author stev leibelt <artodeto@arcor.de>
####

function _install_if_needed()
{
  local PACKAGE

  PACKAGE="lemurs"

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      return 10
  fi

  if [[ -f /usr/bin/${PACKAGE} ]];
  then
    echo "   ${PACKAGE} is installed already"
  else
    echo ":: Installing ${PACKAGE}"
    sudo pacman -S ${PACKAGE}
  fi

  echo ":: Configuring ${PACKAGE} if needed"

  sudo systemctl disable display-manager.service
  sudo systemctl enable ${PACKAGE}.service
}

_install_if_needed "${@}"

