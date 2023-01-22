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
  cp /etc/bash.bashrc ~/.bashrc

  mkdir -p ~/document ~/media/{audio,book,image,video} ~/network/net.bazzline.cloud ~/software/source/com/github/stevleibelt ~/temporary/download

  localeectl set-x11-keymap de

  #stage2
  bash "${PATH_TO_THIS_SCRIPT}/install_packages.sh"

  #stage3
  cd ~/software/source/com/github/stevleibelt
  git clone https://github.com/stevleibelt/shell_config
  git clone https://github.com/stevleibelt/settings
  git clone https://github.com/stevleibelt/general_howtos
  git clone https://github.com/stevleibelt/examples

  bash shell_config/bin/install.sh
  bash shell_config/bin/configure_local_settings.sh
  vimdiff shell_config/setting shell_config/local.setting

  bash settings/i3/install.sh
  bash settings/i3status/install.sh
  bash settings/screen/install.sh
  bash settings/vim/install.sh
  bash settings/xdg/install.sh

  git config --global init.defaultBranch main
  git config --global user.name "Stev Leibelt"
  git config --global user.email "artodeto@bazzline.net"

  cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
