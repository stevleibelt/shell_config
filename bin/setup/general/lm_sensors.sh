#!/bin/bash
####
# Setup lm-sensors
####
# ref: https://wiki.archlinux.org/title/Fan_speed_control
# @since 2023-06-22
# @author stev leibelt <artodeto@arcor.de>
####

function _main()
{
  NOHANG_CONFIGURATION_FILE_PATH="/etc/nohang/nohang-desktop.conf"

  if [[ ! -f /usr/bin/sensors-detect ]];
  then
    sudo pacman -S lm_sensors
  fi

  sudo sensors-detect --auto
}

_main "${@}"
