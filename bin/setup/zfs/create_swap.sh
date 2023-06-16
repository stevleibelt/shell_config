#!/bin/bash
####
# Create swap
####
# ref: https://wiki.archlinux.org/title/ZFS#Swap_volume
# @since: 20230616
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main()
{
  if ! swapon -s | grep -q '/dev';
  then
    zfs list
    read -p "> Please input local root zpool (e.g. zroot). " -r

    if [[ ${#REPLY} -gt 0 ]];
    then

      sudo zfs create -V 8G             \
        -b $(getconf PAGESIZE)          \
        -o compression=zle              \
        -o logbias=throughput           \
        -o sync=always                  \
        -o primarycache=metadata        \
        -o secondarycache=none          \
        -o com.sun:auto-snapshot=false  \
        "${REPLY}/swap"

      sudo mkswap -f "/dev/zvol/${REPLY}/swap"
      sudo swapon "/dev/zvol/${REPLY}/swap"

      sudo bash -c "cat >> /etc/fstab <<DELIM
/dev/zvol/${REPLY}/swap none  swap  discard 0 0
DELIM"
    else
      echo "   Invalid or no pool name provided."
    fi
  else
    echo "   Skipping swap creation, there is a swap available already"
  fi
}

_main "${@}"

