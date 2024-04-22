#!/bin/bash
NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME='system_upgrade'

#a

####
# @param: <string> packagemanager_command
# [@param: <string> comma_separated_list_of_packages_to_ignore]
####
function net_bazzline_packagemanager_arch_linux_software_upgrade ()
{
    #bo: setup
  if [[ $# -lt 1 ]];
  then
      echo ":: Invalid amount of arguments provided."
      echo "   ${FUNCNAME[0]} <string: packagemanager_command: sudo pacman | yay> [<string: comma_separated_list_of_packages_to_ignore>"

      return 1;
  fi

  local CURRENT_DATETIME
  local CURRENT_TIMESTAMP
  local CREATE_SNAPSHOT
  local LAST_SYSTEM_UPDATE_FILE_PATH
  local LOG_FILE_PATH
  local PACKAGEMANAGER_COMMAND
  local PACKAGES_TO_IGNORE
  local PACMAN_LOCK_FILE_PATH
  local SEND_NOTIFY
  local UPGRADE_SCRIPT_FILE_PATH
  local ZFS_SNAPSHOT_NAME

  PACKAGES_TO_IGNORE="${2:-''}"
  LOG_FILE_PATH="/var/log/pacman.log"
  PACKAGEMANAGER_COMMAND="${1}"
  PACMAN_LOCK_FILE_PATH='/var/lib/pacman/db.lck'
  UPGRADE_SCRIPT_FILE_PATH="/tmp/net_bazzline_system_upgrade.sh"
  ZFS_SNAPSHOT_NAME='net_bazzline_before_system_upgrade'

  SEND_NOTIFY="# "
  if [[ -f /usr/bin/notify-send ]];
  then
    # xset q prints status information for current user
    # $? = 0 -> user is running a x session
    # $? != 0 -> user is not running a x session
    if xset q &>/dev/null;
    then
      SEND_NOTIFY="/usr/bin/notify-send "
    fi
  fi
  #@todo
  # eval if we can use znp or its idea
  # ref: https://gist.github.com/erikw/eeec35be33e847c211acd886ffb145d5
  #eo: setup

  #bo: check if packagemanager is valid
  if [[ "${PACKAGEMANAGER_COMMAND}" != "sudo pacman"  &&  ! -x $(command -v "${PACKAGEMANAGER_COMMAND}") ]];
  then
      echo ":: Invalid argument provided."
      echo "   Command >>${PACKAGEMANAGER_COMMAND}<< does not exist."

      return 2;
  fi
  #eo: check if packagemanager is valid

  #bo: check if lock file exists
  #@todo: move this into the generated script below, make sure to check if function net_bazzline_core_ask_yes_or_no exists
  if [[ -f ${PACMAN_LOCK_FILE_PATH} ]];
  then
    if net_bazzline_core_ask_yes_or_no "Lockfile exists. Remove it? (Y|n)" "y"
    then
      echo "   Removing lock file."
      sudo rm ${PACMAN_LOCK_FILE_PATH}
    else
      echo "   Aborting.";
      return 2;
    fi
  fi
  #bo: check if lock file exists

  #bo: snapshot creation
  #@todo: move this into the generated script below, make sure to check if function net_bazzline_core_ask_yes_or_no exists

  CREATE_SNAPSHOT=1

  if [[ ${NET_BAZZLINE_ZFS_IS_AVAILABLE} -eq 1 ]];
  then
    if sudo zfs list -t snapshot | grep -q "${ZFS_SNAPSHOT_NAME}";
    then
      if net_bazzline_core_ask_yes_or_no "Remove snapshot >>${NET_BAZZLINE_ZFS_DEFAULT_POOL}@${ZFS_SNAPSHOT_NAME}? (Y|n)" "y"
      then
        if sudo zfs destroy -r "${NET_BAZZLINE_ZFS_DEFAULT_POOL}@${ZFS_SNAPSHOT_NAME}";
        then
          echo "   Removed snapshot >>${ZFS_SNAPSHOT_NAME}<<."
        else
          echo ":: Error"
          echo "   Could not destory snapshot >>${NET_BAZZLINE_ZFS_DEFAULT_POOL}@${ZFS_SNAPSHOT_NAME}<<."
        
          return 30;
        fi
      else
        CREATE_SNAPSHOT=0
      fi
    fi

    if [[ ${CREATE_SNAPSHOT} -eq 1 ]];
    then
      if sudo zfs snapshot -r "${NET_BAZZLINE_ZFS_DEFAULT_POOL}@${ZFS_SNAPSHOT_NAME}";
      then
        echo "   Zfs snapshot >>${ZFS_SNAPSHOT_NAME}<< created."
      else
        echo ":: Error"
        echo "   Could not create snapshot >>${NET_BAZZLINE_ZFS_DEFAULT_POOL}@${ZFS_SNAPSHOT_NAME}"

        return 32;
      fi
    fi
  fi

  #bo: check last system update timestamp
  CURRENT_DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
  CURRENT_TIMESTAMP=$(date +'%s')
  LAST_SYSTEM_UPDATE_FILE_PATH="${NET_BAZZLINE_CACHE_PATH}/last_system_update"

  if [[ -f "${LAST_SYSTEM_UPDATE_FILE_PATH}" ]];
  then
    local LAST_SYSTEM_UPDATE_TIMESTAMP
    local LAST_VALID_TIMESTAMP

    LAST_SYSTEM_UPDATE_TIMESTAMP=$(head -n 5 "${LAST_SYSTEM_UPDATE_FILE_PATH}" | tail -n 1)
    LAST_VALID_TIMESTAMP=$(("${CURRENT_TIMESTAMP}" - 1209600))   #86400 (sec/day) * 14 (day) = 1209600 (sec)

    if [[ ${LAST_SYSTEM_UPDATE_TIMESTAMP} -lt ${LAST_VALID_TIMESTAMP} ]];
    then
      bash -c "${PACKAGEMANAGER_COMMAND} -S archlinux-keyring"

      if systemctl list-unit-files | grep -q reflector
      then
        sudo systemctl start reflector.service
      fi
    fi
  else
    if [[ ! -d "${NET_BAZZLINE_CACHE_PATH}" ]];
    then
      mkdir -p "${NET_BAZZLINE_CACHE_PATH}"
    fi
  fi 
  #eo: check last system update timestamp

  #bo: log file cleanup
  echo ":: Truncating >>${LOG_FILE_PATH}<<"
  sudo truncate -s 0 ${LOG_FILE_PATH}
  #eo: log file cleanup

  #bo: check if screen session exists
  net_bazzline_packagemanager_check_if_system_upgrade_screen_session_exists

  if  [[ ${?} -eq 1 ]];
  then
    #bo: upgrade script generation
    echo ":: Generating >>${UPGRADE_SCRIPT_FILE_PATH}<<"

    if [[ ${#PACKAGES_TO_IGNORE} -eq 0 ]];
    then
      cat > ${UPGRADE_SCRIPT_FILE_PATH} <<DELIM
#!/bin/bash
####

function _do_upgrade ()
{
  echo ":: Running upgrade"

  ${PACKAGEMANAGER_COMMAND} -Syyu
}
DELIM
      else
        cat > ${UPGRADE_SCRIPT_FILE_PATH} <<DELIM
#!/bin/bash
####

function _do_upgrade ()
{
  echo ":: Running upgrade"
  echo "   Ignoring packages >>${PACKAGES_TO_IGNORE}<<"

  ${PACKAGEMANAGER_COMMAND} -Syyu --ignore=${PACKAGES_TO_IGNORE}
}
DELIM
    fi

    cat >> ${UPGRADE_SCRIPT_FILE_PATH} <<DELIM

function _do_cleanup ()
{
  echo ":: Cleaning up" 

  ${PACKAGEMANAGER_COMMAND} -Sc
}

function _do_fwupdmgr ()
{
  echo ":: Updating firmware"

  sudo fwupdmgr refresh
  sudo fwupdmgr update
}

function _show_bad_message ()
{
  echo ":: Something bad happens.";
  read -n 1 -s -r -p "Press any key to continue"
}

function _show_waiting_message ()
{
  echo ":: Waiting for 30 seconds."
  echo "   Hit CTRL+C to terminate this waiting."

  sleep 30
}

function _main ()
{
  _do_upgrade
  if [[ \${?} -eq 0 ]];
  then
    _do_fwupdmgr
    ${SEND_NOTIFY} "Firmware update done"
    ${SEND_NOTIFY} "Upgrading done"
    _do_cleanup
    ${SEND_NOTIFY} "Cleanup done"
    _show_waiting_message
  else
    ${SEND_NOTIFY} "Error while upgrading"
    _show_bad_message
  fi
}

_main "\${@}"
DELIM
  echo ":: This script was generated in path >>${UPGRADE_SCRIPT_FILE_PATH}<<"
  #eo: upgrade script generation
    
    screen -dmS ${NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME} bash ${UPGRADE_SCRIPT_FILE_PATH}
  fi

  #this line is working because we make sure that there is a screen session or we create one above this line
  screen -r ${NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME}

  cat > "${LAST_SYSTEM_UPDATE_FILE_PATH}" <<DELIM
#!/bin/bash
#last system update datetime
${CURRENT_DATETIME}
#last system update timestamp
${CURRENT_TIMESTAMP}
DELIM

  echo ":: Runtime information"
  echo "   System upgrade logged: >>${LOG_FILE_PATH}<<."
  echo "   Executed upgrade script: >>${UPGRADE_SCRIPT_FILE_PATH}<<"
  if [[ ${NET_BAZZLINE_ZFS_IS_AVAILABLE} -eq 1 ]];
  then
    echo "   ZFS Snapshotname before upgrade: >>${ZFS_SNAPSHOT_NAME}<<"
  fi
  #eo: check if screen session exists
}

####
# @param: <string> packagemanager_command
####
function net_bazzline_packagemanager_apt_software_upgrade ()
{
    #bo: setup
    if [[ $# -lt 1 ]];
    then
        echo ":: Invalid amount of arguments provided."
        echo "   ${FUNCNAME[0]} <packagemanager_command: apt-get update && apt-get upgrade"

        return 1;
    fi

    local PACKAGEMANAGER_COMMAND="${1}"
    #eo: setup

    #bo: check if screen session exists
    net_bazzline_packagemanager_check_if_system_upgrade_screen_session_exists

    if  [[ $? -eq 1 ]];
    then
        screen -dmS ${NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME} bash -c "${PACKAGEMANAGER_COMMAND}; echo \":: Waiting for 30 seconds.\"; echo \" Hit CTRL+C to terminate this waiting. \"; sleep 30"
    fi

    screen -r ${NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME}
}


#c

function net_bazzline_packagemanager_check_if_system_upgrade_screen_session_exists ()
{
    #grep -q will exit with an code != 0 if there is no running screen session.
    screen -ls | grep -q ${NET_BAZZLINE_FUNCTION_PACKAGEMANAGER_SYSTEM_UPGRADE_SCREEN_SESSION_NAME}
}
