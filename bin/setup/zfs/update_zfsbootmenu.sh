#!/bin/bash
####
# @since 2025-03-06
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  local CURRENT_OPTION
  local FORCE
  local NAME_OF_THE_IMAGE
  local FILE_PATH_TO_THE_IMAGE
  local FILE_PATH_TO_THE_IMAGE_BACKUP
  local FILE_PATH_TO_THE_IMAGE_TO_COMPARE
  local PATH_TO_THE_IMAGE
  local SHOW_HELP

  FORCE=0
  NAME_OF_THE_IMAGE="vmlinuz.EFI"
  PATH_TO_THE_IMAGE="/efi/EFI/ZBM"
  SHOW_HELP=0

  while getopts "fhn:p:" CURRENT_OPTION;
  do
    case ${CURRENT_OPTION} in
      f)
        FORCE=1
        ;;
      h)
        SHOW_HELP=1
        ;;
      n)
        NAME_OF_THE_IMAGE="${OPTARG}"
        ;;
      p)
        PATH_TO_THE_IMAGE="${OPTARG}"
        ;;
      *)
        ;;
    esac
  done

  if [[ ${SHOW_HELP} -eq 1 ]];
  then
    echo ":: Usage"
    echo "${0} [-f] [-h] [-n ${NAME_OF_THE_IMAGE}] [-p ${PATH_TO_THE_IMAGE}]"
    echo ""
    echo "-f  - Force installation, even if it is installed already"
    echo "-h  - Show this help"
    echo "-n  - Name of the image, default ${NAME_OF_THE_IMAGE}"
    echo "-p  - Directory path to the image, default ${PATH_TO_THE_IMAGE}"

    return 0
  fi

  FILE_PATH_TO_THE_IMAGE="${PATH_TO_THE_IMAGE}/${NAME_OF_THE_IMAGE}"
  FILE_PATH_TO_THE_IMAGE_BACKUP="${PATH_TO_THE_IMAGE}/${NAME_OF_THE_IMAGE}.previous"
  FILE_PATH_TO_THE_IMAGE_TO_COMPARE="${PATH_TO_THE_IMAGE}/${NAME_OF_THE_IMAGE}.fresh"

  #bo: testing environment
  if [[ ! -d "${PATH_TO_THE_IMAGE}" ]];
  then
    echo ":: Image path does not exist"
    echo "   >>${PATH_TO_THE_IMAGE}<<"

    exit 10
  fi

  if [[ ! -f /usr/bin/wget ]];
  then
    echo ":: Installing mandatory package wget"
    sudo pacman -S wget
  fi
  #eo: testing environment

  #eo: downloading image
  if [[ -f "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}" ]];
  then
    sudo rm "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}"
  fi

  sudo wget https://get.zfsbootmenu.org/latest.EFI -O "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}"
  #eo: downloading image

  #bo: updating image
  if [[ ! -f "${FILE_PATH_TO_THE_IMAGE}" ]];
  then
    echo ":: No image exist"
    sudo mv "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}" "${FILE_PATH_TO_THE_IMAGE}"
    echo "   File created >>${FILE_PATH_TO_THE_IMAGE}<<"
  else
    if cmp -s "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}" "${FILE_PATH_TO_THE_IMAGE}";
    then
      echo ":: Downloaded version does not differ"
      sudo rm "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}"
    else
      echo ":: Downloaded version differs"
      echo "   Renaming >>${FILE_PATH_TO_THE_IMAGE}<< to >>${FILE_PATH_TO_THE_IMAGE_BACKUP}<<"
      sudo mv "${FILE_PATH_TO_THE_IMAGE}" "${FILE_PATH_TO_THE_IMAGE_BACKUP}"
      sudo mv "${FILE_PATH_TO_THE_IMAGE_TO_COMPARE}" "${FILE_PATH_TO_THE_IMAGE}"
      echo "   File created >>${FILE_PATH_TO_THE_IMAGE}<<"
    fi
  fi
  #eo: updating image
}

_main "${@}"

