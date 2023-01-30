#!/bin/bash
####
# Sets arc_max depending on system memory
####
# @see: https://www.cyberciti.biz/faq/how-to-set-up-zfs-arc-size-on-ubuntu-debian-linux/
# @since: 20230130
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_SYSTEM_MEMORY=$(grep MemTotal /proc/meminfo | tr -dc '[:digit:]')
  local FILE_PATH_TO_ZFS_CONF="/etc/modprobe.d/zfs_arc_max.conf"

  if [[ -f "${FILE_PATH_TO_ZFS_CONF}" ]];
  then
    echo ":: Arc size already configured."
    echo "   >>${FILE_PATH_TO_ZFS_CONF}<< exists already."
    echo "   Skipping this step."
    echo ""

    return 0
  fi

  #less or equal 4 gb
  if [[ ${CURRENT_SYSTEM_MEMORY} -le 4007516 ]];
  then
    echo "   Setting arc size to 1 GB"
    sudo bash -c "echo \"options zfs zfs_arc_max=1073741824\" > ${FILE_PATH_TO_ZFS_CONF}"
  #8 gb
  elif [[ ${CURRENT_SYSTEM_MEMORY} -eq 8015032 ]];
  then
    echo "   Setting arc size to 2 GB"
    sudo bash -c "echo \"options zfs zfs_arc_max=2147483648\" > ${FILE_PATH_TO_ZFS_CONF}"
  #16 gb
  elif [[ ${CURRENT_SYSTEM_MEMORY} -eq 16030064 ]];
  then
    echo "   Setting arc size to 4 GB"
    sudo bash -c "echo \"options zfs zfs_arc_max=4294967296\" > ${FILE_PATH_TO_ZFS_CONF}"
  else
    echo "   Setting arc size to 8 GB"
    sudo bash -c "echo \"options zfs zfs_arc_max=8589934592\" > ${FILE_PATH_TO_ZFS_CONF}"
  fi

  if [[ ${?} -eq 0 ]];
  then
    echo "   Adapted >>${FILE_PATH_TO_ZFS_CONF}<< with fitting option."
  else
    echo ":: Error"
    echo "   Could not set arc size option in >>${FILE_PATH_TO_ZFS_CONF}<<."
  fi
}

_main ${@}
