#!/bin/bash

####
# [@param int <selcted_release>
####
function net_bazzline_media_rip_cd_as_mp3()
{
  local SELECT_A_RELEASE
  local SELECTED_RELEASE

  if [[ ${#} -gt 0 ]];
  then
    SELECT_A_RELEASE=1
    SELECTED_RELEASE="${1}"
  else
    SELECT_A_RELEASE=0
  fi

  if [[ ${SELECT_A_RELEASE} -eq 1 ]];
  then
    cyanrip -o mp3 -s 0 -R "${SELECTED_RELEASE}"
  else
    cyanrip -o mp3 -s 0
  fi
}

