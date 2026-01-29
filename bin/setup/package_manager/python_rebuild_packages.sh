#!/bin/bash
####
# @see: https://linuxundich.de/gnu-linux/upgrade-auf-python-3-10-zeit-die-aur-pakete-neu-zu-bauen/
# @since 2021-12-14
# @author stev leibelt <artodeto@bazzline.net>
####

function _upgrade()
{
  local PACKAGEMANAGER

  PACKAGEMANAGER='';

  #begin of testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Can not install on your system."
    echo "   Sorry dude, I can only install things on a arch linux."

    return 1
  fi

  if [[ -f /usr/bin/yay ]];
  then
    PACKAGEMANAGER='yay';
  elif [[ -f /usr/bin/paru ]];
  then
    PACKAGEMANAGER='paru';
  else
    echo ":: Can not upgrade your aur python packages."
    echo "   Neither yay or paru was found."

    return 2
  fi

  if [[ ! -f /usr/bin/expac ]];
  then
    echo ":: Installing mandatory expac"
    sudo pacman -S expac
  fi

  echo ":: Fetching python aur packages to upgrade."
  # ref: https://forum.endeavouros.com/t/python-update-be-aware-to-rebuild-aur-builds-using-python/54459/6
  # comm: compares two files
  #   -1: supress column 1 (lines unique to FILE 1)
  #   -2: supress column 1 (lines unique to FILE 1)
  # (pacman -Qqm | sort):
  #   -Q: Queries database
  #   -q: Show less information
  #   -m: Filter to packages not found in the sync database
  # (expac -Q "%e %E" | grep python | awk '{print $1}' | sort)
  # expac: alpm data extraction utility
  #   -Q: Queries local database
  #   %e: Package base
  #   %E: Depends on (no version strings)
  #
  # Way simpler, maybe:
  #   pacman -S rebuild-detector
  #   checkrebuild python
  comm -12 <(pacman -Qqm | sort) <( expac -Q "%e %E" | grep python | awk '{print $1}' | sort)

  echo ""
  echo ":: Rebuilding packages."
  comm -12 <(pacman -Qqm | sort) <( expac -Q "%e %E" | grep python | awk '{print $1}' | sort) | "${PACKAGEMANAGER}" -S - --rebuild
}

_upgrade

