#!/bin/bash
####
# @since 2025-03-25
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_OPTION
  local SCRIPT_ARGUMENTS
  local SHOW_HELP
  local THIS_SCRIPT_PATH

  SHOW_HELP=0

  while getopts "fh" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      f)
        SCRIPT_ARGUMENTS=" -f"
        ;;
      h)
        SHOW_HELP=1
        ;;
      *)
        ;;
    esac
  done

  if [[ ${SHOW_HELP} -eq 1 ]];
  then
    echo ":: Usage"
    echo "${0} [-f] [-h]"
    echo ""
    echo "-f  - Force setup, even if it is already done"
    echo "-h  - Show this help"

    return 0
  fi

  THIS_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  bash "${THIS_SCRIPT_PATH}/arch_basic.sh" "${SCRIPT_ARGUMENTS}"
  bash "${THIS_SCRIPT_PATH}/reflector.sh" "${SCRIPT_ARGUMENTS}"
  bash "${THIS_SCRIPT_PATH}/paccache.sh" "${SCRIPT_ARGUMENTS}"
  bash "${THIS_SCRIPT_PATH}/pacserve.sh" "${SCRIPT_ARGUMENTS}"

  read -p ">  Setup paru (p) or yay (y) (default: p)? " -r

  if [[ ${REPLY} =~ ^[Yy]$ ]];
  then
    bash "${THIS_SCRIPT_PATH}/yay.sh" "${SCRIPT_ARGUMENTS}"
  else
    bash "${THIS_SCRIPT_PATH}/paru.sh" "${SCRIPT_ARGUMENTS}"
  fi
}

_main "${@}"

