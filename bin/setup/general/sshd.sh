#!/bin/bash
####
# Installs and configures sshd
####
# @since 2024-04-02
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed()
{
  echo ":: Installing and configuring sshd if needed"
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/sshd ]];
  then
    echo "   Sshd is installed already"
  else
    sudo pacman -S openssh
  fi

  if [[ -f /etc/ssh/sshd_config.d/10-elbzone.conf ]];
  then
    echo "   Sshd is already configured"
  else
    echo "   Configuring sshd"
    sudo bash -c "cat > /etc/ssh/sshd_config.d/10-elbzone.conf <<DELIM
PermitRootLogin no
AuthenticationMethods publickey
PermitRootLogin no
AuthenticationMethods publickey,keyboard-interactive
PasswordAuthentication no
ChallengeResponseAuthentication no
SyslogFacility AUTH
LogLevel INFO
PasswordAuthentication no
ChallengeResponseAuthentication no
SyslogFacility AUTH
LogLevel INFO
DELIM"
  fi
}

install_if_needed

