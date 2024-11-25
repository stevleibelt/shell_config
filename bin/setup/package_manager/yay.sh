#!/bin/bash
####
# @see: https://aur.archlinux.org/yay.git
# @since 2018-07-22
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_OPTION
  local ENABLE_PACCACHE
  local FORCE
  local SHOW_HELP
  local USE_SOURCE

  ENABLE_PACCACHE=0
  FORCE=0
  SHOW_HELP=0
  USE_SOURCE=0

  while getopts "fhs" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      f)
        FORCE=1
        ;;
      h)
        SHOW_HELP=1
        ;;
      p)
        ENABLE_PACCACHE=1
        ;;
      s)
        USE_SOURCE=1
        ;;
    esac
  done

  if [[ ${SHOW_HELP} -eq 1 ]];
  then
    echo ":: Usage"
    echo "${0} [-f] [-h] [-s]"
    echo ""
    echo "-f  - Force installation, even if it is installed already"
    echo "-h  - Show this help"
    echo "-p  - Enable Paccache"
    echo "-s  - Use yay.git instead of yay-bin.git"

    return 0
  fi

  if [[ ${ENABLE_PACCACHE} -eq 1 ]];
  then
    echo ":: Enabling paccache.timer"

    sudo systemctl enable paccache.timer
    sudo systemctl start paccache.timer
  fi

  if [[ -f /usr/bin/yay ]];
  then
    if [[ ${FORCE} -ne 1 ]];
    then
      echo ":: Yay is already installed."

      return 0
    fi
  fi

  #begin of testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   Sorry dude, I can only install things on a arch linux."

      return 1
  fi

  sudo pacman -Syy
  #end of testing if we are on the right system

  if [[ ! -f /usr/bin/git ]];
  then
      echo ":: Please install git."
      
      return 2
  fi

  if [[ ! -f /usr/bin/pactree ]];
  then
      echo ":: Pactree is missing but mandatory."
      echo ":: Installing pactre."

      sudo pacman -S --noconfirm --needed pacman-contrib
  fi

  if [[ ! -f /usr/bin/gcc ]];
  then
      echo ":: base-devel (at least gcc) is missing but mandatory."
      echo ":: Installing group base-devel."

      return pacman -S --noconfirm --needed base-devel
  fi

  CURRENT_WORKING_DIRECTORY=$(pwd)

  ##begin of temporary path creation
  TEMPORARY_DIRECTORY_PATH=$(mktemp -d)
  cd ${TEMPORARY_DIRECTORY_PATH}
  ##begin of temporary path creation

  ##begin of building and installing
  cd ${TEMPORARY_DIRECTORY_PATH}
  if [[ ${USE_SOURCE} -eq 1 ]];
  then
    git clone https://aur.archlinux.org/yay.git .
  else
    git clone https://aur.archlinux.org/yay-bin.git .
  fi
  makepkg -si
  ##end of building and installing

  ##begin of clean up
  cd ${CURRENT_WORKING_DIRECTORY}
  rm -fr {TEMPORARY_DIRECTORY_PATH}
  ##end of clean up
}

_main ${@}

