#!/bin/bash
####
# Setup docker
####
# @since 2023-06-19
# @author stev leibelt <artodeto@arcor.de>
####

function _main()
{
  local CURRENT_DATE_TIME

  if [[ ! -f /usr/bin/docker ]];
  then
    sudo pacman -S docker
  fi

  if [[ ! -f /usr/bin/docker-compose ]];
  then
    sudo pacman -S docker-compose
  fi

  if [[ ! -d /etc/docker ]];
  then
    sudo mkdir /etc/docker
  elif [[ -f /etc/docker/daemon.json ]];
  then
    echo ":: Moving >>/etc/docker/daemon.json<< to /etc/d"
    mv -v /etc/docker/daemon.json "/etc/docker/daemon.json.${CURRENT_DATE_TIME}"
  fi

  sudo bash -c 'cat > /etc/docker/daemon.json <<DELIM
{
  "live-restore": true
  "log-driver": "syslog",
  "userland-proxy": false
}
DELIM'

  if ! sudo systemctl is-active docker.socket;
  then
    sudo systemctl enable docker.socket
    sudo systemctl start docker.socket
  fi
}

_main "${@}"
