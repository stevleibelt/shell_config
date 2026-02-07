#!/bin/bash

# @deprecated - should be put into separate script since it is not used daily anymore
function net_bazzline_zfs_create_pool()
{
  local ARRAY_OF_DEVICES
  local BE_VERBOSE
  local CURRENT_DEVICE
  local CURRENT_OPTION
  local DEVICES_AS_STRING
  local ENCRYPT
  local NAME
  local RANDOMIZED_NAME_EXTENSION
  local SHOW_HELP
  local WIPE_DEVICES

  declare -a ARRAY_OF_DEVICES=()
  BE_VERBOSE=0
  CURRENT_OPTION=""
  DEVICES_AS_STRING=""
  ENCRYPT=0
  NAME="zroot"
  OPTIND=1
  RANDOMIZED_NAME_EXTENSION=$(tr -dc a-z0-9 < /dev/urandom | head -c 4)
  SHOW_HELP=0
  WIPE_DEVICES=0

  while getopts "d:ehn:vw" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      d)
        if [[ -b "${OPTARG}" ]];
        then
          ARRAY_OF_DEVICES+=("${OPTARG}")
          DEVICES_AS_STRING="${DEVICES_AS_STRING}${OPTARG} "
        else
          echo ":: Error: >>${OPTARG}<< is not a valid device."
        fi
        ;;
      e)
        ENCRYPT=1
        ;;
      h)
        SHOW_HELP=1
        ;;
      n)
        NAME="${OPTARG}"
        ;;
      v)
        BE_VERBOSE=1
        ;;
      w)
        WIPE_DEVICES=1
        ;;
    esac
  done

  if [[ $SHOW_HELP -eq 1 ]];
  then
    echo ":: Usage"
    echo "   ${0} -d <string: /dev/disk/by-uuid/foo> [-d [...]] [-p] [-v] [-w]"
    echo "   -d: Device for the pool"
    echo "   -e: Encrypt the pool"
    echo "   -n: Name of the pool, default is >>zroot<< plus for randomized characters"
    echo "   -v: Be verbose"
    echo "   -w: Wipe data on all provided devices"

    return 0
  fi

  NAME="${NAME}-${RANDOMIZED_NAME_EXTENSION}"

  if [[ ${#ARRAY_OF_DEVICES[@]} -lt 1 ]];
  then
    echo ":: Error: No device provided"

    ls -l /dev/disk/by-id

    return 1
  fi

  if [[ ${#DEVICES_AS_STRING} -lt 1 ]];
  then
    echo ":: Error: Invalid device string"

    ls -l /dev/disk/by-id

    return 1
  fi

  if [[ ! -f /usr/bin/sgdisk ]];
  then
    net_bazzline_execute_as_super_user_when_not_beeing_root pacman -S gptfdisk
  fi

  for CURRENT_DEVICE in "${ARRAY_OF_DEVICES[@]}";
  do
    if [[ $WIPE_DEVICES -eq 1 ]];
    then
        if [[ $BE_VERBOSE -eq 1 ]];
        then
          echo ":: Start wiping device >>${CURRENT_DEVICE}<<."
        fi

        net_bazzline_execute_as_super_user_when_not_beeing_root dd if=/dev/zero of="${CURRENT_DEVICE}" bs=512 count=1
        net_bazzline_execute_as_super_user_when_not_beeing_root wipefs -af "${CURRENT_DEVICE}"
        net_bazzline_execute_as_super_user_when_not_beeing_root sgdisk -Zo "${CURRENT_DEVICE}"
    fi

    if [[ $BE_VERBOSE -eq 1 ]];
    then
      echo ":: Start partitioning device >>${CURRENT_DEVICE}<<."
    fi

    #sudo sgdisk -n1:0:0 -t1:bf01 "${CURRENT_DEVICE}"
    net_bazzline_execute_as_super_user_when_not_beeing_root sgdisk -o "${CURRENT_DEVICE}"

    # Inform kernel
    net_bazzline_execute_as_super_user_when_not_beeing_root partprobe "${CURRENT_DEVICE}"
  done

  DEVICES_AS_STRING="${DEVICES_AS_STRING:0:-1}"

  if [[ $ENCRYPT -gt 0 ]];
  then
    if [[ $BE_VERBOSE -eq 1 ]];
    then
      echo ":: Creating encrypted zfs pool"
    fi

    net_bazzline_execute_as_super_user_when_not_beeing_root zpool create -f            \
      -o ashift=12                  \
      -o autotrim=on                \
      -O acltype=posixacl           \
      -O compression=zstd           \
      -O relatime=on                \
      -O xattr=sa                   \
      -O dnodesize=legacy           \
      -O encryption=aes-256-gcm     \
      -O keyformat=passphrase       \
      -O keylocation=prompt         \
      -O normalization=formD        \
      -O mountpoint="/"             \
      -O canmount=off               \
      -O devices=off                \
      -R /                          \
      "${NAME}" "${DEVICES_AS_STRING}"
  else
    if [[ $BE_VERBOSE -eq 1 ]];
    then
      echo ":: Creating zfs pool"
    fi

    net_bazzline_execute_as_super_user_when_not_beeing_root zpool create -f            \
      -o ashift=12                  \
      -o autotrim=on                \
      -O acltype=posixacl           \
      -O compression=zstd           \
      -O relatime=on                \
      -O xattr=sa                   \
      -O dnodesize=legacy           \
      -O normalization=formD        \
      -O mountpoint="/"             \
      -O canmount=off               \
      -O devices=off                \
      -R /                          \
      "${NAME}" "${DEVICES_AS_STRING}"
  fi
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# [@param string <name of the snapshot>, default is current date
# [@param string <name of the zfs pool>]
####
function net_bazzline_create_zfs_snapshot()
{
    local NAME_OF_THE_POOL
    local NAME_OF_THE_SNAPSHOT
    local RESULT_OF_SNAPSHOT_CREATION

    NAME_OF_THE_POOL="${NET_BAZZLINE_ZFS_DEFAULT_POOL}"
    NAME_OF_THE_SNAPSHOT=$(date +'%Y-%m-%d_%H-%M-%S')

    if [[ ${#} -gt 0 ]];
    then
        NAME_OF_THE_SNAPSHOT="${1}"
    elif [[ $# -gt 1 ]]; then
        NAME_OF_THE_SNAPSHOT="${1}"
        NAME_OF_THE_POOL="${2}"
    fi

    echo ":: Trying to create snapshot >>${NAME_OF_THE_SNAPSHOT}<< for pool >>${NAME_OF_THE_POOL}<<"

    RESULT_OF_SNAPSHOT_CREATION=$(net_bazzline_execute_as_super_user_when_not_beeing_root zfs snapshot -r ${NAME_OF_THE_POOL}@${NAME_OF_THE_SNAPSHOT});

    return ${RESULT_OF_SNAPSHOT_CREATION}
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# @param string <name of the snapshot>
# @param string <name of the zfs pool>
# @todo
#   implement -q (quite) flag
#   implement -r (recurisve) flag
####
# @todo
#   * implement usage of "zfs list -t snapshot" to evaluate first if the snapshot exists or not
#   * check why -R is not working as expected
####
function net_bazzline_delete_zfs_snapshot()
{
    if [[ ${#} -lt 1 ]];
    then
        echo ":: Invalid number of arguments"
        echo ":: Usage"
        echo "   net_bazzline_delete_zfs_snapshot <name of the snapshot> [<name of the zfs pool>]"

        return 1
    fi

    local NAME_OF_THE_POOL
    local NAME_OF_THE_SNAPSHOT

    NAME_OF_THE_POOL="${2:-${NET_BAZZLINE_ZFS_DEFAULT_POOL}}"
    NAME_OF_THE_SNAPSHOT="${1}"

    if net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot | grep -q "${NAME_OF_THE_POOL}@${NAME_OF_THE_SNAPSHOT}";
    then
        if net_bazzline_core_ask_yes_or_no "Remove snapshot >>${NAME_OF_THE_POOL}@${NAME_OF_THE_SNAPSHOT}? (y|N)"
        then
          if net_bazzline_execute_as_super_user_when_not_beeing_root zfs destroy -R "${NAME_OF_THE_POOL}@${NAME_OF_THE_SNAPSHOT}"
          then
              echo ":: Snapshot \"${NAME_OF_THE_SNAPSHOT}\" deleted from pool \"${NAME_OF_THE_POOL}\""
          fi
        fi
    else
        echo ":: Failure"
        echo "   Snapshot \"${NAME_OF_THE_SNAPSHOT}\" does not exist on pool \"${NAME_OF_THE_POOL}\""
    fi
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# @param string <initial snapshot number>
# @param string <final snapshot number>
# [@param string <name of zfs pool>]
####
function net_bazzline_delete_list_of_dated_zfs_snapshots()
{
    if [[ ${#} -lt 2 ]];
    then
        echo ":: Invalid number of arguments"
        echo "   net_bazzline_delete_zfs_snapshots <name of inital snapshot number> <name of the final snapshot number> [<name of the zfs pool>]"

        return 1
    fi

    if [[ ${INITIAL_SNAPSHOT_NUMBER} -gt ${FINAL_SNAPSHOT_NUMBER} ]];
    then
        echo ":: Invalid arguments"
        echo "   ${INITIAL_SNAPSHOT_NUMBER} greater than ${FINAL_SNAPSHOT_NUMBER}"
    fi

    local ARRAY_OF_AVAILABLE_SNAPSHOTS
    local DAY
    local MONTH
    local NAME_OF_THE_POOL
    local INITIAL_SNAPSHOT_NUMBER
    local FINAL_SNAPSHOT_NUMBER
    local YEAR

    NAME_OF_THE_POOL="${3:-${NET_BAZZLINE_ZFS_DEFAULT_POOL}}"
    INITIAL_SNAPSHOT_NUMBER="${1}"
    FINAL_SNAPSHOT_NUMBER="${2}"

    echo ":: Calculating reclaimed disk space."
    #@see: https://jrs-s.net/2020/02/08/estimating-space-occupied-by-multiple-zfs-snapshots/
    net_bazzline_execute_as_super_user_when_not_beeing_root zfs destroy -nv "${NAME_OF_THE_POOL}@${INITIAL_SNAPSHOT_NUMBER}%${FINAL_SNAPSHOT_NUMBER}"

    #fetch all available snapshots into an array
    #-o name - only display the name like zfspool/dataset@my_snapshot
    #@see: https://stackoverflow.com/q/18884992
    ARRAY_OF_AVAILABLE_SNAPSHOTS=$(net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot -o name | grep -i ${NAME_OF_THE_POOL})
    #echo "Available snapshots: ${ARRAY_OF_AVAILABLE_SNAPSHOTS[@]}"

    echo ":: Deleting available snapshots."

    for CURRENT_SNAPSHOT_NUMBER in $(seq ${INITIAL_SNAPSHOT_NUMBER} 1 ${FINAL_SNAPSHOT_NUMBER});
    do
        #expected date for CURRENT_SNAPSHOT_NUMBER is yyyymmdd
        #@see http://stackoverflow.com/questions/10759162/check-if-argument-is-a-valid-date-in-bash-shell
        DAY=${CURRENT_SNAPSHOT_NUMBER:6:4}
        MONTH=${CURRENT_SNAPSHOT_NUMBER:4:2}
        YEAR=${CURRENT_SNAPSHOT_NUMBER:0:4}

        #check if the date is valid
        if date -d "${YEAR}-${MONTH}-${DAY}" &> /dev/null;
        then
            #check if snapshot exists
            #@see: https://stackoverflow.com/a/47541882
            if printf '%s\n' ${ARRAY_OF_AVAILABLE_SNAPSHOTS[@]} | grep -q -P "^${NAME_OF_THE_POOL}@${CURRENT_SNAPSHOT_NUMBER}$";
            then
                net_bazzline_delete_zfs_snapshot ${CURRENT_SNAPSHOT_NUMBER} ${NAME_OF_THE_POOL}
            fi
        fi
    done

    return $?
}

####
# Shows the reclaimable diskspace for a dataset and its used snapshots.
#
# If called with no parameters, this function iterates over all
#   available datasets
#
# [@param string of a zfs dataset name like tank1/dataset1]
# [@param ...]
####
function net_bazzline_list_zfs_snapshot_diskspace()
{
    local ARRAY_OF_DATASET_NAME
    local CURRENT_DATASET_NAME
    local FIRST_SNAPSHOT_NAME
    local LAST_SNAPSHOT_NAME
    local NUMBER_OF_AVAILABLE_SNAPSHOTS

    if [[ ${#} -lt 1 ]];
    then
        ARRAY_OF_DATASET_NAME=($(net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -Ho name))
    else
        declare -a ARRAY_OF_DATASET_NAME

        for CURRENT_DATASET_NAME in $*;
        do
            ARRAY_OF_DATASET_NAME+=(${CURRENT_DATASET_NAME})
        done
    fi

    for CURRENT_DATASET_NAME in ${ARRAY_OF_DATASET_NAME[@]};
    do
        #with >>2>/dev/null<< we are preventing the >>no datasets available<< error message
        NUMBER_OF_AVAILABLE_SNAPSHOTS=$(net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot ${CURRENT_DATASET_NAME} 2>/dev/null | wc -l)

        if [[ ${NUMBER_OF_AVAILABLE_SNAPSHOTS} -gt 0 ]];
        then
            FIRST_SNAPSHOT_NAME=$(net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot ${CURRENT_DATASET_NAME} | head -n2 | tail -n1 | cut -d " " -f1 | cut -d "@" -f2)
            LAST_SNAPSHOT_NAME=$(net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot ${CURRENT_DATASET_NAME} | tail -n1 | cut -d " " -f1 | cut -d "@" -f2)

            echo ":: Destroying >>${NUMBER_OF_AVAILABLE_SNAPSHOTS}<< snapshots on dataset >>${CURRENT_DATASET_NAME}<<."
            net_bazzline_execute_as_super_user_when_not_beeing_root zfs destroy -nvr ${CURRENT_DATASET_NAME}@${FIRST_SNAPSHOT_NAME}%${LAST_SNAPSHOT_NAME} | tail -n1
        fi
    done
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# [@param string <name of the zfs pool>]
####
function net_bazzline_list_zfs_snapshots()
{
    local NAME_OF_THE_POOL

    if [[ ${#} -lt 1 ]];
    then
        net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot
    else
        NAME_OF_THE_POOL="${1}"

        net_bazzline_execute_as_super_user_when_not_beeing_root zfs list -t snapshot | grep --color "${NAME_OF_THE_POOL}"
    fi
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# @param string <zfs pool name>
# [@param string <mount point>]
####
function net_bazzline_mount_encrypted_zfs_pool ()
{
    if [[ ${#} -gt 0 ]];
    then
        local ZFS_POOL_NAME="${1}"

        #@20201128 - unsure if this will be ever used
        if [[ ${#} -gt 1 ]];
        then
           local MOUNT_POINT="${2}"

           if [[ -d ${MOUNT_POINT} ]];
           then
              #check if directory is not empty
              if [[ $(ls -A "${MOUNT_POINT}") ]];
              then
                 echo ":: Mount point exists and is not empty."
                 echo "   >>${MOUNT_POINT}<<".

                 return 2
              else
                 echo ":: Mount point exists but is empty."
                 echo "   Removing >>${MOUNT_POINT}<<".

                 net_bazzline_execute_as_super_user_when_not_beeing_root rmdir ${MOUNT_POINT}
              fi

              net_bazzline_execute_as_super_user_when_not_beeing_root mkdir -p ${MOUNT_POINT}
           fi
        fi

        net_bazzline_execute_as_super_user_when_not_beeing_root zpool import ${ZFS_POOL_NAME}
        net_bazzline_execute_as_super_user_when_not_beeing_root zfs load-key ${ZFS_POOL_NAME}
        net_bazzline_execute_as_super_user_when_not_beeing_root zfs mount ${ZFS_POOL_NAME}
    else
        echo ":: called with invalid number of arguments."
        echo "Usage:"
        echo "    ${FUNCNAME[0]} <zfs pool name> [<mount point>]"

        return 1
    fi
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# @param string <mount point>
# @param string <zfs pool name>
####
function net_bazzline_mount_zfs_pool ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 2 ]];
    then
        local MOUNT_POINT="${1}"
        local ZFS_POOL_NAME="${2}"

        #begin of duplicated code - remove empty path if possible
        if [[ -d ${MOUNT_POINT} ]];
        then
            #check if directory is not empty
            if [[ $(ls -A "${MOUNT_POINT}") ]];
            then
                echo ":: Mount point exists and is not empty."
                echo "   ${MOUNT_POINT}"

                return 2
            else
                echo ":: Mount point exists but is empty."
                echo "   Removing ${MOUNT_POINT}"

                net_bazzline_execute_as_super_user_when_not_beeing_root rmdir ${MOUNT_POINT}
            fi
        fi
        #end of duplicated code - remove empty path if possible

        net_bazzline_execute_as_super_user_when_not_beeing_root mkdir -p ${MOUNT_POINT}

        net_bazzline_execute_as_super_user_when_not_beeing_root zpool import ${ZFS_POOL_NAME}
    else
        echo ":: called with invalid number of arguments."
        echo "Usage:"
        echo "    ${FUNCNAME[0]} <mount point> <zfs pool name>"

        return 1
    fi
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# [@param string <zfs pool name>] - If no argument is provided, the content of NET_BAZZLINE_ZFS_LIST_OF_POOLS_TO_SCRUB will be used
# [@param string <zfs pool name>]
# ...
####
function net_bazzline_scrub_list_of_zfs_pools()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ ${#} -eq 0 ]];
    then
        #@see: http://ahmed.amayem.com/bash-arrays-3-different-methods-for-copying-an-array/
        local LIST_OF_ZFS_POOLS_TO_SCRUB=(${NET_BAZZLINE_ZFS_LIST_OF_POOLS_TO_SCRUB[*]})
    else
        declare -a local LIST_OF_ZFS_POOLS_TO_SCRUB=( "${@}" )
    fi

    for ZFS_POOL_TO_SCRUB in "${LIST_OF_ZFS_POOLS_TO_SCRUB[@]}";
    do
        echo "zpool scrub ${ZFS_POOL_TO_SCRUB}"
        net_bazzline_execute_as_super_user_when_not_beeing_root zpool scrub ${ZFS_POOL_TO_SCRUB}
    done;
}

####
# @deprecated - should be put into separate script since it is not used daily anymore
# @param string <mount point>
# @param string <zfs pool name>
####
function net_bazzline_umount_zfs_pool ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ ${#} -eq 2 ]];
    then
        MOUNT_POINT="${1}"
        ZFS_POOL_NAME="${2}"

        if [[ -d ${MOUNT_POINT} ]];
        then
            if [[ "$(ls -A ${MOUNT_POINT})" ]];
            then
                CURRENT_WORKING_DIRECTORY=$(pwd)
                SUB_STRING="${CURRENT_WORKING_DIRECTORY:0:${#CURRENT_WORKING_DIRECTORY}}"

                #change to home if user is a sub directory of the mount point
                if [[ "${SUB_STRING}" == "${MOUNT_POINT}" ]];
                then
                    cd ${HOME}
                fi

                zpool export ${ZFS_POOL_NAME}

                if [[ ! "$(ls -A ${MOUNT_POINT})" ]];
                then
                    rmdir ${MOUNT_POINT}
                else
                    echo ":: can not remove mount point, there is still content inside."
                    ls -A ${MOUNT_POINT}
                fi
            else
                echo ":: mountpoint ${MOUNT_POINT} exists but is empty"
            fi
        else
            echo ":: mountpoint ${MOUNT_POINT} does not exist"
        fi
    else
        echo ":: called with invalid number of arguments."
        echo "Usage:"
        echo "    ${FUNCNAME[0]} <mount point> <zfs pool name> <uuid of device>"

        return 1
    fi
}
