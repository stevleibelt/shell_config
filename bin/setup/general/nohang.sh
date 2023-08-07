#!/bin/bash
####
# Setup nohang
####
# @since 2023-06-19
# @author stev leibelt <artodeto@arcor.de>
####

function _main()
{
  local CURRENT_DATE_TIME
  local NOHANG_CONFIGURATION_FILE_PATH

  NOHANG_CONFIGURATION_FILE_PATH="/etc/nohang/nohang-desktop.conf"

  if [[ ! -f /usr/bin/nohang ]];
  then
    sudo pacman -S nohang
  fi

  if [[ ! -d /etc/nohang ]];
  then
    sudo mkdir /etc/nohang
  elif [[ -f "${NOHANG_CONFIGURATION_FILE_PATH}" ]];
  then
    if ! grep -q '##own_configuration';
    then
      echo ":: Copy >>${NOHANG_CONFIGURATION_FILE_PATH}<< to >>${NOHANG_CONFIGURATION_FILE_PATH}.${CURRENT_DATE_TIME}<<"
      cp -v "${NOHANG_CONFIGURATION_FILE_PATH}" "${NOHANG_CONFIGURATION_FILE_PATH}.${CURRENT_DATE_TIME}"

      echo ":: Please do the following manually"
      echo "   Open ${NOHANG_CONFIGURATION_FILE_PATH}"
      echo "   Search for line >>7.2.6. Matching /proc/[pid]/cwd realpath with RE patterns<<"
      echo "   Add the following lines **above**"
      echo ""
      echo '##own_configuration'
      echo 'Prefer jetbrains-toolbox.'
      echo '@BADNESS_ADJ_RE_REALPATH  400 /// ^(/usr/bin/jetbrains-toolbox)$'
      echo 'Prefer telegram-desktop.'
      echo '@BADNESS_ADJ_RE_REALPATH  400 /// ^(/usr/bin/telegram-desktop)$'
      echo 'Prefer signal-desktop.'
      echo '@BADNESS_ADJ_RE_REALPATH  400 /// ^(/usr/bin/signal-desktop)$'
      echo 'Prefer gnome-terminal.'
      echo '@BADNESS_ADJ_RE_REALPATH  -200 /// ^(/usr/bin/gnome-terminal)$'
    fi
  fi

  if ! sudo systemctl is-active nohang-desktop.service;
  then
    sudo systemctl enable nohang-desktop.service
    sudo systemctl start nohang-desktop.service
  fi
}

_main "${@}"
