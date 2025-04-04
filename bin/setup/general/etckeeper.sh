#!/bin/bash
####
# Installs and configures etckeeper
####
# ref: https://wiki.archlinux.org/title/Etckeeper
# @since 2024-06-07
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  local CURRENT_PWD
  local GIT_EMAIL_ADDRESS
  local GIT_USER_NAME

  CURRENT_PWD=$(pwd)
  GIT_EMAIL_ADDRESS="artodeto@bazzline.net"
  GIT_USER_NAME="arto deto"

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  echo ":: Installing and configuring etckeeper if needed"

  if [[ -f /usr/bin/etckeeper ]];
  then
    echo "   Etckeeper is installed already"
  else
    sudo pacman -S etckeeper
  fi

  cd /etc || { echo "Could not cd into /etc"; exit1; }
  echo "   Configuring"
  sudo etckeeper init

  if ! sudo grep -q 'email = ' .git/config;
  then
    echo "   Setting default git user.email"
    read -p "> Please input git user.mail (default: ${GIT_EMAIL_ADDRESS}): "

    sudo git config user.email "${REPLY:-${GIT_EMAIL_ADDRESS}}"
  fi

  if ! sudo grep -q 'name = ' .git/config;
  then
    echo "   Setting default git user.name"
    read -p "> Please input git user.name (default: ${GIT_USER_NAME}): "

    sudo git config user.name "${REPLY:-${GIT_USER_NAME}}"
  fi

  # if [[ -z $... ]]; then echo "no changes detected"
  if [[ -n $(sudo git status --porcelain) ]];
  then
    # changes git change detected
    sudo etckeeper commit "initial commit"
  fi

  if sudo systemctl -q is-enabled etckeeper.timer;
  then
    echo "   Enabling and starting etckeeper.timer"
    sudo systemctl enable etckeeper.timer
    sudo systemctl start etckeeper.timer
  fi

  echo "   Done"
  cd "${CURRENT_PWD}"
}

install_if_needed

