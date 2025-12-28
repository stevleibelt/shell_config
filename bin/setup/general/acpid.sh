#!/bin/bash
####
# Silence acpid log by dropping ordinary key event logs
####
# @see
#   https://wiki.archlinux.org/title/Acpid#Disabling_ordinary_key_events
# @since 2025-12-27
# @author stev leibelt <artodeto@arcor.de>
####

function _main() {
  if [[ ! -d /etc/acpi/events ]];
  then
    echo ":: Error"
    echo "   Directory >>/etc/acpi/events<< does not exist"

    exit 10
  fi

  if [[ ! -f /etc/acpi/events/buttons ]];
  then
    sudo bash -c 'cat <<DELIM > /etc/acpi/events/buttons
event=button/(up|down|left|right|kpenter)
action=<drop>
DELIM'
  fi
}

_main "${@}"

