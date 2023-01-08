#!/bin/bash
####
# Basic zfs setup
#
# @see: https://wiki.archlinux.org/title/ZFS - 20230108
# @since: 20230108
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
echo ":: currently not finished wip"
return 0
  local CURRENT_VERSION=1
  local PATH_TO_THE_LOCAL_SETTINGS="${HOME}/.local/net_bazzline/shell_config/zfs"
  local PATH_TO_THE_ZREPL_PATH="/mnt/zrepl"
  declare -a LIST_OF_AVAILABLE_DATASETS=( $(zfs list | cut -f 1 -d " " | tail -n +2) )
  declare -a LIST_OF_AVAILABLE_ZPOOLS=()
  declare -a LIST_OF_ZREPL_FILESYSTEMS=()

  if [[ ! -d "${PATH_TO_THE_LOCAL_SETTINGS}" ]];
  then
    mkdir -p "${PATH_TO_THE_LOCAL_SETTINGS}"
  fi

  #@todo implement configuration below zfs
  ##line1: version
  ##line2: ...

  echo ":: Processing available zpools and datasets."
  for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
  do
    echo "   Processing >>${CURRENT_DATASET}<<"
    #bo: general tuning
    #sudo zfs set atime=off "${CURRENT_DATASET}"
    #sudo zfs set compression=on "${CURRENT_DATASET}"
    #eo: general tuning

    #bo: filter out zpools
    ##zpools are datasets without an >>/<<
    if [[ ${CURRENT_DATASET} != */* ]];
    then
      LIST_OF_AVAILABLE_ZPOOLS+=(${CURRENT_DATASET})
    fi

    LIST_OF_ZREPL_FILESYSTEMS+=("    \"${CURRENT_DATASET}<\":true,")
  done

  #bo: scrubbing timer

  echo ":: Setup available zpools"
  for CURRENT_ZPOOL in "${LIST_OF_AVAILABLE_ZPOOLS[@]}";
  do
    echo "   Processing >>${CURRENT_ZPOOL}<<."
    #sudo systemctl enable zfs-scrub-weekly@${CURRENT_ZPOOL}.timer
    #sudo systemctl start zfs-scrub-weekly@${CURRENT_ZPOOL}.timer

    #zpool set autotrim=on "${CURRENT_ZPOOL}"
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

  zrepl configcheck --config ${PATH_TO_THE_ZREPL_PATH}/zrepl.yml

  if [[ ${?} -ne 0 ]];
  then
    echo ":: Error"
    echo "   Created zrepl configuration yaml >>${PATH_TO_THE_ZREPL_PATH}/zrepl.yml<< is not valid."

    #sudo systemctl enable zrepl.service
    #sudo systemctl start zrepl.service
  fi
  #eo: zrepl
}

_main ${@}
