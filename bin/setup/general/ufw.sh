#!/bin/bash
####
# Setup ufw
####
# ref: https://wiki.archlinux.org/title/Uncomplicated_Firewall
# @since 2023-06-14
# @author stev leibelt <artodeto@arcor.de>
####

function _main() {
  if [[ ! -f /usr/bin/ufw ]];
  then
    sudo pacman -S ufw
  fi

  if ! sudo systemctl is-active ufw.service;
  then
    sudo systemctl enable ufw.service
    sudo systemctl start ufw.service
  fi

  sudo ufw default deny
  sudo ufw limit ssh

  if ! sudo ufw status | grep -q 'Status: active';
  then
    sudo ufw enable
  fi

  if ! sudo ufw status | grep -q 'Status: active';
  then
    echo ":: Error, could not enable ufw"
    echo "   Try: sudo ufw enable"
  fi
}

_main "${@}"
