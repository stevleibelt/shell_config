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
  local CURRENT_DATASET
  local PATH_OF_THE_CURRENT_SCRIPT
  local LIST_OF_AVAILABLE_DATASETS
  local LIST_OF_AVAILABLE_ZPOOLS

  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

  declare -a LIST_OF_AVAILABLE_DATASETS=( $(zfs list | cut -f 1 -d " " | tail -n +2) )
  declare -a LIST_OF_AVAILABLE_ZPOOLS=()
  #eo: user input

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

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh" ]];
  then
    bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh"
  fi

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh" ]];
  then
    bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh"
  fi

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/zrepl.sh" ]];
  then
    bash "${PATH_OF_THE_CURRENT_SCRIPT}/zrepl.sh"
  fi
}

_main "${@}"

