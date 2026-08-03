#!/bin/bash
####
# @since 2026-08-02
# @author stev leibelt <artodeto@bazzline.net>
####
# cat > my_package_file.txt <<DELIM
# ####
# # The logic is simple
# # # My comment
# # +my_ensured_installed_package
# # -my_ensured_not_installed_package
# DELIM
#
####

function _main()
{
  #bo: variable
  local FILE_PATH
  local INSTALLED_PACKAGE_ARRAY_TO_REMOVE
  local PACKAGE_ARRAY_TO_KEEP
  local PACKAGE_ARRAY_TO_REMOVE
  local PACKAGE_MANAGER

  FILE_PATH="${1}"
  INSTALLED_PACKAGE_ARRAY_TO_REMOVE=()
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
    if [[ "${LINE}" == -* ]];
    then
      # Add to array and remove first -
      PACKAGE_ARRAY_TO_REMOVE+=("${LINE#-}")
    elif [[ "${LINE}" == +* ]];
    then
      # Add to array and remove first +
      PACKAGE_ARRAY_TO_KEEP+=("${LINE#+}")
    fi
  done < "${FILE_PATH}"

  if [[ ${#PACKAGE_ARRAY_TO_KEEP[@]} -ne 0 ]];
  then
    echo ":: Ensuring following packages are installed."
    printf "   %s\n" "${PACKAGE_ARRAY_TO_KEEP[@]}"

    ${PACKAGE_MANAGER} -S --needed "${PACKAGE_ARRAY_TO_KEEP[@]}"
  fi

  for CURRENT_PACKAGE in "${PACKAGE_ARRAY_TO_REMOVE[@]}";
  do
    if pacman -Qi "${CURRENT_PACKAGE}" &>/dev/null;
    then
      INSTALLED_PACKAGE_ARRAY_TO_REMOVE+=("${CURRENT_PACKAGE}")
    fi
  done

  if [[ ${#INSTALLED_PACKAGE_ARRAY_TO_REMOVE[@]} -ne 0 ]];
  then
    echo ":: Ensuring following packages are removed."
    printf "   %s\n" "${INSTALLED_PACKAGE_ARRAY_TO_REMOVE[@]}"

    ${PACKAGE_MANAGER} -R "${INSTALLED_PACKAGE_ARRAY_TO_REMOVE[@]}"
  fi
}

_main "${@}"

