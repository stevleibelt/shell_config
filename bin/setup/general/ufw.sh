#!/bin/bash
####
# Setup ufw
####
# ref:
#   https://wiki.archlinux.org/title/Uncomplicated_Firewall
#   https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-20-04
# @since 2023-06-14
# @author stev leibelt <artodeto@arcor.de>
####

function _main()
{
  if [[ ! -f /usr/bin/ufw ]];
  then
    sudo pacman -S ufw
  fi

  if ! sudo systemctl is-active --quiet ufw.service;
  then
    sudo systemctl enable ufw.service
    sudo systemctl start ufw.service
  fi

  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  sudo ufw limit ssh
  #sudo ufw allow 1080/tcp
  #sudo ufw allow from 1.23.456.0/24
  #sudo ufw allow from 1.23.456.789 in on enp2s0 to any port 22

  if [[ -f /usr/bin/syncthing ]];
  then
    # ref: https://docs.syncthing.net/users/firewall.html
    sudo ufw allow syncthing
    sudo ufw allow syncthing-gui
  fi

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
