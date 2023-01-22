#!/bin/bash
####
# Create an environment artodeto can work with
####

function _main () {

  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
  local CURRENT_WORKING_DIRECTORY=$(pwd)

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Sorry, we need pacman to work."

    return 1
  fi

  #stage 1
  echo ":: Creating basic environment."
  
  if [[ ! -f ~/.bashrc ]];
  then
    cp /etc/bash.bashrc ~/.bashrc
  fi

  mkdir -p ~/document ~/media/{audio,book,image,video} ~/network/net.bazzline.cloud ~/software/source/com/github/stevleibelt ~/temporary/download

  localectl set-x11-keymap de

  #stage2
  echo ":: Installing mandatory software."
  bash "${PATH_TO_THIS_SCRIPT}/install_packages.sh"

  #stage3
  echo ":: Adding github stored knowledge and settings."
  cd ~/software/source/com/github/stevleibelt

  if [[ ! -d shell_config ]];
  then
    git clone https://github.com/stevleibelt/shell_config

    bash shell_config/bin/install.sh
    bash shell_config/bin/configure_local_settings.sh
    vimdiff shell_config/setting shell_config/local.setting
  else
    cd shell_config
    git pull
    cd ..
  fi
  if [[ ! -d settings ]];
  then
    git clone https://github.com/stevleibelt/settings
  else
    cd settings
    git pull
    cd ..
  fi
  if [[ ! -d general_howtos ]];
  then
    git clone https://github.com/stevleibelt/general_howtos
  else
    cd general_howtos
    git pull
    cd ..
  fi
  if [[ ! -d examples ]];
  then
    git clone https://github.com/stevleibelt/examples
  else
    cd examples
    git pull
    cd ..
  fi

  bash settings/i3/install.sh
  bash settings/i3status/install.sh
  bash settings/screen/install.sh
  bash settings/vim/install.sh
  bash settings/xdg/install.sh

  git config --global init.defaultBranch main
  git config --global user.name "stevleibelt"
  git config --global user.email "artodeto@bazzline.net"

  cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
