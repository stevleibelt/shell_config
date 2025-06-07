#!/bin/bash
####
# Basic zfs setup
####
# @todo:
#   Add smartctl check timer
#   Add support for email on error
# @see: https://wiki.archlinux.org/title/ZFS - 20230108
# @since: 20230108
# @author: stev leibelt <artodeto@bazzline.net>
####

####
# @param: <string: question_to_ask>
# [@param:<string: "yes"|"no"] - default: yes
####
function _ask_with_question_and_positiv_answer ()
{
  local POSITIV_ANSWER
  local QUESTION
  local QUESTION_SUFFIX

  POSITIV_ANSWER="${2:-y}"
  QUESTION="${1}"

  if [[ ${POSITIV_ANSWER} == "y" ]];
  then
    QUESTION_SUFFIX=" (Y|n)"
  else
    QUESTION_SUFFIX=" (y|N)"
  fi

  read -p "> ${QUESTION} ${QUESTION_SUFFIX}: " -r

  if [[ ${POSITIV_ANSWER} == "y" ]];
  then
    if [[ ${REPLY:-${POSITIV_ANSWER}} =~ ^[Yy](es)?$ ]];
    then
      return 0
    else
      return 1
    fi
  else
    if [[ ${REPLY:-${POSITIV_ANSWER}} =~ ^[Nn](o)?$ ]];
    then
      return 0
    else
      return 1
    fi
  fi
}

####
# @param <string: systemctl.timer>
####
function _enable_and_start_zfs_timer_if_needed ()
{
  local SYSTEMCTL_TIMER="${1}"

  if ! sudo systemctl -q is-enabled "${SYSTEMCTL_TIMER}";
  then
    echo "   Enabling and staring >>${SYSTEMCTL_TIMER}<<."

    sudo systemctl enable "${SYSTEMCTL_TIMER}"
    sudo systemctl start "${SYSTEMCTL_TIMER}"
  fi
}

