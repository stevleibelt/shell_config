#!/bin/bash

####
# @param <string> path_to_the_video_file
# @see: https://www.linuxnix.com/linuxunix-convert-a-video-file-to-gif-file/
####
function net_bazzline_convert_video_to_gif ()
{
    #@todo
    # check if mplayer and convert is installed
    # check if input file exists
    #
    # get file base name
    # create temp dir
    # convert to temp dir
    # convert to file base name gif
    # optimize gif
    #mplayer -ao null <video file name> -vo jpeg:outdir=output
    #convert output/* output.gif
    #convert output.gif -fuzz 10% -layers Optimize optimised.gif

    echo "not done yet"
}

####
# Uses vobcopy and ffmpeg to rip the biggest vob's, merges them and create a
#   mkv file with all audio streams.
####
# [@param <string: movie_name> - default is movie
# [@param <string: input_device> - default is /dev/sr0
# [@param <string: ffmpeg_video_codec] - default is libx265
# [@param <int: process_prority> - default is -19
# @see:
#   https://www.internalpointers.com/post/convert-vob-files-mkv-ffmpeg
#   https://stackoverflow.com/questions/37820083/ffmpeg-not-copying-all-audio-streams
####
function net_bazzline_media_rip_dvd_to_mkv ()
{
  local FFMPEG_VIDEO_CODEC="${3:-libx265}"
  local INPUT_DEVICE="${2:-/dev/sr0}"
  local PROCESS_PRIORITY=${4:--19}
  local MOVIE_NAME=${1:-'movie'}

  local MERGED_VOB_FILE_NAME="${MOVIE_NAME}.vob"
  local NUMBER_OF_VOB_FILES=$(ls * | grep -c ".vob")
  local OUTPUT_FILE_NAME="${MOVIE_NAME}.mkv"

  if [[ ${NUMBER_OF_VOB_FILES} -eq 0 ]];
  then
    if [[ -e ${INPUT_DEVICE} ]];
    then
      echo ":: Ripping dvd"
      vobcopy -i ${INPUT_DEVICE} -M
    else
      echo ":: No input device found."
      echo "   >>${INPUT_DEVICE}<< does not exist."

      return 1
    fi
  fi

  if [[ ! -f "${MERGED_VOB_FILE_NAME}" ]];
  then
    echo ":: Mergig vob-files"
    cat *.vob > "${MERGED_VOB_FILE_NAME}".tmp

    echo ":: Cleanup"
    rm *.vob
    mv "${MERGED_VOB_FILE_NAME}".tmp "${MERGED_VOB_FILE_NAME}"
  fi

  echo ":: Converting vob to mkv"
  nice ${PROCESS_PRIORITY} \
    ffmpeg \
    -i ${MERGED_VOB_FILE_NAME} \
    -analyzeduration 100M -probesize 100M \
    -dn \
    -map 0:a \
    -map 0:v \
    -codec:v ${FFMPEG_VIDEO_CODEC} \
    -crf 21 \
    -codec:a libmp3lame \
    -qscale:a 2 \
    -codec:s copy \
    ${OUTPUT_FILE_NAME}

  echo "   File >>${OUTPUT_FILE_NAME}<< created."
  echo "   Please remove the >>${MERGED_VOB_FILE_NAME}<< manually after you've validated the mkv file."
}
