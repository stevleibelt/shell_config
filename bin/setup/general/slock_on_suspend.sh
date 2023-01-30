#!/bin/bash
####
# Creates a systemd service file
#
# @see
#   https://wiki.archlinux.org/title/Slock#Lock_on_suspend
#   https://www.jvt.me/posts/2019/12/03/lock-before-suspend-systemd/
#   https://linuxhint.com/replace_string_in_file_bash/
####
# @since 2021-02-21
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_SCRIPT_PATH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  local SYSTEMD_SERVICE_NAME="slock.service"

  local LOCK_FILE_PATH="/usr/bin/slock"
  local SYSTEMD_TEMPLATE_FILE="${CURRENT_SCRIPT_PATH}/data/systemd/${SYSTEMD_SERVICE_NAME}.template"
  local SYSTEMD_SERVICE_FILE_PATH="/etc/systemd/system/${SYSTEMD_SERVICE_NAME}"

  if [[ ! -f ${LOCK_FILE_PATH} ]];
  then
    echo ":: slock is not installed."
    echo "   >>${LOCK_FILE_PATH}<< is missing."

    if [[ -f /usr/bin/pacman ]];
    then
      echo ":: Installing it."

      sudo pacman -S slock
    else
      echo ":: Please install slock and restart this setup."

      exit 1
    fi
  fi


  if [[ -f ${SYSTEMD_SERVICE_FILE_PATH} ]];
  then
    echo ":: Systemd service file already exists."
  else
    local CURRENT_USER=$(whoami)
    echo ":: Creating systemd service file for user >>${CURRENT_USER}<<."
    sudo bash -c "sed \"s/CURRENT_USER/${CURRENT_USER}/\" ${SYSTEMD_TEMPLATE_FILE} > ${SYSTEMD_SERVICE_FILE_PATH}"

    echo "   File path >>${SYSTEMD_SERVICE_FILE_PATH}<<"

    echo ":: Enabling service"
    sudo systemctl enable ${SYSTEMD_SERVICE_NAME}
  fi
}

_main ${@}

