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
  local LEGACY_SYSTEMD_SERVICE_FILE_PATH="/etc/systemd/system/slock.service"  #should be removed 2024

  if [[ ! -f /usr/bin/slock ]];
  then
    echo ":: Error"
    echo "   slock is not installed."

    return 1
  fi

  if [[ -f "${LEGACY_SYSTEMD_SERVICE_FILE_PATH}" ]];
  then
    sudo systemctl stop slock.service
    sudo systemctl disable slock.service
    sudo rm "${LEGACY_SYSTEMD_SERVICE_FILE_PATH}"

    if [[ ${?} -ne 0 ]];
    then
      echo ":: Error"
      echo "   Could not remove legacy file >>${LEGACY_SYSTEMD_SERVICE_FILE_PATH}<<."

      return 2
    fi
  fi

  echo "   Creating service file >>slock@.service<<"
  sudo bash -c "cat > /etc/systemd/system/slock@.service <<DELIM
[Unit]
Description=Lock X session using slock for user %i
Before=sleep.target

[Service]
User=%i
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/xset dpms force suspend
ExecStart=/usr/bin/slock

[Install]
WantedBy=sleep.target
DELIM"

  echo "   Enabling service"
  sudo systemctl enable slock@${USER}.service
}

_main ${@}

