#!/bin/bash

function net_bazzline_date_convert_from_timestampe ()
{
  for CURRENT_TIMESTAMP in "${@}";
  do
    if [[ ! -z "${CURRENT_TIMESTAMP##*[!0-9]}" ]];
    then
      local CURRENT_DATE=$(date -d @${CURRENT_TIMESTAMP})
      echo "   Timestamp >>${CURRENT_TIMESTAMP}<< is date >>${CURRENT_DATE}<<"
    else
      echo "   Skipping >>${CURRENT_TIMESTAMP}<< - not a number."
    fi
  done
}

