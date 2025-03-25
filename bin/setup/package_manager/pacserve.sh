#!/bin/bash
####
# ref: https://xyne.dev/projects/pacserve/
# @since 2025-03-25
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_OPTION
  local FORCE
  local SHOW_HELP

  FORCE=0
  SHOW_HELP=0

  while getopts "fh" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      f)
        FORCE=1
        ;;
      h)
        SHOW_HELP=1
        ;;
      *)
        ;;
    esac
  done

  if [[ ${SHOW_HELP} -eq 1 ]];
  then
    echo ":: Usage"
    echo "${0} [-f] [-h]"
    echo ""
    echo "-f  - Force installation, even if it is installed already"
    echo "-h  - Show this help"

    return 0
  fi

  if [[ -f /usr/bin/pacserve ]];
  then
    if [[ ${FORCE} -ne 1 ]];
    then
      echo ":: pacserve is already installed."

      return 0
    fi
  fi

  #bo: testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   No /usr/bin/pacman found."

      return 1
  fi
  #eo: testing if we are on the right system

  #bo: test if base-devel is installed
  if ! pacman -Qen | grep -iq base-devel;
  then
    echo ":: Installing mandatory package base-devel"
    sudo pacman -S --needed base-devel
  fi
  #eo: test if base-devel is installed

  CURRENT_WORKING_DIRECTORY=$(pwd)

  if [[ -f /usr/bin/paru ]];
  then
    paru -S pacserve
  else
    #bo: clone source and build paru
    TEMPORARY_DIRECTORY_PATH=$(mktemp -d)
    echo "TEMPORARY_DIRECTORY_PATH: ${TEMPORARY_DIRECTORY_PATH}"
    cd "${TEMPORARY_DIRECTORY_PATH}" || { echo "Could not cd into ${TEMPORARY_DIRECTORY_PATH}"; exit 10; }

    git clone https://aur.archlinux.org/pacserve.git .
    makepkg -si

    cd "${CURRENT_WORKING_DIRECTORY}" || { echo "Could not cd into ${CURRENT_WORKING_DIRECTORY}"; exit 11; }
    rm -fr "${TEMPORARY_DIRECTORY_PATH}"
    #eo: clone source and build paru
  fi

  #bo: firewall adaptation
  if [[ -f /usr/bin/ufw ]];
  then
    sudo ufw allow 15678/tcp
    sudo ufw allow 15679/udp
  fi
  #eo: firewall adaptation

  #bo: enable service
  sudo systemctl enable pacserve.service
  sudo systemctl start pacserve.service
  #eo: enable service
}

_main "${@}"

