#!/bin/bash
####
# Configures systemd-logind
####
# @see
#   https://wiki.archlinux.org/title/Power_management#ACPI_events
# @since 2025-12-28
# @author stev leibelt <artodeto@arcor.de>
####

function _main() {
  if [[ ! -d /etc/systemd/logind.conf.d ]];
  then
    echo ":: Error"
    echo "   Directory >>/etc/systemd/logind.conf.d<< does not exist"

    exit 10
  fi

  if [[ ! -f /etc/systemd/logind.conf.d/500_handle_lid_switch.conf ]];
  then
    sudo bash -c 'cat <<DELIM > /etc/systemd/logind.conf.d/500_handle_lid_switch.conf
[Login]
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
DELIM'

    sudo systemctl reload systemd-logind.service
  fi
}

_main "${@}"

