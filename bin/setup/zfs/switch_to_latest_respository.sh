#!/bin/bash
####
# Switch to latest repository
####
# @see: https://github.com/archzfs/archzfs/wiki#using-the-repository
# @since: 20260309
# @author: stev leibelt <artodeto@bazzline.net>
####

# Stop script execution after first faulty command
set -e

function _main ()
{
  local ARCHZFS_CONF_FILE_PATH
  local CURRENT_DATE_TIME
  local LATEST_REPOSITORY_KEY
  local LATEST_REPOSITORY_URI
  local PACMAN_CONF_FILE_PATH

  ARCHZFS_CONF_FILE_PATH="/etc/pacman.d/archzfs"
  CURRENT_DATE_TIME=$(date +'%Y%m%d_%H%M%S')
  LATEST_REPOSITORY_KEY="3A9917BF0DED5C13F69AC68FABEC0A1208037BE9"
  LATEST_REPOSITORY_URI="https://github.com/archzfs/archzfs/releases/download/experimental"
  PACMAN_CONF_FILE_PATH="/etc/pacman.conf"

  if [[ ${EUID} -ne 0 ]];
  then
    # Restart script by using sudo if we are not root
    sudo "${0}" "${@}"
  fi

  if [[ ! -f "${PACMAN_CONF_FILE_PATH}" ]];
  then
    echo ":: ${PACMAN_CONF_FILE_PATH} not found."
    exit 12
  fi

  if [[ -f "${ARCHZFS_CONF_FILE_PATH}" ]];
  then
    if ! grep -q "${LATEST_REPOSITORY_URI}" "${ARCHZFS_CONF_FILE_PATH}";
    then
      cp "${ARCHZFS_CONF_FILE_PATH}" "${ARCHZFS_CONF_FILE_PATH}.${CURRENT_DATE_TIME}"
      echo ":: Created backup ${ARCHZFS_CONF_FILE_PATH}.${CURRENT_DATE_TIME}"

      cat > "${ARCHZFS_CONF_FILE_PATH}" <<DELIM
SigLevel = Required
Server = '"${LATEST_REPOSITORY_URI}"'
DELIM
    fi
  else
    if ! grep -q "${LATEST_REPOSITORY_URI}" "${PACMAN_CONF_FILE_PATH}";
    then
      cp "${PACMAN_CONF_FILE_PATH}" "${PACMAN_CONF_FILE_PATH}.${CURRENT_DATE_TIME}"
      echo ":: Created backup ${PACMAN_CONF_FILE_PATH}.${CURRENT_DATE_TIME}"

      # -i:                               Modify file in place
      # '/[archzfs]/,/^\[/':              Specifies the range for the next section as "all after >>[archzfs]<< and before >>[<< (or end of file)."
      # '/{ /^Server = [^#]/ s/^/# /; }': Prefix each line starting with >>Server = << with >># << (comment this line out)
      sed -i '/\[archzfs\]/,/^\[/ { /^Server = [^#]/ s/^/# /; }' "${PACMAN_CONF_FILE_PATH}"

      # -i:                               Modify file in place
      # '/\[archzfs\]/a\':		Append (>>/a<<) after >>[archzfs]<<
      sed -i '/\[archzfs\]/a\
  SigLevel = Required\
  Server = '"${LATEST_REPOSITORY_URI}" "${PACMAN_CONF_FILE_PATH}"

      echo ":: Show changes made on ${PACMAN_CONF_FILE_PATH}"
      diff "${PACMAN_CONF_FILE_PATH}" "${PACMAN_CONF_FILE_PATH}.${CURRENT_DATE_TIME}"
    fi
  fi

  if ! pacman-key -l | grep -q "${LATEST_REPOSITORY_KEY}";
  then
    echo ":: Adding latest repository pgp verification key"
    pacman-key --recv-keys ${LATEST_REPOSITORY_KEY}
    pacman-key --lsign-key ${LATEST_REPOSITORY_KEY}
  fi
}

_main "${@}"
