#!/bin/bash
####
# 
####
# @since: 2023-06-10
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main()
{
  local CURRENT_LINE_NUMBER
  local LAST_RESULT_OF_PACKAGE_SEARCH
  local LIST_OF_INVALID_PACKEGES
  local LIST_OF_VALID_PACKEGES
  local PATH_OF_THE_CALLED_SCRIPT
  local PATH_TO_THE_PACKAGE_FILE

  CURRENT_LINE_NUMBER=0
  LIST_OF_INVALID_PACKEGES=""
  LIST_OF_VALID_PACKEGES=""
  PATH_OF_THE_CALLED_SCRIPT=$(cd $(dirname "${0}"); pwd)

  PATH_TO_THE_PACKAGE_FILE="${PATH_OF_THE_CALLED_SCRIPT}/list_of_archlinux_packages.txt"
  #list_of_archlinux_packages.txt
  #list_of_aur_packages.txt
  
  echo ":: Checking content of >>$(basename ${PATH_TO_THE_PACKAGE_FILE})<<."

  # implement check
  while IFS='' read -r CURRENT_CONTENT_LINE || [[ -n "${CURRENT_CONTENT_LINE}" ]];
  do
    if [[ "${#CURRENT_CONTENT_LINE}" -gt 0 ]] && [[ "${CURRENT_CONTENT_LINE:0:1}" != "#" ]];
    then
      LAST_RESULT_OF_PACKAGE_SEARCH=$(pacman -Ss "${CURRENT_CONTENT_LINE}")

      if [[ "${#LAST_RESULT_OF_PACKAGE_SEARCH}" -eq 0 ]]
      then
        echo -n "x"
        LIST_OF_INVALID_PACKEGES="${LIST_OF_INVALID_PACKEGES}${CURRENT_CONTENT_LINE} "
      else
        echo -n "."
        LIST_OF_VALID_PACKEGES="${LIST_OF_VALID_PACKEGES}${CURRENT_CONTENT_LINE} "
      fi
      ((++CURRENT_LINE_NUMBER))
      if (( CURRENT_LINE_NUMBER % 80 == 0 ));
      then
        echo ""
      fi
    fi
  done < "${PATH_TO_THE_PACKAGE_FILE}"

  #pacman -Ss < cat "${PATH_TO_THE_PACKAGE_FILE}" | tr '\n' ' '
  sudo pacman -S --noconfirm --needed "${LIST_OF_VALID_PACKEGES:0:-1}"

  if [[ ${#LIST_OF_INVALID_PACKEGES} -gt 0 ]];
  then
    echo ":: Dumping list of invalid packages"
    echo "   ${LIST_OF_INVALID_PACKEGES:0:-1}"
  fi
}

_main "${@}"
