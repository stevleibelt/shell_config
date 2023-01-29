#!/bin/bash
####
# Create an environment artodeto can work with
####

####
# @param <string: current_step_journal_file_name>
# @param <int: current_step_version>
####
function _step_was_not_done ()
{
  #@todo
  #think about a logic  add a kind of migration from version 1 to 2
  # maybe have two functions? one for "step configuration exists" and "fetch version"
  # cat journal file | grep current_step_journal_file_name:current_step_version

  return 0
}

function _main () 
{
  local CURRENT_WORKING_DIRECTORY=$(pwd)
  local FILE_PATH_TO_THE_INSTALLATION_JOURNAL="${HOME}/.config/net_bazzline/setup/journal.txt"
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

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

  bash "${PATH_TO_THIS_SCRIPT}/slock_on_suspend.sh"

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

  git config --global core.editor vim
  git config --global init.defaultBranch main
  git config --global user.name "stevleibelt"
  git config --global user.email "artodeto@bazzline.net"

  cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
