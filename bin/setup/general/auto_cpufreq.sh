#!/bin/bash
####
# Silence acpid log by dropping ordinary key event logs
####
# @see
#   https://github.com/AdnanHodzic/auto-cpufreq/releases/tag/v3.0.0
# @since 2026-0113
# @author stev leibelt <artodeto@arcor.de>
####

function _main() {
  if [[ -f /usr/bin/yay ]];
  then
    PACKAGE_MANAGER="yay"
  elif [[ -f /usr/bin/paru ]];
  then
    PACKAGE_MANAGER="paru"
  else
    echo ":: Aborting."
    echo "   Neither /usr/bin/yay nor /usr/bin/paru found."

    exit 1
  fi

  if [[ ! -f /usr/bin/auto-cpufreq ]];
  then
    ${PACKAGE_MANAGER} -S auto-cpufreq

    sudo systemctl enable --now auto-cpufreq
  fi
}

_main "${@}"

