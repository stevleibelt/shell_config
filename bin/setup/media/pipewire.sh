#!/bin/bash
####
# Installs and configures pipewire
####
# @see
#   https://wiki.archlinux.org/title/PipeWire
# @since 2025-11-17
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
  local PACKAGE_MANAGER

  PACKAGE_MANAGER="pacman"

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Aborting."
    echo "   No /usr/bin/pacman installed."

    exit 1
  fi

  if [[ -f /usr/bin/paru ]];
  then
    PACKAGE_MANAGER="paru"
  fi

  # pipewire-pulse : Low-latency audio/video router and processor - PulseAudio replacement
  # pipewire : Low-latency audio/video router and processor
  # wireplumber : Session / policy manager implementation for PipeWire
  # pipewire-alsa : Low-latency audio/video router and processor - ALSA configuration
  # pipewire-audio : Low-latency audio/video router and processor - Audio support
  ${PACKAGE_MANAGER} -S pipewire-pulse pipewire wireplumber pipewire-alsa pipewire-audio
}

install_if_needed

