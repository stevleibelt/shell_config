#!/bin/bash
####
# ref: https://github.com/morganamilo/paru
# @since 2025-03-04
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_OPTION
  local FORCE
  local RUSTUP_SCRIPT_PATH
  local SHOW_HELP
  local THIS_SCRIPT_PATH

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

  if [[ -f /usr/bin/paru ]];
  then
    if [[ ${FORCE} -ne 1 ]];
    then
      echo ":: Paru is already installed."

      return 0
    fi
  fi

  #bo: testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   No /usr/bin/pacman found."

      return 10
  fi
  #eo: testing if we are on the right system

  #bo: test if base-devel is installed
  if ! pacman -Qen | grep -iq base-devel;
  then
    echo ":: Installing mandatory package base-devel"
    sudo pacman -S --needed base-devel
  fi
  #eo: test if base-devel is installed

  THIS_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  RUSTUP_SCRIPT_PATH="${THIS_SCRIPT_PATH}/../general/rustup.sh"

  if [[ ! -f "${RUSTUP_SCRIPT_PATH}" ]];
  then
      echo ":: Can not install on your system."
      echo "   No ${RUSTUP_SCRIPT_PATH} found."

      return 11
  fi

  bash "${RUSTUP_SCRIPT_PATH}"

  CURRENT_WORKING_DIRECTORY=$(pwd)

  #bo: clone source and build paru
  TEMPORARY_DIRECTORY_PATH=$(mktemp -d)
  echo "TEMPORARY_DIRECTORY_PATH: ${TEMPORARY_DIRECTORY_PATH}"
  cd "${TEMPORARY_DIRECTORY_PATH}" || { echo "Could not cd into ${TEMPORARY_DIRECTORY_PATH}"; exit 10; }

  git clone https://aur.archlinux.org/paru.git .
  makepkg -si

  cd "${CURRENT_WORKING_DIRECTORY}" || { echo "Could not cd into ${CURRENT_WORKING_DIRECTORY}"; exit 11; }
  rm -fr "${TEMPORARY_DIRECTORY_PATH}"
  #eo: clone source and build paru
}

_main "${@}"

