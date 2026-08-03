#!/bin/bash
####
# @since 2026-08-02
# @author stev leibelt <artodeto@bazzline.net>
####

function _main()
{
  #bo: variable
  local FILE_PATH
  local PACKAGE_ARRAY_TO_KEEP
  local PACKAGE_ARRAY_TO_REMOVE
  local PACKAGE_MANAGER

  FILE_PATH="${1}"
  PACKAGE_ARRAY_TO_KEEP=()
  PACKAGE_ARRAY_TO_REMOVE=()
  PACKAGE_MANAGER="/usr/bin/pacman"
  #eo: variable

  #bo: system check
  if [[ $# -lt 1 ]];
  then
    echo ":: Usage"
    echo "${0} <string: file_path>"

    return 0
  fi

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   Sorry dude, I can only install things on a arch linux."

      return 10
  fi

  if [[ ! -f "${FILE_PATH}" ]];
  then
    echo ":: Invalid file path provided"
    echo "   >>${FILE_PATH}<< is not a file"

    return 20
  fi

  if [[ -f /usr/bin/paru ]];
  then
    PACKAGE_MANAGER="/usr/bin/paru"
  elif [[ -f /usr/bin/yay ]];
  then
    PACKAGE_MANAGER="/usr/bin/yay"
  fi
  #eo: system check

  while IFS= read -r LINE;
  do
    if [[ "${LINE}" == \#* ]];
    then
      # Add to array and remove first #
      PACKAGE_ARRAY_TO_REMOVE+=("${LINE#\#}")
    else
      PACKAGE_ARRAY_TO_KEEP+=("${LINE}")
    fi
  done < "${FILE_PATH}"

  if [[ ${#PACKAGE_ARRAY_TO_KEEP[@]} -ne 0 ]];
  then
    #${PACKAGE_MANAGER} -S "${PACKAGE_ARRAY_TO_KEEP[@]}"
    printf "${PACKAGE_MANAGER} -S %s\n" "${PACKAGE_ARRAY_TO_KEEP[@]}"
  fi


  if [[ ${#PACKAGE_ARRAY_TO_REMOVE[@]} -ne 0 ]];
  then
    #${PACKAGE_MANAGER} -R "${PACKAGE_ARRAY_TO_REMOVE[@]}"
    printf "${PACKAGE_MANAGER} -R %s\n" "${PACKAGE_ARRAY_TO_REMOVE[@]}"
  fi
}

_main "${@}"

