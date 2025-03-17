#!/bin/bash
####
# Basic zrepl setup
####
# @see: https://wiki.archlinux.org/title/ZFS - 20230108
# @since: 20250317
# @author: stev leibelt <artodeto@bazzline.net>
####

####
# @param <string: systemctl.timer>
####
function _enable_and_start_zfs_timer_if_needed ()
{
  local SYSTEMCTL_TIMER="${1}"

  if ! sudo systemctl -q is-enabled "${SYSTEMCTL_TIMER}";
  then
    echo "   Enabling and staring >>${SYSTEMCTL_TIMER}<<."

    sudo systemctl enable "${SYSTEMCTL_TIMER}"
    sudo systemctl start "${SYSTEMCTL_TIMER}"
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
  if [[ -f "${PATH_TO_THE_ZREPL_PATH}/zrepl.yml" ]];
  then
    echo ":: Zrepl configuration exist. Nothing to do here."
    echo "   >>${PATH_TO_THE_ZREPL_PATH}/zrepl.yml<<"

    exit 0
  fi

  for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
  do
    LIST_OF_ZREPL_FILESYSTEMS+=("    \"${CURRENT_DATASET}<\":true,")
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
${LIST_OF_ZREPL_FILESYSTEMS}
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

    _enable_and_start_zfs_timer_if_needed "zrepl.service"
  fi
  #eo: zrepl
}

_main "${@}"