function _main ()
{
  #bo: user input
  local CURRENT_DATASET
  local IS_DRY_RUN
  local PATH_OF_THE_CURRENT_SCRIPT
  local LIST_OF_AVAILABLE_DATASETS
  local LIST_OF_AVAILABLE_ZPOOLS

  # 1 = on
  IS_DRY_RUN=0
  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

  declare -a LIST_OF_AVAILABLE_DATASETS=( $(zfs list | cut -f 1 -d " " | tail -n +2) )
  declare -a LIST_OF_AVAILABLE_ZPOOLS=()

  for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
  do
    ##zpools are datasets without an >>/<<
    if [[ ${CURRENT_DATASET} != */* ]];
    then
      LIST_OF_AVAILABLE_ZPOOLS+=("${CURRENT_DATASET}")
    fi
  done
  #eo: user input

  if _ask_with_question_and_positiv_answer "Apply general zpool and dataset tuning?";
  then
    echo ":: Processing available zpools and datasets."
    for CURRENT_DATASET in "${LIST_OF_AVAILABLE_DATASETS[@]}";
    do
      echo "   Processing >>${CURRENT_DATASET}<<"

      #bo: general tuning
      if [[ $(zfs get -H -o value atime "${CURRENT_DATASET}") != "on" ]];
      then
        echo "     Set >>atime<< to >>off<<"
        if [[ $IS_DRY_RUN -ne 1 ]];
        then
          sudo zfs set atime=off "${CURRENT_DATASET}"
        else
          echo "sudo zfs set atime=off \"${CURRENT_DATASET}\""
        fi
      fi

      if [[ $(zfs get -H -o value compression "${CURRENT_DATASET}") == "off" ]];
      then
        echo "     Set >>compression<< to >>on<<"
        if [[ $IS_DRY_RUN -ne 1 ]];
        then
          sudo zfs set compression=on "${CURRENT_DATASET}"
        else
          echo "sudo zfs set compression=on \"${CURRENT_DATASET}\""
        fi
      fi
      #eo: general tuning
    done
  fi

  #bo: autotrim trim timer
  if _ask_with_question_and_positiv_answer "Replace autotrim with weekly trim timer?";
  then
    if [[ ! -f /etc/systemd/system/zfs-trim@.timer ]];
    then
      echo "   Creating /etc/systemd/system/zfs-trim@.timer"
      sudo bash -c "cat > /etc/systemd/system/zfs-trim@.timer <<DELIM
[Unit]
Description=Monthly zpool trim on %i

[Timer]
OnCalendar=monthly
AccuracySec=1h
Persistent=true

[Install]
WantedBy=multi-user.target
DELIM"
    fi

    if [[ ! -f /etc/systemd/system/zfs-trim@.service ]];
    then
      echo "   Creating /etc/systemd/system/zfs-trim@.service"
      sudo bash -c "cat > /etc/systemd/system/zfs-trim@.service <<DELIM
[Unit]
Description=zpool trim on %i
Documentation=man:zpool-trim(8)
Requires=zfs.target
After=zfs.target
ConditionACPower=true
ConditionPathIsDirectory=/sys/module/zfs

[Service]
Nice=19
IOSchedulingClass=idle
KillSignal=SIGINT
ExecStart=/bin/sh -c '\
if /usr/bin/zpool status %i | grep \"trimming\"; then\
exec /usr/bin/zpool wait -t trim %i;\
else exec /usr/bin/zpool trim -w %i; fi'
ExecStop=-/bin/sh -c '/usr/bin/zpool trim -s %i 2>/dev/null || true'

[Install]
WantedBy=multi-user.target
DELIM"
    fi

    for CURRENT_ZPOOL in "${LIST_OF_AVAILABLE_ZPOOLS[@]}";
    do
      if [[ $(zpool get -H -o value autotrim "${CURRENT_ZPOOL}") != "on" ]];
      then
        echo "     Set >>autotrim<< to >>off<<"
        if [[ $IS_DRY_RUN -ne 1 ]];
        then
          sudo zpool set autotrim=on "${CURRENT_ZPOOL}"
        else
          echo "sudo zpool set autotrim=on \"${CURRENT_ZPOOL}\""
        fi
      fi

      if [[ $IS_DRY_RUN -ne 1 ]];
      then
        _enable_and_start_zfs_timer_if_needed "zfs-trim@${CURRENT_ZPOOL}.timer";
      else
        echo "_enable_and_start_zfs_timer_if_needed \"zfs-trim@${CURRENT_ZPOOL}.timer\";"
      fi
    done
  fi
  #eo: autotrim trim timer

  #bo: scrubbing timer
  if _ask_with_question_and_positiv_answer "Enable weekling scrub timer?";
  then
    for CURRENT_ZPOOL in "${LIST_OF_AVAILABLE_ZPOOLS[@]}";
    do
      if [[ $IS_DRY_RUN -ne 1 ]];
      then
        _enable_and_start_zfs_timer_if_needed "zfs-scrub-weekly@${CURRENT_ZPOOL}.timer";
      else
        echo "_enable_and_start_zfs_timer_if_needed \"zfs-scrub-weekly@${CURRENT_ZPOOL}.timer\";"
      fi
    done
  fi
  #eo: scrubbing timer

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh" ]];
  then
    if _ask_with_question_and_positiv_answer "Adapt arc size max to current memory?";
    then
      if [[ $IS_DRY_RUN -ne 1 ]];
      then
        bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh"
      else
        echo "bash \"${PATH_OF_THE_CURRENT_SCRIPT}/create_arc_size_max.sh\""
      fi
    fi
  fi

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh" ]];
  then
    if _ask_with_question_and_positiv_answer "Create swap?";
    then
      if [[ $IS_DRY_RUN -ne 1 ]];
      then
        bash "${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh"
      else
        echo "bash \"${PATH_OF_THE_CURRENT_SCRIPT}/create_swap.sh\""
      fi
    fi
  fi

  if [[ -f "${PATH_OF_THE_CURRENT_SCRIPT}/zrepl.sh" ]];
  then
    if _ask_with_question_and_positiv_answer "Setup zrepl?";
    then
      if [[ $IS_DRY_RUN -ne 1 ]];
      then
        bash "${PATH_OF_THE_CURRENT_SCRIPT}/zrepl.sh"
      else
        echo "bash \"${PATH_OF_THE_CURRENT_SCRIPT}/zrepl.sh\""
      fi
    fi
  fi
}

_main "${@}"

