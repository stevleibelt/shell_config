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
  local CURRENT_SYSTEM_MEMORY
  local FILE_PATH_TO_ZFS_CONF

  CURRENT_SYSTEM_MEMORY=$(grep MemTotal /proc/meminfo | tr -dc '[:digit:]')
  FILE_PATH_TO_ZFS_CONF="/etc/modprobe.d/zfs_arc_max_and_min.conf"
  OLD_FILE_PATH_TO_ZFS_CONF="/etc/modprobe.d/zfs_arc_max.conf"

  if [[ -f "${OLD_FILE_PATH_TO_ZFS_CONF}" ]];
  then
    echo ":: Removing old configuration file."
    sudo rm "${OLD_FILE_PATH_TO_ZFS_CONF}"
    echo ""
  fi

  if [[ -f "${FILE_PATH_TO_ZFS_CONF}" ]];
  then
    echo ":: Removing current configuration file."
    sudo rm "${FILE_PATH_TO_ZFS_CONF}"
    echo ""
  fi

  #less or equal 4 gb
  if [[ ${CURRENT_SYSTEM_MEMORY} -le 4194304 ]];
  then
    echo "   Less or exact than 4 GB of memory, setting arc size to 256 MB"
    sudo bash -c "echo \"options zfs zfs_arc_min=131072\" > ${FILE_PATH_TO_ZFS_CONF}"
    sudo bash -c "echo \"options zfs zfs_arc_max=262144\" >> ${FILE_PATH_TO_ZFS_CONF}"
  #8 gb
  elif [[ ${CURRENT_SYSTEM_MEMORY} -le 8388608 ]];
  then
    echo "   Less or exact than 8 GB of memory, setting arc size to 512 MB"
    sudo bash -c "echo \"options zfs zfs_arc_min=262144\" > ${FILE_PATH_TO_ZFS_CONF}"
    sudo bash -c "echo \"options zfs zfs_arc_max=524288\" >> ${FILE_PATH_TO_ZFS_CONF}"
  #16 gb
  elif [[ ${CURRENT_SYSTEM_MEMORY} -le 16777216 ]];
  then
    echo "   Less or exact than 16 GB of memory, setting arc size to 1 GB"
    sudo bash -c "echo \"options zfs zfs_arc_min=524288\" > ${FILE_PATH_TO_ZFS_CONF}"
    sudo bash -c "echo \"options zfs zfs_arc_max=1048576\" >> ${FILE_PATH_TO_ZFS_CONF}"
  elif [[ ${CURRENT_SYSTEM_MEMORY} -le 33554432 ]];
  then
    echo "   Less or exact than 32 GB of memory, setting arc size to 2 GB"
    sudo bash -c "echo \"options zfs zfs_arc_min=1048576\" > ${FILE_PATH_TO_ZFS_CONF}"
    sudo bash -c "echo \"options zfs zfs_arc_max=2097152\" >> ${FILE_PATH_TO_ZFS_CONF}"
  else
    echo "   More than 32 GB of memory, setting arc size to 4 GB"
    sudo bash -c "echo \"options zfs zfs_arc_min=2097152\" > ${FILE_PATH_TO_ZFS_CONF}"
    sudo bash -c "echo \"options zfs zfs_arc_max=4194304\" >> ${FILE_PATH_TO_ZFS_CONF}"
  fi

  if [[ ${?} -eq 0 ]];
  then
    echo "   Adapted >>${FILE_PATH_TO_ZFS_CONF}<< with fitting option."
  else
    echo ":: Error"
    echo "   Could not set arc size option in >>${FILE_PATH_TO_ZFS_CONF}<<."
  fi
}

_main "${@}"
