#!/bin/bash
####
# @since 2025-03-24
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  #bo: testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   No /usr/bin/pacman found."

      return 1
  fi
  #eo: testing if we are on the right system

  #bo: test rustup toolchain set
  if ! pacman -Qen | grep -iq rustup;
  then
    echo ":: Installing mandatory package rustup"
    sudo pacman -S --needed rustup
  fi

  if rustup show | grep -q 'no active toolchain';
  then
    echo ":: No default rustup toolchain set"
    echo "   Set toolchain default to stable"
    rustup default stable
  fi

  rustup update
  #eo: test rustup toolchain set
}

_main "${@}"

