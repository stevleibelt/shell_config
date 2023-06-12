#!/bin/bash
####
# Setup system
####
# @since: 2023-06-12
# @author: stev leibelt <stev.leibelt@hrz.tu-freiberg.de>
####

function _main()
{
  local CURRENT_SCRIPT_PATH
  local FILE_PATH_CONFIGURATION

  CURRENT_SCRIPT_PATH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  FILE_PATH_CONFIGURATION="${HOME}/.ansible.cfg"

  if [[ ! -f "${FILE_PATH_CONFIGURATION}" ]];
  then
    echo ":: Creating >>${FILE_PATH_CONFIGURATION}<<"
    ansible-config init --disabled > "${FILE_PATH_CONFIGURATION}"
  fi

  if ! ansible-galaxy collection list | grep -q 'community.general';
  then
    # add pacman support
    echo ":: Installing >>community.general<<"
    ansible-galaxy collection install community.general
  fi

  if ! ansible-galaxy collection list | grep -q 'kewlfft.aur';
  then
    # add aur support
    echo ":: Installing >>kewlfft.aur<<"
    ansible-galaxy collection install kewlfft.aur
  fi

  echo ":: Playing >>system_setup.yml<<"
  # replace --verbose with -vvv[vvv] if you want to know more
  ansible-playbook --ask-become-pass -vvv "${CURRENT_SCRIPT_PATH}/system_setup.yml"
}

_main "${@}"
