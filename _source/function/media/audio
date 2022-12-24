#!/bin/bash

####
# [@param int <selcted_release>
####
function net_bazzline_media_rip_cd_as_mp3()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    local NAME_OF_THE_SNAPSHOT=$(date +'%Y-%m-%d_%H-%M-%S')

    if [[ $# -gt 0 ]];
    then
      local SELECT_A_RELEASE=1
      local SELECTED_RELEASE="${1}"
    else
      local SELECT_A_RELEASE=0
    fi

    if [[ ${SELECT_A_RELEASE} -eq 1 ]];
    then
      cyanrip -o mp3 -R ${SELECTED_RELEASE}
    else
      cyanrip -o mp3
    fi
}

