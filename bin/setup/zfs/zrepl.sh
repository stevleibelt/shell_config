#!/bin/bash
####
# Basic zrepl setup
####
# @see: https://wiki.archlinux.org/title/ZFS - 20230108
# @since: 20250317
# @author: stev leibelt <artodeto@bazzline.net>
####

####
# @param <string: systemctl.service>
####
function _enable_and_start_zfs_service_if_needed ()
{
  local SYSTEMCTL_SERVICE="${1}"

  if ! sudo systemctl -q is-enabled "${SYSTEMCTL_SERVICE}";
  then
    echo "   Enabling and staring >>${SYSTEMCTL_SERVICE}<<."

    sudo systemctl enable "${SYSTEMCTL_SERVICE}"
    sudo systemctl start "${SYSTEMCTL_SERVICE}"
  fi
}

function _main ()
{
  #bo: user input
  local PATH_OF_THE_CURRENT_SCRIPT
  local PATH_TO_THE_ZREPL_PATH
  local LIST_OF_AVAILABLE_DATASETS
  local LIST_OF_ZREPL_FILESYSTEMS

  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  PATH_TO_THE_ZREPL_PATH="/etc/zrepl"

  declare -a LIST_OF_AVAILABLE_DATASETS=( $(zfs list | cut -f 1 -d " " | tail -n +2) )
  declare -a LIST_OF_ZREPL_FILESYSTEMS=()
  #eo: user input

  #bo: zrepl
  if [[ ! -f /usr/bin/zrepl ]];
  then
    echo ":: Zrepl not found"

    if [[ -f /usr/bin/paru ]];
    then
      paru -S zrepl-bin
    elif [[ -f /usr/bin/yay ]];
    then
      yay -S zrepl-bin
    else
      echo "   Can not detect your aur install helper."
      echo "   Please install it first from aur"
    fi
  fi

  if [[ -f "${PATH_TO_THE_ZREPL_PATH}/zrepl.yml" ]];
  then
    echo ":: Zrepl configuration exist. Nothing to do here."
    echo "   >>${PATH_TO_THE_ZREPL_PATH}/zrepl.yml<<"

    exit 0
  fi

  for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
  do
    if [[ ! "${CURRENT_DATASET}" == *"varcache"* && ! "${CURRENT_DATASET}" == *"varlog"* ]];
    then
      LIST_OF_ZREPL_FILESYSTEMS+=("    \"${CURRENT_DATASET}<\":true,")
    fi
  done

  echo ":: Setup zrepl"
  if [[ ! -d ${PATH_TO_THE_ZREPL_PATH} ]];
  then
    sudo mkdir -p "${PATH_TO_THE_ZREPL_PATH}"
  fi

  sudo bash -c "cat > ${PATH_TO_THE_ZREPL_PATH}/zrepl.yml <<DELIM
jobs:
- name: net_bazzline_snapjob
  type: snap
  filesystems: {
DELIM"

for ZREPL_FILESYSTEM in "${LIST_OF_ZREPL_FILESYSTEMS[@]}";
do
  sudo bash -c "echo '${ZREPL_FILESYSTEM}' >> ${PATH_TO_THE_ZREPL_PATH}/zrepl.yml"
done

sudo bash -c "cat >> ${PATH_TO_THE_ZREPL_PATH}/zrepl.yml <<DELIM
  }
  snapshotting:
    type: periodic
    interval: 24h
    prefix: zrepl_net_bazzline_snapjob_
  pruning:
    keep:
      - type: last_n
        count: 21
DELIM"

  if ! zrepl configcheck --config ${PATH_TO_THE_ZREPL_PATH}/zrepl.yml;
  then
    echo ":: Error"
    echo "   Created zrepl configuration yaml >>${PATH_TO_THE_ZREPL_PATH}/zrepl.yml<< is not valid."

    _enable_and_start_zfs_service_if_needed "zrepl.service"
  fi
  #eo: zrepl
}

_main "${@}"

