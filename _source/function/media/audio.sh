#!/bin/bash
 
####
# [@param string <WORKING_DIRECTORY, $PWD>
####
function net_bazzline_media_batch_convert_flac_to_mp3()
{
  local WORKING_DIRECTORY

  WORKING_DIRECTORY="${1:-$PWD}"

  if [[ ! -d "${WORKING_DIRECTORY}" ]];
  then
    echo ":: Error"
    echo "   >>${WORKING_DIRECTORY}<< is not a directory"

    return 10
  fi

  for FILE in "${WORKING_DIRECTORY}"/*.flac; do
    net_bazzline_media_convert_flac_to_mp3 "${FILE}"
  done

  echo ":: Done"
  echo "   Please tag files with Picard"
}

####
# @param string <SOURCE_FILE_PATH>
# [@param int <PROCESS_PRIORITY, -19>]
####
function net_bazzline_media_convert_flac_to_mp3()
{
  local DESTINATION_FILE_PATH
  local PROCESS_PRIORITY
  local SOURCE_FILE_PATH

  DESTINATION_FILE_PATH="${1%.flac}.mp3"
  PROCESS_PRIORITY=${2:--19}
  SOURCE_FILE_PATH="${1}"

  if [[ ! -f "${SOURCE_FILE_PATH}" ]];
  then
    echo ":: Error"
    echo "   >>${SOURCE_FILE_PATH}<< is not a file"

    return 10
  fi

  if [[ -f "${DESTINATION_FILE_PATH}" ]];
  then
    echo ":: Error"
    echo "   >>${DESTINATION_FILE_PATH}<< exists"

    return 15
  fi

  # -qscale:a 2, quality scale audio with 2, the lower the number, the higher the quality
  nice ${PROCESS_PRIORITY} \
    ffmpeg \
    -i "${SOURCE_FILE_PATH}" \
    -codec:a libmp3lame \
    -qscale:a 2 \
    "${DESTINATION_FILE_PATH}"
}

####
# [@param int <SELECTED_RELEASE>
####
function net_bazzline_media_rip_cd_as_mp3_with_cyanrip()
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

