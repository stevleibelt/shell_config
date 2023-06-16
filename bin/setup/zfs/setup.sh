#!/bin/bash
####
# Basic zfs setup
####
# @todo:
#   Add zfs-autotrim timer and service
#   Add smartctl check timer
#   Add support for email on error
# @see: https://wiki.archlinux.org/title/ZFS - 20230108
# @since: 20230108
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
  local CURRENT_VERSION
  local PATH_OF_THE_CURRENT_SCRIPT
  local PATH_TO_THE_LOCAL_SETTINGS
  local PATH_TO_THE_ZREPL_PATH
  local LIST_OF_AVAILABLE_DATASETS
  local LIST_OF_AVAILABLE_ZPOOLS
  local LIST_OF_ZREPL_FILESYSTEMS

  CURRENT_VERSION=1
  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  PATH_TO_THE_LOCAL_SETTINGS="${HOME}/.local/net_bazzline/shell_config/zfs"
  PATH_TO_THE_ZREPL_PATH="/etc/zrepl"

  declare -a LIST_OF_AVAILABLE_DATASETS=( $(zfs list | cut -f 1 -d " " | tail -n +2) )
  declare -a LIST_OF_AVAILABLE_ZPOOLS=()
  declare -a LIST_OF_ZREPL_FILESYSTEMS=()
  #eo: user input

  #bo: local configuration file
  if [[ ! -d "${PATH_TO_THE_LOCAL_SETTINGS}" ]];
  then
    mkdir -p "${PATH_TO_THE_LOCAL_SETTINGS}"
  fi

  local PATH_TO_CONFIGURATION_FILE="${PATH_TO_THE_LOCAL_SETTINGS}/configuration.sh"

  if [[ -f "${PATH_TO_CONFIGURATION_FILE}" ]];
  then
    source "${PATH_TO_CONFIGURATION_FILE}"

    if [[ ${CURRENT_VERSION} -ne ${CONFIGURATION_FILE_VERSION} ]];
    then
      echo ":: Configuration file is not valid."
      echo ""
      echo "   Configuration file path >>${PATH_TO_CONFIGURATION_FILE}<<."
      echo "   Expected version >>${CURRENT_VERSION}<<, configuration file version >>${CONFIGURATION_FILE_VERSION}<<."
      echo ""

      return 1
    else
      echo ":: Configuration file exists already."
      echo "   Looks like all is done already."

      return 0
    fi
  else
    touch "${PATH_TO_CONFIGURATION_FILE}"

    echo "CONFIGURATION_FILE_VERSION=${CURRENT_VERSION}" > "${PATH_TO_CONFIGURATION_FILE}"
  fi

  echo ":: Processing available zpools and datasets."
  for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
  do
    echo "   Processing >>${CURRENT_DATASET}<<"

    #bo: general tuning
    if [[ $(zfs get -H -o value atime "${CURRENT_DATASET}") != "on" ]];
    then
      echo "     Set >>atime<< to >>off<<"
      sudo zfs set atime=off "${CURRENT_DATASET}"
    fi

    if [[ $(zfs get -H -o value compression "${CURRENT_DATASET}") == "off" ]];
    then
      echo "     Set >>compression<< to >>on<<"
      sudo zfs set compression=on "${CURRENT_DATASET}"
    fi
    #eo: general tuning

    #bo: filter out zpools
    ##zpools are datasets without an >>/<<
    if [[ ${CURRENT_DATASET} != */* ]];
    then
      LIST_OF_AVAILABLE_ZPOOLS+=("${CURRENT_DATASET}")
    fi

    LIST_OF_ZREPL_FILESYSTEMS+=("    \"${CURRENT_DATASET}<\":true,")
  done

  #bo: scrubbing timer
  echo ":: Setup available zpools"
  for CURRENT_ZPOOL in "${LIST_OF_AVAILABLE_ZPOOLS[@]}";
  do
    echo "   Processing >>${CURRENT_ZPOOL}<<."

    if [[ $(zpool get -H -o value autotrim "${CURRENT_ZPOOL}") != "on" ]];
    then
      echo "     Set >>autotrim<< to >>off<<"
      sudo zpool set autotrim=on "${CURRENT_ZPOOL}"
    fi

    _enable_and_start_zfs_timer_if_needed "zfs-scrub-weekly@${CURRENT_ZPOOL}.timer";

    #@todo create timer
    #sudo systemctl enable zfs-trim@${CURRENT_ZPOOL}.timer
  done
  #eo: scrubbing timer

  #bo: zrepl
  echo ":: Setup zrepl"
  if [[ ! -d ${PATH_TO_THE_ZREPL_PATH} ]];
  then
    sudo mkdir -p "${PATH_TO_THE_ZREPL_PATH}"
  fi

  if [[ -f "${PATH_TO_THE_ZREPL_PATH}/zrepl.yml" ]];
  then
    echo "   Zrepl configuration exist. Nothing to do here."
    echo "   >>${PATH_TO_THE_ZREPL_PATH}/zrepl.yml<<"
  else
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
  fi
  #eo: zrepl

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh" ]];
  then
    bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh"
  fi

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh" ]];
  then
    bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh"
  fi
}

_main "${@}"

