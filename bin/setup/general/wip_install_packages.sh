#!/bin/bash
####
# 
####
# @since: 2023-06-10
# @author: stev leibelt <artodeto@bazzline.net>
####

####
# @param1 <string: PATH_TO_PACKAGE_LIST>
# [@param2 <int: CHECK_CONTENT>] - 0|1, default is 1
####
function _install_archlinux_packages()
{
  local CHECK_CONTENT
  local CURRENT_LINE_NUMBER
  local LAST_RESULT_OF_PACKAGE_SEARCH
  local LIST_OF_INVALID_PACKEGES
  local LIST_OF_VALID_PACKEGES
  local PATH_TO_PACKAGE_LIST

  CHECK_CONTENT="${2:-1}"
  CURRENT_LINE_NUMBER=0
  LIST_OF_INVALID_PACKEGES=""
  LIST_OF_VALID_PACKEGES=""
  PATH_TO_PACKAGE_LIST="${1}"

  if [[ ! -f "${PATH_TO_PACKAGE_LIST}" ]];
  then
    echo ":: Error"
    echo "   >>${PATH_TO_PACKAGE_LIST}<< is not a valid file"

    return 1
  fi

  if [[ ${CHECK_CONTENT} -gt 0 ]];
  then
    echo ":: Checking content of >>$(basename ${PATH_TO_PACKAGE_LIST})<<."
  fi

  while IFS='' read -r CURRENT_CONTENT_LINE || [[ -n "${CURRENT_CONTENT_LINE}" ]];
  do
    if [[ "${#CURRENT_CONTENT_LINE}" -gt 0 ]] && [[ "${CURRENT_CONTENT_LINE:0:1}" != "#" ]];
    then
      if [[ ${CHECK_CONTENT} -gt 0 ]];
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
      else
        LIST_OF_VALID_PACKEGES="${LIST_OF_VALID_PACKEGES}${CURRENT_CONTENT_LINE} "
      fi
    fi
  done < "${PATH_TO_PACKAGE_LIST}"
  echo ""

  echo ":: Starting installation"
  sudo pacman -S --noconfirm --needed ${LIST_OF_VALID_PACKEGES:0:-1}

  if [[ ${#LIST_OF_INVALID_PACKEGES} -gt 0 ]];
  then
    echo ":: Dumping list of invalid archlinux packages"
    echo "   ${LIST_OF_INVALID_PACKEGES:0:-1}"
  fi
}

####
# @param1 <string: PATH_TO_PACKAGE_LIST>
# [@param2 <int: CHECK_CONTENT>] - 0|1, default is 1
####
function _install_aur_packages()
{
  local CHECK_CONTENT
  local CURRENT_LINE_NUMBER
  local LAST_RESULT_OF_PACKAGE_SEARCH
  local LIST_OF_INVALID_PACKEGES
  local LIST_OF_VALID_PACKEGES
  local PATH_TO_PACKAGE_LIST

  CHECK_CONTENT="${2:-1}"
  CURRENT_LINE_NUMBER=0
  LIST_OF_INVALID_PACKEGES=""
  LIST_OF_VALID_PACKEGES=""
  PATH_TO_PACKAGE_LIST="${1}"

  if [[ ${CHECK_CONTENT} -gt 0 ]];
  then
    echo ":: Checking content of >>$(basename ${1})<<."
  fi

  while IFS='' read -r CURRENT_CONTENT_LINE || [[ -n "${CURRENT_CONTENT_LINE}" ]];
  do
    if [[ "${#CURRENT_CONTENT_LINE}" -gt 0 ]] && [[ "${CURRENT_CONTENT_LINE:0:1}" != "#" ]];
    then
      if [[ ${CHECK_CONTENT} -gt 0 ]];
      then
        LAST_RESULT_OF_PACKAGE_SEARCH=$(yay -Ss "${CURRENT_CONTENT_LINE}")

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
      else
        LIST_OF_INVALID_PACKEGES="${LIST_OF_INVALID_PACKEGES}${CURRENT_CONTENT_LINE} "
      fi
    fi
  done < "${1}"
  echo ""

  echo ":: Starting installation"
  yay -S --noconfirm --needed ${LIST_OF_VALID_PACKEGES:0:-1}

  if [[ ${#LIST_OF_INVALID_PACKEGES} -gt 0 ]];
  then
    echo ":: Dumping list of invalid aur packages"
    echo "   ${LIST_OF_INVALID_PACKEGES:0:-1}"
  fi
}

function _main()
{
  local INSTALL_ARCHLINUX_PACKAGES
  local INSTALL_AUR_PACKAGES
  local PATH_OF_THE_CALLED_SCRIPT
  local PATH_TO_THE_PACKAGE_FILE

  INSTALL_ARCHLINUX_PACKAGES=0
  INSTALL_AUR_PACKAGES=1
  PATH_OF_THE_CALLED_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ${INSTALL_ARCHLINUX_PACKAGES} -gt 0 ]];
  then
    _install_archlinux_packages "${PATH_OF_THE_CALLED_SCRIPT}/list_of_archlinux_packages.txt" 0
    rustup default stable
    sudo enable autorandr-lid-listener.service
    sudo enable autorandr.service
    sudo start autorandr-lid-listener.service
    sudo start autorandr.service
  fi

  if [[ ${INSTALL_AUR_PACKAGES} -gt 0 ]];
  then
    _install_aur_packages "${PATH_OF_THE_CALLED_SCRIPT}/list_of_aur_packages.txt" 0
  fi
}

_main "${@}"
