#!/bin/bash
####
# Switch your pure arch to cachy
####
# @ref: https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install
# @since 2026-03-09
# @author stev leibelt <artodeto@arcor.de>
####

# Stop script execution after failing command execution
set -e

function install_if_needed()
{
  local CURRENT_OPTION
  local SHOW_HELP
  local TEMPORARY_DIRECTORY
  local UNINSTALL

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 10
  fi

  SHOW_HELP=0
  UNINSTALL=0

  while getopts "hiu" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      h)
        SHOW_HELP=1
        ;;
      u)
        UNINSTALL=1
        ;;
      *)
        ;;
    esac
  done

  if [[ ${SHOW_HELP} -eq 1 ]];
  then
    echo ":: Usage"
    echo "${0} [-h] [-u]"
    echo ""
    echo "-h  - Show this help"
    echo "-u  - Uninstall cachyos repositories (default is install)"

    return 0
  fi

  # ref: https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install
  TEMPORARY_DIRECTORY=$(mktemp -d)

  cd "${TEMPORARY_DIRECTORY}"
  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz && cd cachyos-repo

  if [[ ${UNINSTALL} -eq 1 ]];
  then
    sudo ./cachyos-repo.sh --remove
  else
    sudo ./cachyos-repo.sh
  fi

  cd -
  sudo rm -fr "${TEMPORARY_DIRECTORY}"
}

install_if_needed "${@}"

