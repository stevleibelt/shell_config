#!/bin/bash
####
# Installs and configures notification
####
# @see
#   https://wiki.archlinux.org/title/Desktop_notifications
# @since 2024-03-27
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -d /usr/include/libnotify ]];
  then
    echo ":: Libnotify is installed already"
  else
    sudo pacman -S libnotify
  fi

  if [[ -f /usr/bin/notify-send ]];
  then
      echo ":: Notify-send is installed already"
  else
      sudo pacman -S notify-send
  fi

  if [[ -d /usr/lib/notification-daemon-1.0 ]];
  then
    echo ":: Notification-deamon is already installed"
  else
    sudo pacman -S notification-daemon
  fi

  if [[ -f /usr/share/dbus-1/services/org.freedesktop.Notifications.service ]];
  then
    echo ":: Notification-deamon is already configured"
  else
    echo ":: Configuring Notification-deamon"
    sudo bash -c "cat > /usr/share/dbus-1/services/org.freedesktop.Notifications.service <<DELIM
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/notification-daemon-1.0/notification-daemon
DELIM"
  fi

  notify-send "All Glory To The Hypnotoad"
}

install_if_needed

