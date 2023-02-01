#!/bin/bash
####
# @see: https://aur.archlinux.org/yay.git
# @since 2018-07-22
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  if [[ -f /usr/bin/yay ]];
  then
    echo ":: Yay is already installed."

    return 0
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
  #git clone https://aur.archlinux.org/yay.git .
  git clone https://aur.archlinux.org/yay-bin.git .
  makepkg -si
  ##end of building and installing

  ##begin of clean up
  cd ${CURRENT_WORKING_DIRECTORY}
  rm -fr {TEMPORARY_DIRECTORY_PATH}
  ##end of clean up
}

_main ${@}

