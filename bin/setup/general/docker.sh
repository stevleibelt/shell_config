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
    sudo mv -v /etc/docker/daemon.json "/etc/docker/daemon.json.${CURRENT_DATE_TIME}"
  fi

  sudo systemctl stop docker.socket

  if [[ -f /usr/bin/zfs ]];
  then
    # ref: https://docs.docker.com/storage/storagedriver/zfs-driver/
    if [[ ! -d /var/lib/docker.overlay2 ]];
    then
      sudo cp -au /var/lib/docker /var/lib/docker.overlay2
    fi
    sudo rm -rf /var/lib/docker/*

    if sudo zfs list | grep -q zroot/data/docker;
    then
      DEFAULT_DATA_SET="zroot/data/docker"
      read -e -i "${DEFAULT_DATA_SET}" -p ":: Please adapt zfs data set for docker: " DATA_SET
      DATA_SET="${DATA_SET:-$DEFAULT_DATA_SET}"
      echo "   Creating zfs data set >>${DATA_SET}<<"
      sudo zfs create -o mountpoint=/var/lib/docker "${DATA_SET}"
    fi

    echo "   Creating daemon.json with zfs storage driver"
    sudo bash -c 'cat > /etc/docker/daemon.json <<DELIM
{
  "storage-driver": "zfs",
  "live-restore": true,
  "log-driver": "syslog",
  "userland-proxy": false
}
DELIM'
  else
    echo "   Creating daemon.json"
    sudo bash -c 'cat > /etc/docker/daemon.json <<DELIM
{
  "live-restore": true,
  "log-driver": "syslog",
  "userland-proxy": false
}
DELIM'
  fi

  if ! sudo systemctl is-active --quiet docker.socket;
  then
    sudo systemctl enable docker.socket
    sudo systemctl start docker.socket
  fi
}

_main "${@}"
