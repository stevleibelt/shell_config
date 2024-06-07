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

  CURRENT_PWD=$(pwd)

  echo ":: Installing and configuring etckeeper if needed"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

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
    sudo git config user.email "artodeto@bazzline.net"
  fi

  if ! sudo grep -q 'name = ' .git/config;
  then
    echo "   Setting default git user.name"
    sudo git config user.name "arto deto"
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

