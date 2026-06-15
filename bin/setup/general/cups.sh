#!/bin/bash
####
# Installs and configures cups
####
# @ref
#   https://wiki.archlinux.org/title/CUPS#AirPrint_and_IPP_Everywhere
#   https://wiki.archlinux.org/title/Avahi#Hostname_resolution
# @since 2026-03-26
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  echo ":: Installing and configuring cups"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ ${EUID} -ne 0 ]];
  then
    # Restart script by using sudo if we are not root
    echo "   Restarting script as root"
    sudo "${0}" "${@}"
  fi

  pacman -S avahi \
    cups cups-filters cups-pk-helper cups-pdf \
    foomatic-db foomatic-db-engine foomatic-db-gutenprint-ppds foomatic-db-nonfree-ppds foomatic-db-ppds \
    gutenprint \
    nss-mdns \
    system-config-printer

  #bo: firewall adaptation
  if [[ -f /usr/bin/ufw ]];
  then
    sudo ufw allow Bonjour
  fi
  #eo: firewall adaptation


  systemctl enable avahi-daemon.socket
  systemctl start avahi-daemon.socket

  systemctl enable cups.socket
  systemctl start cups.socket
}

install_if_needed "${@}"

