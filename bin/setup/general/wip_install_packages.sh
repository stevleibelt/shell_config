#!/bin/bash
####
# 
####
# @since: 2023-06-10
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main()
{
  local INSTALL_ARCHLINUX_PACKAGES
  local INSTALL_AUR_PACKAGES
  local PATH_OF_THE_CALLED_SCRIPT

  INSTALL_ARCHLINUX_PACKAGES=0
  INSTALL_AUR_PACKAGES=1
  PATH_OF_THE_CALLED_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ${INSTALL_ARCHLINUX_PACKAGES} -gt 0 ]];
  then
    "./${PATH_OF_THE_CALLED_SCRIPT}/../package_manager/package.d/update_system_from_package_list.sh" "${PATH_OF_THE_CALLED_SCRIPT}/../package_manager/package.d/list_of_archlinux_packages.txt"
    rustup default stable
    sudo enable autorandr-lid-listener.service
    sudo enable autorandr.service
    sudo start autorandr-lid-listener.service
    sudo start autorandr.service
  fi

  if [[ ${INSTALL_AUR_PACKAGES} -gt 0 ]];
  then
    "./${PATH_OF_THE_CALLED_SCRIPT}/../package_manager/package.d/update_system_from_package_list.sh" "${PATH_OF_THE_CALLED_SCRIPT}/../package_manager/package.d/list_of_aur_packages.txt"
  fi
}

_main "${@}"
