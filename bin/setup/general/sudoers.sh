#!/bin/bash
####
# Installs and configures sudo
####
# ref: https://wiki.archlinux.org/title/Sudo#Configuration
# @since 2024-05-07
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  echo ":: Installing and configuring sudo if needed"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/sudo ]];
  then
    echo "   Sudo is installed already"
  else
    sudo pacman -S sudo
  fi

  echo "   Configuring sudo"

  sudo bash -c "echo 'Defaults editor=/usr/bin/vim' > /etc/sudoers.d/editor"

  sudo bash -c "echo 'Defaults rootpw' > /etc/sudoers.d/rootpw"

  if [[ -f /etc/sudoers.d/pwfeedback ]];
  then
    echo "   Removing pwfeedback"
    sudo rm /etc/sudoers.d/pwfeedback
  fi
}

install_if_needed

