#!/bin/bash
####
# Installs and configures syncthing
####
# @ref https://wiki.archlinux.org/title/Syncthing
# @since 2026-02-05
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  echo ":: Installing and configuring syncthing if needed"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/syncthing ]];
  then
    echo "   Syncthing is installed already"
  else
    sudo pacman -S syncthing
  fi

  #bo: firewall adaptation
  if [[ -f /usr/bin/ufw ]];
  then
    sudo ufw allow syncthing
  fi
  #eo: firewall adaptation

  systemctl enable syncthing.service --user
  systemctl start syncthing.service --user
}

install_if_needed

