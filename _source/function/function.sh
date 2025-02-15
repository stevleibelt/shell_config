#!/bin/bash
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-04-24
# @see https://www.gnu.org/software/bash/manual/bash.html
####

#b

####
# Rsync with default backup values
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2015-04-07
####
function net_bazzline_backup_to ()
{
    if [[ $# -eq 0 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source one> [<source ...>] <target>"

        return 1
    elif [[ $# -eq 1 ]];
    then
        net_bazzline_rsync . "${1}"
    else
        net_bazzline_rsync $@
    fi
}

####
# Renames all existing directory content to lower case
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
####
function net_bazzline_batch_directory_path_to_lower ()
{
    local MAX_DEPTH
    local SEARCH_PATH

    MAX_DEPTH=${1:-1}
    SEARCH_PATH="${2:-.}"

    net_bazzline_batch_filesystem_path_to_lower "${MAX_DEPTH}" "${SEARCH_PATH}" "d"
}

####
# Convertes all files within the given path
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
####
function net_bazzline_batch_convert_video_to_libx264 ()
{
    local MAX_DEPTH
    local SEARCH_PATH

    MAX_DEPTH=${1:-1}
    SEARCH_PATH="${2:-.}"

    #@todo use parallel if available
    find "${SEARCH_PATH}" -maxdepth "${MAX_DEPTH}" -type f -iregex '.*\.\(mp4\|mov\|flv\|avi\|webm\)$' -print0 | while read -r -d $'\0' FILE_PATH;
    do
        #@see: https://stackoverflow.com/a/25535717
        #skip all files ending with ".converted264.mkv"
        if [[ ${FILE_PATH: -17} != ".converted264.mkv" ]];
        then
            if [[ "${SEARCH_PATH}" == "." ]];
            then
                #remove ./ from the file path
                FILE_PATH="${FILE_PATH:2}"
            fi

            net_bazzline_convert_video_to_libx264 "${FILE_PATH}"
        fi
    done;
}

####
# Convertes all files within the given path
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# @todo change order of parameters everywhere
# @author stev leibelt <artodeto@bazzline.net>
# @since 2020-07-06
####
function net_bazzline_batch_convert_video_to_librav1e ()
{
    local MAX_DEPTH
    local SEARCH_PATH

    MAX_DEPTH=${1:-1}
    SEARCH_PATH="${2:-.}"

    #@todo use parallel if available
    #find ${SEARCH_PATH} -maxdepth ${MAX_DEPTH} -type f -print0 | while read -d $'\0' FILE_PATH;
    find "${SEARCH_PATH}" -maxdepth "${MAX_DEPTH}" -type f -iregex '.*\.\(mp4\|mov\|flv\|avi\|webm\)$' -print0 | while read -r -d $'\0' FILE_PATH;
    do
        #@see: https://stackoverflow.com/a/25535717
        #if [[ ${FILE_PATH} != *"converted265"* ]];
        #skip all files ending with ".converted265.mkv"
        if [[ ${FILE_PATH: -17} != ".convertedRav1e.mkv" ]];
        then
            if [[ "${SEARCH_PATH}" == "." ]];
            then
                #remove ./ from the file path
                FILE_PATH="${FILE_PATH:2}"
            fi

            net_bazzline_convert_video_to_librav1e "${FILE_PATH}"
        fi
    done;
}

####
# Convertes all files within the given path
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# @todo change order of parameters everywhere
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
####
function net_bazzline_batch_convert_video_to_libx265 ()
{
    local MAX_DEPTH
    local SEARCH_PATH

    MAX_DEPTH=${1:-1}
    SEARCH_PATH="${2:-.}"

    #@todo use parallel if available
    #find ${SEARCH_PATH} -maxdepth ${MAX_DEPTH} -type f -print0 | while read -d $'\0' FILE_PATH;
    find "${SEARCH_PATH}" -maxdepth "${MAX_DEPTH}" -type f -iregex '.*\.\(mp4\|mov\|flv\|avi\|webm\)$' -print0 | while read -r -d $'\0' FILE_PATH;
    do
        #@see: https://stackoverflow.com/a/25535717
        #if [[ ${FILE_PATH} != *"converted265"* ]];
        #skip all files ending with ".converted265.mkv"
        if [[ ${FILE_PATH: -17} != ".converted265.mkv" ]];
        then
            if [[ "${SEARCH_PATH}" == "." ]];
            then
                #remove ./ from the file path
                FILE_PATH="${FILE_PATH:2}"
            fi

            net_bazzline_convert_video_to_libx265 "${FILE_PATH}"
        fi
    done;
}

####
# Renames all existing directory content to lower case
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
####
function net_bazzline_batch_file_path_to_lower ()
{
    local MAX_DEPTH
    local SEARCH_PATH

    MAX_DEPTH=${1:-1}
    SEARCH_PATH="${2:-.}"

    net_bazzline_batch_filesystem_path_to_lower "${MAX_DEPTH}" "${SEARCH_PATH}" "f"
}

####
# Renames all existing directory content to lower case
#
# [@param int $1 - max depth - default is 1]
# [@param string $1 - search path - default is .]
# [@param string $1 - type - default is no type - must be something find does support]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
####
function net_bazzline_batch_filesystem_path_to_lower ()
{
  local FILE_TYPE_OPTION
  local FILE_TYPE
  local MAX_DEPTH
  local SEARCH_PATH

  FILE_TYPE="${3:-''}"
  MAX_DEPTH=${1:-1}
  SEARCH_PATH="${2:-.}"

  #@todo check not working. When called without any argument, following error is displayed
  #find: Arguments to -type should contain only one letter
  if [[ "${#FILE_TYPE}" -gt 0 ]];
  then
    FILE_TYPE_OPTION=" -type ${FILE_TYPE}"
  else
    FILE_TYPE_OPTION=""
  fi

  find "${SEARCH_PATH}" -maxdepth ${MAX_DEPTH}${FILE_TYPE_OPTION} -print0 | while read -r -d $'\0' FILE_PATH;
  do
    if [[ "${SEARCH_PATH}" == "." ]];
    then
      FILE_PATH="${FILE_PATH:2}"
    fi

    net_bazzline_filesystem_path_to_lower "${FILE_PATH}"
  done
}

####
# Uses grep to prevent using ack-grep on different machines
# Influenced by: http://developmentality.wordpress.com/2010/12/28/ack-better-than-grep/
#
# @param string pattern
# [@param] string search path
# [@param] string directory path to exclude - and following parameters
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-10-02
####
function net_bazzline_bash_grep ()
{
    grep -rI -color=auto -exclude-dir=\.bzr -exclude-dir=\.git -exclude-dir=\.hg -exclude-dir=\.svn -exclude-dir=build -exclude-dir=dist -exclude=tags "${*}"
}

#c

####
# creates a mp3 file for each mpc file in the current working directory
####
function net_bazzline_create_a_mp3_file_for_each_mpc_file_in_the_current_directory()
{
    if [[ -f /usr/bin/mpcdec ]];
    then
        #@link https://odoepner.wordpress.com/2017/01/01/convert-mpc-to-mp3-on-linux/
        for x in *.mpc; do mpcdec "${x}" - | lame -r - "${x%.mpc}.mp3"; done
    else
        echo ":: Caution"
        echo "   Nothing has been done, mpcdec is missing."
        echo "   Please install the musepack-tools."
    fi
}

function not_working:net_bazzline_convert_dvd_to_mkv()
{
    cat /mnt/VIDEO_TS/V*.VOB | ffmpeg -i - -acodec copy -scodec copy -vcodec libx264 -nostats -hide_banner -pass 2 file.x264.mkv
}

####
# burns given iso file
#
# @param string $1 - path to iso file
# @param string $2 - [optional] device to burn - default is cdrom
#
# @see
#   https://wiki.archlinux.org/index.php/Optical_disc_drive
#   https://wiki.archlinux.org/index.php/Optical_disc_drive#Burning_an_ISO_image_to_CD.2C_DVD.2C_or_BD
# @author stev leibelt
# @since 2013-02-12
####
function net_bazzline_burn ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the iso file> [<device to burn>]"

        return 1
    fi

    if [[ $# -eq 1 ]];
    then
        sudo cdrecord -v -sao dev=/dev/sr0 "${1}"
    else
        sudo cdrecord -v -sao dev=/dev/"${2}" "${1}"
    fi
}

#c

#####
# You can change $i levels by using cd $i
#
# @param mixed $1 - [optional] path where you want do change
#                       or number of directories you want to
#                       change upwards - default is $HOME
#
# @author stev leibelt
# @since 2013-01-30
####
function net_bazzline_cd ()
{
    if [[ $# -eq 0 ]];
    then 
        cd "${HOME}" || echo "Could not change into directory >>${HOME}<<."
    # Checks if value is numeric (check allowes negativ numbers too)
    # ref: https://stackoverflow.com/a/13089269
    elif [[ "${1}" == ?(-)+([[:digit:]]) ]];
    then
        # Check if we have a directory with the numeric name
        if [[ -d "${1}" ]];
        then
            \cd "${1}" || echo "Could not change into directory >>${1}<<."
        else
            local PATH_TO_GO_UP
            PATH_TO_GO_UP=""

            for (( ITERATOR=1; ITERATOR <= ${1}; ++ITERATOR ))
            do
                PATH_TO_GO_UP+="../"
            done

            \cd "${PATH_TO_GO_UP}" || echo "Could not change into directory >>${PATH_TO_GO_UP}<<."
        fi
    #is provided path a file?
    elif [[ -f "${1}" ]];
    then
        \cd "$(dirname "${1}")" || echo "Could not change into directory >>${1}<<."
    else
        \cd "${1}" || echo "Could not change into directory >>${1}<<."
    fi
}

####
# checks and defrags ext4 device
#
# @param string <path to the device>
#
# @author stev leibelt
# @since 2016-10-22
####
function net_bazzline_check_ext4_device ()
{
    if [[ $# -gt 0 ]];
    then
        DEVICE_PATH="${1}"

        sudo fsck.ext4 -yfD ${DEVICE_PATH}
        sudo sync
    else
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the device>"

        return 1
    fi
}

####
# checks and defrags ext4 device
#
# @param string <path to the device>
#
# @author stev leibelt
# @since 2017-10-24
function net_bazzline_check_fat_device ()
{
    if [[ $# -gt 0 ]];
    then
        local DEVICE_PATH

        DEVICE_PATH="${1}"

        if net_bazzline_core_ask_yes_or_no "Take the long road? (y|N)"
        then
          sudo dosfsck -w -r -l -a -v -t ${DEVICE_PATH};
        else
          sudo fsck.fat -aV ${DEVICE_PATH};
        fi

        sudo sync
    else
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the device>"

        return 1
    fi
}

####
# compress given directories into tar.gz
#
# @param string $1 - compressed tar.gz file name
# @param string $@ - [all following] files for compressed file
#
# @author stev leibelt
# @since 2013-02-02
####
function net_bazzline_compress ()
{
    if [[ $# -lt 1 ]];
    then
        echo 'No valid arguments supplied.'

        return 1
    fi

    FILENAME_TAR="${1}".tar.gz

    if [[ $# -gt 1 ]];
    then
        shift
    fi

    tar --ignore-failed-read -zcf "${FILENAME_TAR}" "$@"
}

####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2015-01-19
# @see
#   https://answers.yahoo.com/question/index?qid=20080901083928AA22hSM
#   http://askubuntu.com/questions/113188/character-encoding-problem-with-filenames-find-broken-filenames
####
function net_bazzline_convert_file_names_to_utf_8 ()
{
    if [[ $# -lt 1 ]];
    then
        echo 'usage: <command> <path> [dry-run|d]'

        return 1
    else
        local DIRECTORY_PATH
        local NEW_NAME
        local DRY_RUN

        DIRECTORY_PATH="${1}"

        if [[ $# -eq 2 ]];
        then
            case "${2}" in 
                "d")
                    DRY_RUN=1;;
                "dry-run")
                    DRY_RUN=1;;
                *)
                    DRY_RUN=0
            esac
        fi

        for name in `find ${DIRECTORY_PATH} -depth `;
        do 
            NEW_NAME=`echo ${NAME} | iconv -f ISO-8859-1 -t UTF-8` 

            if [[ ${DRY_RUN} -eq 1 ]];
            then
                `echo ${NAME} | iconv -f UTF-8 -t ISO-8859-1` 
            fi

            if [[ "${NEW_NAME}" != "${NAME}" ]];
            then 
                if [[ ${DRY_RUN} -eq 1 ]];
                then
                    echo "${NAME} => ${NEW_NAME}" 
                else
                    mv "${NAME}" "${NEW_NAME}" 
                fi
            fi 
        done 
    fi
}

####
# Converts all m4as to wav in current directory
# taken from: http://www.togaware.com/linux/survivor/Convert_m4a.html
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-07-17
####
function net_bazzline_convert_m4a_to_wav ()
{
    for i in *.m4a;
    do
        faad -f 1 -o "$i.wav" "$i"
    done
}

####
# copies content of mkv container to avi container
#
# take a look on:   http://www.cyberciti.biz/faq/bash-shell-script-function-examples/
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-11-30
####
function net_bazzline_convert_mkv_to_avi ()
{
    if [[ $# -eq 1 ]];
    then
        #export -f net_bazzline_get_name_from_filename
        local NAME_FROM_FILENAME
        local INPUT_FILE
        local OUTPUT_FILE
        local OUTPUT_FILE

        NAME_FROM_FILENAME=net_bazzline_get_name_from_filename
        INPUT_FILE="${1}";
        OUTPUT_FILE=$($NAME_FROM_FILENAME $INPUT_FILE)
        OUTPUT_FILE="${OUTPUT_FILE}.avi"
    elif [[ $# -eq 2 ]];
    then
        local INPUT_FILE
        local OUTPUT_FILE

        INPUT_FILE="${1}";
        OUTPUT_FILE="${2}";
    else
        echo "invalid number of arguments supplied"
        echo "inputfile [outputfile]"
        return 1
    fi

    ffmpeg -i "${INPUT_FILE}" -map 0 -c:v copy -c:a copy "${OUTPUT_FILE}"
}

####
# Converts all mp3s to wav in current directory
# taken from: https://wiki.archlinux.org/index.php/CD_Burning#Burning_an_audio_CD
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-07-17
####
function net_bazzline_convert_mp3_to_wav ()
{
    for i in *.mp3; 
    do 
        lame --decode "$i" "$(basename "$i" .mp3)".wav;
    done
}

function net_bazzline_convert_mp4_to_mp3 ()
{
    local SOURCE_FILE_PATH

    SOURCE_FILE_PATH='';

    if [[ ! -f /usr/bin/ffmpeg ]];
    then
        echo ":: /usr/bin/ffmpeg does not exist."

        return 1
    fi

    for SOURCE_FILE_PATH in *.mp4;
    do
        ffmpeg -i "${SOURCE_FILE_PATH}" -b:a 192K -vn "${SOURCE_FILE_PATH}.mp3"
    done
}

####
# @param string $1 - path to the source file
# @param string $2 - path to the destination file
# [@param string $3 - screen size, default is 1024x768]
####
function net_bazzline_convert_video_to_screen_size ()
{
    local PATH_TO_DESTINATION_FILE
    local PATH_TO_SOURCE_FILE
    local SCREEN_SIZE

    if [[ $# -lt 2 ]];
    then
        echo "invalid number of arguments supplied"
        echo "<path to source file> <path to destination file> [<screen size>]"
        return 1
    else
        if [[ $# -gt 2 ]];
        then
            SCREEN_SIZE="${3}"
        else
            SCREEN_SIZE="1024x768"
        fi

        PATH_TO_DESTINATION_FILE="${2}"
        PATH_TO_SOURCE_FILE="${1}"
    fi

    ffmpeg -i "${PATH_TO_SOURCE_FILE}" -map 0 -acodec copy -scodec copy -s "${SCREEN_SIZE}" -vcodec libx264 -pass 1 "${PATH_TO_DESTINATION_FILE}"
}

####
# @param string $1 - source file path
# [@param string $2 - destination file path] - if not provided, default name is source.converted264.mkv
####
function net_bazzline_convert_video_to_libx264 ()
{
    local DESTINATION_FILE_PATH
    local SOURCE_FILE_PATH

    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source> [<destination>]"

        return 1
    fi

    SOURCE_FILE_PATH="${1}"

    if [[ $# -gt 1 ]];
    then
        DESTINATION_FILE_PATH="${2}"
    else
        DESTINATION_FILE_PATH="${SOURCE_FILE_PATH}.converted264.mkv"
    fi

    if [[ -f "${DESTINATION_FILE_PATH}" ]];
    then
        echo "   Skipping file path >>${DESTINATION_FILE_PATH}<<. Exists already."
    else
        #@see
        #   https://unix.stackexchange.com/questions/36310/strange-errors-when-using-ffmpeg-in-a-loop#36411
        #   https://superuser.com/questions/555289/is-there-a-way-to-disable-or-hide-output-thrown-by-ffmpeg#555326
        #it can happen that >>-map 0<< results into an error.
        ffmpeg -i "${SOURCE_FILE_PATH}" -map 0 -acodec copy -scodec copy -vcodec libx264 -nostats -hide_banner -pass 1 "${DESTINATION_FILE_PATH}" < /dev/null
    fi
}

####
# @param string $1 - source file path
# [@param string $2 - destination file path] - if not provided, default name is source.convertedRav1e.mkv
####
function net_bazzline_convert_video_to_librav1e ()
{
    local DESTINATION_FILE_PATH
    local SOURCE_FILE_PATH

    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source> [<destination>]"

        return 1
    fi

    SOURCE_FILE_PATH="${1}"

    if [[ $# -gt 1 ]];
    then
        DESTINATION_FILE_PATH="${2}"
    else
        DESTINATION_FILE_PATH="${SOURCE_FILE_PATH}.convertedRav1e.mkv"
    fi

    if [[ -f "${DESTINATION_FILE_PATH}" ]];
    then
        echo "   Skipping file path >>${DESTINATION_FILE_PATH}<<. Exists already."
    else
        #@see
        #   https://askubuntu.com/questions/1189174/how-do-i-use-ffmpeg-and-rav1e-to-create-high-quality-av1-files
        ffmpeg -i "${SOURCE_FILE_PATH}" -map 0 -acodec copy -scodec copy -vcodec librav1e -nostats -hide_banner -qp 80 -speed 4 -tile-columns 2 -tile-rows 2 -pass 1 "${DESTINATION_FILE_PATH}" < /dev/null
    fi
}

####
# @param string $1 - source file path
# [@param string $2 - destination file path] - if not provided, default name is source.converted265.mkv
####
function net_bazzline_convert_video_to_libx265 ()
{
    local DESTINATION_FILE_PATH
    local SOURCE_FILE_PATH

    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source> [<destination>]"

        return 1
    fi

    SOURCE_FILE_PATH="${1}"

    if [[ $# -gt 1 ]];
    then
        DESTINATION_FILE_PATH="${2}"
    else
        DESTINATION_FILE_PATH="${SOURCE_FILE_PATH}.converted265.mkv"
    fi

    if [[ -f "${DESTINATION_FILE_PATH}" ]];
    then
        echo "   Skipping file path >>${DESTINATION_FILE_PATH}<<. Exists already."
    else
        #@see
        #   https://unix.stackexchange.com/questions/36310/strange-errors-when-using-ffmpeg-in-a-loop#36411
        #   https://superuser.com/questions/555289/is-there-a-way-to-disable-or-hide-output-thrown-by-ffmpeg#555326
        ffmpeg -i "${SOURCE_FILE_PATH}" -map 0 -acodec copy -scodec copy -vcodec libx265 -nostats -hide_banner -pass 1 "${DESTINATION_FILE_PATH}" < /dev/null
    fi
}

####
# Converts all wavs to mp3s in current directory
# taken from: https://www.linuxquestions.org/questions/linux-general-1/converting-m4a-to-mp3-170553/
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-07-17
####
function net_bazzline_convert_wav_to_mp3 ()
{
    for i in *.wav;
    do
        lame --replaygain-accurate -v -h -b 192 "$i" "$i.mp3";
    done
}

####
# [@param string $1 - path to search in]
# [@param string $2 - name/pattern to search for]
#
# @author stev leibelt
# @since 2016-04-10
####
function net_bazzline_count_number_of_items_in_path()
{
    local ITEM_NAME
    local NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME
    local PATH

    if [[ $# -gt 0 ]]
    then
        PATH="${1}"
    else
        PATH="."
    fi

    if [[ $# -gt 1 ]]
    then
        ITEM_NAME="${2}"
        NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME=$(find $PATH -maxdepth 1 -not -name ".*" -name "$ITEM_NAME" | wc -l)
    else
        NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME=$(find $PATH -maxdepth 1 -not -name ".*" | wc -l)
    fi

    return $NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME
}

####
# @param string <path to create>
####
function net_bazzline_create_path_or_return_error_if_path_exists_already()
{
    local PATH_TO_CREATE

    if [[ $# -lt 1 ]];
    then
        echo "Invalid number of arguments:"
        echo "    net_bazzline_create_path_or_return_error_if_path_exists_already <path to create>";
        return 1
    fi

    PATH_TO_CREATE="${1}"

    net_bazzline_delete_empty_directories "${PATH_TO_CREATE}"

    if [[ -d "${PATH_TO_CREATE}" ]];
    then
        echo "Path exist already: ${PATH_TO_CREATE}"

        return 1
    else
        net_bazzline_mkdir -p "${PATH_TO_CREATE}"
    fi
}

#d

####
# compress given directories into tar.gz
#
# @param string $1 - path to compressed tar.gz file
# @param string $2 - [optional] output path - default is name of the file
#
# @author stev leibelt
# @since 2013-02-02
####
function net_bazzline_decompress ()
{
    if [[ $# -lt 1 ]]; then
        echo 'No valid arguments supplied.'
        echo 'Try net_bazzline_decompress $nameOfCompressedFile [$pathToDecompress]'

        exit 1
    fi

    if [[ $# -eq 1 ]]; then
        tar -zxf "$1"
    else
        tar -zxf "$1" -C "$2"
    fi
}

####
# [@param string $ROOT_PATH]
# [@param int $MAX_DEPTH]
#
# @author stev leibelt
# @since 2016-12-27
####
function net_bazzline_delete_empty_directories ()
{
    #begin of default settings
    local MAX_DEPTH
    local ROOT_PATH

    MAX_DEPTH=1
    ROOT_PATH="."
    #end of default settings

    #begin of user settings
    if [[ $# -ge 1 ]];
    then
        ROOT_PATH="${1}"

        if [[ $# -ge 2 ]];
        then
            MAX_DEPTH=${2}
        fi
    fi
    #end of user settings

    if [[ -d "${ROOT_PATH}" ]];
    then
        find ${ROOT_PATH} -maxdepth ${MAX_DEPTH} -type d -empty -delete
    fi
}

####
# [@param int $MINUTES - default is 334800] - 93*60*60 = 334800, 93 days
# [@param string $NAME - default is empty]
# [@param string $ROOT_PATH - default is cwd]
# [@param int $MAX_DEPTH - default is 1]
#
# @author stev leibelt
# @since 2016-12-27
####
function net_bazzline_delete_files_older_than ()
{
  #begin of default settings
  local NAME
  local MAX_DEPTH
  local MINUTES
  local ROOT_PATH

  NAME=${2:-""}
  MAX_DEPTH=${4:-1}
  MINUTES=${1:-97200}
  ROOT_PATH=${3:-"."}
  #end of default settings

  if [[ ${NAME} == "" ]];
  then
    # -print: prints the deleted files
    find "${ROOT_PATH}" -maxdepth "${MAX_DEPTH}" -type f -mmin +"${MINUTES}" -delete -print
  else
    find "${ROOT_PATH}" -maxdepth "${MAX_DEPTH}" -name "${NAME}" -type f -mmin +"${MINUTES}" -delete -print
  fi
}

function net_bazzline_determine_filesystem_path_age ()
{
    age () { stat=$(stat --printf="%Y %F\n" "$1"); echo "The ${stat#* } '$1' is $((($(date +%s) - ${stat%% *})/60)) minutes old."; }
}

####
# Show differences between two directory paths
#
# @param string $1 - path to first path
# @param string $2 - path to second path
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-05-21
function net_bazzline_diff_two_paths ()
{
    local SECOND_PATH
    local FIRST_PATH
    local INPUT_VARIABLES_ARE_VALID

    SECOND_PATH=${2}
    FIRST_PATH=${1}
    INPUT_VARIABLES_ARE_VALID=0

    if [[ $# -eq 2 ]];
    then
        if [[ -d "${FIRST_PATH}" ]];
        then
            if [[ -d "${SECOND_PATH}" ]];
            then
                INPUT_VARIABLES_ARE_VALID=1
            fi
        fi
    fi

    if [[ ${INPUT_VARIABLES_ARE_VALID} -eq 1 ]];
    then
        diff -qr "${FIRST_PATH}" "${SECOND_PATH}" | sort
    else
        echo ":: Invalid argument provided."
        echo "   ${FUNCNAME[0]} <string: path one> <string: path two>"

        return 1;
    fi
}

#e

####
# validates if string ends with given string or not
# 
# @param string $1 - string
# @param string $2 - needle
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-01-09
####
function net_bazzline_ends_with ()
{
    if [[ $# -eq 2 ]]; 
    then
        local STRING
        local SUB_STRING
        local LENGTH_OF_SUB_STRING
        local STRING_WITH_SUB_STRING_ONLY

        STRING="$1"
        SUB_STRING="$2"
        LENGTH_OF_SUB_STRING=${#SUB_STRING}
        STRING_WITH_SUB_STRING_ONLY=${STRING: -$LENGTH_OF_SUB_STRING}

        if [[ ${STRING_WITH_SUB_STRING_ONLY} == ${SUB_STRING} ]]; 
        then
            return 0
        else
            return 1
        fi
    else
        echo "Usage: net_bazzline_string_starts_with <string> <needle>"
        return 2
    fi
}

####
# Adds "sudo" before the provided command if you are not root
#
# @param string $command_to_execute
####
function net_bazzline_execute_as_super_user_when_not_beeing_root ()
{
    if [[ $# -lt 1 ]];
    then
        echo "Invalid number of arguments provided"
        echo "${FUNCNAME[0]} <command to execute>"
        return 1
    fi

    if [[ $(whoami) == "root" ]];
    then
        $@
    else
        sudo $@
    fi
}

#f

####
# Renames and cleans a provided path to lower case
#
# @param string $1 - path to the file system object
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-12-22
# @todo
#   * avoid creating files like "foo_bar..sh" (should be "foo_bar.sh")
#   * replaced the replaced & with and not with _
####
function net_bazzline_filesystem_path_to_lower ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <file path>"

        return 1
    fi

    FILE_PATH="${1}"

    #rename 'y/A-Z/a-z/' *
    #@see:
    #   https://stackoverflow.com/questions/23816264/remove-all-special-characters-and-case-from-string-in-bash#23816607
    #   https://stackoverflow.com/a/15347915
    #   https://www.linuxquestions.org/questions/programming-9/bash-replace-all-spaces-in-file-folder-names-635821/
    FILE_PATH_CLEANED=$(echo "${FILE_PATH}" | tr -c '[:graph:]\n\r' '_' | tr '\?|!|&' '_' | tr -d '(|)|#|[|]|:|;' | tr -d "'" | tr '[:upper:]' '[:lower:]');

    if [[ "${FILE_PATH}" != "${FILE_PATH_CLEANED}" ]];
    then
        mv "${FILE_PATH}" "${FILE_PATH_CLEANED}"
    fi
}

####
# calles find with given param and type d
#
# @param string $1 - pattern your are searching for
# @param [string $2] - path to serching in, default is >>.<<
#
# @author stev leibelt
# @since 2013-03-08
####
function net_bazzline_find_directory ()
{
    if [[ $# -eq 1 ]]; then
        find . -iname "${1}" -type d 2>/dev/null
    elif [[ $# -eq 2 ]]; then
        find "${2}" -iname "${1}" -type d 2>/dev/null
    else
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <string: search pattern> [<string: path>]"

        return 1
    fi
}

####
# calles find with given param and type f
#
# @param string $1 - pattern you are searching for
# @param [string $2] - path to serching in, default is >>.<<
# @param [bool $3] - do not ignore dot files
#
# dot exclusion taken from: https://www.linuxquestions.org/questions/linux-general-1/find-and-excluding-all-hidden-directories-910578/
#
# @author stev leibelt
# @since 2013-03-08
####
function net_bazzline_find_file ()
{
    if [[ $# -eq 1 ]]; then
        find . -iname "${1}" -not -path "*/.*/*" -not -name ".*" -type f 2>/dev/null
    elif [[ $# -eq 2 ]]; then
        find "${2}"  -iname "${1}" -not -path "*/.*/*" -not -name ".*" -type f 2>/dev/null
    elif [[ $# -eq 3 ]]; then
        find "${2}" -iname "${1}" -type f 2>/dev/null
    else
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <string: search pattern> [<string: path> [<bool: do not ignore dot files>]]"

        return 1
    fi
}

#g

####
# get extension from filename
# based: http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# take also a look to:  https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
#                       http://stackoverflow.com/questions/11426590/bash-bad-substitution
#
# use it like echo $(net_bazzline_get_extension_from_filename name.extension)
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-11-30
####
function net_bazzline_get_extension_from_filename ()
{
    local EXTENSION

    if [[ $# -eq 1 ]]; then
        EXTENSION="${1#*.}"
        echo "${EXTENSION}"

        return 0
    else
        echo "invalid number of arguments supplied"
        echo "filename"

        return 1
    fi
}

####
# get filename from filepath
# based: http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# take also a look to:  https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
#                       http://stackoverflow.com/questions/3236871/how-to-return-a-string-value-from-a-bash-function
#
# use it like echo $(net_bazzline_get_filename_from_filepath my/path/to/a/file.extension)
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-11-30
####
function net_bazzline_get_filename_from_filepath ()
{
    local FILENAME

    if [[ $# -eq 1 ]]; then
        FILENAME=$(basename "$1")
        echo "${FILENAME}"

        return 0
    else
        echo "invalid number of arguments supplied"
        echo "filepath"

        return 1
    fi
}

####
# get name without extension from filename
# based: http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# take also a look to: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
#
# use it like echo $(net_bazzline_get_name_from_filename name.extension)
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-11-30
####
function net_bazzline_get_name_from_filename ()
{
    local NAME

    if [[ $# -eq 1 ]]; then
        NAME="${1%%.*}"
        echo "${NAME}"

        return 0
    else
        echo "invalid number of arguments supplied"
        echo "filename"

        return 1
    fi
}

####
# @param string $PATH_TO_THE_REPOSITORIES
# @see https://stackoverflow.com/questions/18884992/how-do-i-assign-ls-to-an-array-in-linux-bash
####
function net_bazzline_git_update_all_repositories()
{
    if [[ $# -lt 1 ]]; then
        echo 'invalid number of arguments'
        echo '    net_bazzline_git_update_all_repositories <path to the repositories>'
        return 1
    fi

    local PATH_TO_REPOSITORIES

    PATH_TO_REPOSITORIES=$(realpath $1)

    shopt -s nullglob
    array=("$PATH_TO_REPOSITORIES"/*/)
    shopt -u nullglob

    for entry in ${array[@]}; do
        if [ -d "$entry/.git" ]; then
            echo "$entry"
            cd "$entry"
            git pull
            git fetch --all --prune
            cd "$PATH_TO_REPOSITORIES1"
        else
            net_bazzline_git_update_all_repositories "$entry"
            cd "$PATH_TO_REPOSITORIES1"
        fi  
    done;

    return 0;
}

#h

####
# @param string usage
####
function net_bazzline_handle_invalid_number_of_arguments_supplied ()
{
    #no usage recording
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <usage>"

         return 1
    else
        local USAGE

        USAGE="${1}"

        echo ":: Invalid number of arguments supplied."
        echo "Usage:"
        echo "   ${USAGE}"
    fi
}

####
# adds "." to the beginning of the directory or file name
# 
# @param string $1 - file system object identifier
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-07-31
####
function net_bazzline_hide_file_system_object()
{
    if [[ $# -eq 1 ]]; then
# @todo validate if identifier is file or directory and if first character is not "."
# @todo use net_bazzline_string_starts_with
        mv "$1" ."$1"
    else
        echo "Usage: net_bazzline_unhide_directory <directory_name>"
        return 1
    fi
}

#i

####
# checks if directory is empty or not
# @param string $1 - path to the directory
# @return zero or value (unix convention, zero is ok, non zero is failure)
####
function net_bazzline_is_directory_empty ()
{
    if [[ $# -lt 1 ]];
    then
        echo "Usage: net_bazzline_is_directory_empty <path to the directory>"
        return 2;
    fi

    local PATH_TO_THE_DIRECTORY
    PATH_TO_THE_DIRECTORY="${1}"

    if [[ ! "$(ls -A $PATH_TO_THE_DIRECTORY)" ]];
    then
        return 1;
    fi
}

#l

####
# @param string $URL
#
####
# Collection of calls to display information about a given domain
#
# @author stev leibelt
# @since 2017-08-22
####
function net_bazzline_list_domain_information ()
{
    if [[ $# -ne 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <url>"

        return 1
    fi

    #@todo
    #check if the url is prefixed with https or http
    local URL
    URL="${1}"

    #just show verbose curl output
    #@link https://serverfault.com/questions/129503/save-remote-ssl-certificate-via-linux-command-line#129505
    curl -vvI ${URL}

    #show whole ssl information
    #@link https://serverfault.com/questions/661978/displaying-a-remote-ssl-certificate-details-using-cli-tools
    #@todo only do this if https is provided
    echo ""
    echo | openssl s_client -showcerts -servername ${URL} -connect ${URL}:443 2>/dev/null | openssl x509 -inform pem -noout -text

    REMHOST="${URL}"
    REMPORT=${2:-443}

    #get certificate
    #@link https://www.madboa.com/geek/openssl/#cert-retrieve
    echo ""
    echo |\
    openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 |\
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
}

####
# [@param string $ROOT_PATH]
# [@param int $MAX_DEPTH]
#
# @author stev leibelt
# @since 2016-12-01
####
function net_bazzline_list_empty_directories ()
{
    #begin of default settings
    MAX_DEPTH=1
    ROOT_PATH="."
    #end of default settings

    #begin of user settings
    if [[ $# -ge 1 ]];
    then
        ROOT_PATH="${1}"

        if [[ $# -ge 2 ]];
        then
            MAX_DEPTH=${2}
        fi
    fi
    #end of user settings

    find ${ROOT_PATH} -maxdepth ${MAX_DEPTH} -type d -empty
}
####
# [@param string $NAME - default is empty]
# [@param string $ROOT_PATH - default is cwd]
# [@param int $MINUTES - default is 60]
# [@param int $MAX_DEPTH - default is 1]
#
# @author stev leibelt
# @since 2016-12-27
####
function net_bazzline_list_files_older_than ()
{
    #begin of default settings
    local NAME
    local MAX_DEPTH
    local MINUTES
    local ROOT_PATH

    NAME=""
    MAX_DEPTH=1
    MINUTES=60
    ROOT_PATH="."
    #end of default settings

    #begin of user settings
    if [[ $# -ge 1 ]];
    then
        NAME="${1}"

        if [[ $# -ge 2 ]];
        then
            ROOT_PATH="${2}"

            if [[ $# -ge 3 ]];
            then
                MINUTES=$3

                if [[ $# -ge 4 ]];
                then
                    MAX_DEPTH=$4
                fi
            fi
        fi
    fi
    #end of user settings

    if [[ ${NAME} == "" ]];
    then
        find ${ROOT_PATH} -maxdepth ${MAX_DEPTH} -type f -mmin +${MINUTES}
    else
        find ${ROOT_PATH} -maxdepth ${MAX_DEPTH} -name "${NAME}" -type f -mmin +${MINUTES}
    fi
}

####
# [@param int $1 - number of entries to show]
#
# @author stev leibelt
# @since 2017-02-05
####
function net_bazzline_list_filesystem_items_head ()
{
    if [[ $# -eq 0 ]];
    then
        ls -hAlt | head
    else
        ls -hAlt | head -n ${1}
    fi
}

####
# [@param int $1 - number of entries to show]
#
# @author stev leibelt
# @since 2017-02-05
####
function net_bazzline_list_filesystem_items_tail ()
{
    if [[ $# -eq 0 ]];
    then
        ls -hAlt | tail
    else
        ls -hAlt | tail -n ${1}
    fi
}

####
# list groups
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-11-17
####
function net_bazzline_list_groups ()
{
    getent group | awk -F ':' '{ print $1 }' | sort
}

####
# list available interfaces
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-10-28
####
function net_bazzline_list_interfaces ()
{
    # also possible
    # ls /sys/class/net
    ip a | grep ':\ '
}

####
# list process environment
#
# @see https://ma.ttias.be/show-the-environment-variables-of-a-running-process-in-linux/
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-01-11
####
function net_bazzline_list_process_environment ()
{
    local ENVIRONMENT_FILE_PATH
    local PROCESS_ID

    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <process id>"

        return 1
    fi

    PROCESS_ID="${1}"

    ENVIRONMENT_FILE_PATH="/proc/${PROCESS_ID}/environ"

    if [[ -f "${ENVIRONMENT_FILE_PATH}" ]];
    then
        cat "${ENVIRONMENT_FILE_PATH}" | tr '\0' '\n'
    else
        echo "${ENVIRONMENT_FILE_PATH} not found."

        return 2
    fi
}

####
# @see http://superuser.com/questions/71163/how-to-find-all-soft-links-symbolic-links-in-current-directory
####
function net_bazzline_list_symbolic_links ()
{
    local SEARCH_PATH

    if [[ $# -gt 1 ]]; then
        echo "usage: <command> <path>"
        return 1
    elif [[ $# -eq 1 ]]; then
        SEARCH_PATH="${1}"
    else
        SEARCH_PATH="."
    fi

    find "$SEARCH_PATH" -type l -print0 | xargs -0 ls -ld
}

####
# list information of virtual box machine

# @param: string $1 <virtual box name or id>
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-02-03
####
function net_bazzline_virtual_box_list_information_of_machine ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <virtual box name or id>"

        return 1
    fi

    VBoxManage showvminfo ${1}
}

####
# list information of virtual box machine

# @param: string $1 <virtual box name or id>
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-09-12
####
function net_bazzline_virtual_box_list_ip_address_of_machine ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <virtual box name or id>"

        return 1
    fi

    VBoxManage guestproperty enumerate ${1} | grep -i ip
}

####
# list all bridged interfaces of virtual box machine
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-02-03
####
function net_bazzline_virtual_box_list_briged_interfaces ()
{
    VBoxManage list bridgedifs
}

####
# list all virtual box machines
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-08-17
####
function net_bazzline_virtual_box_list_all_machines ()
{
    VBoxManage list vms
}

####
# list all running virtual box machines
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-02-03
####
function net_bazzline_virtual_box_list_running_machines ()
{
    VBoxManage list runningvms
}

####
# poweroff virtual box machine
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2018-08-15
####
function net_bazzline_virtual_box_power_off_machine ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <virtual box name or id>"

        return 1
    fi

    VBoxManage controlvm ${1} poweroff
}

####
# list system users
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-11-17
####
function net_bazzline_show_system_users ()
{
    getent passwd | grep -v '/home' | awk -F ':' '{ print $1 }' | sort
}

####
# list users
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-11-17
####
function net_bazzline_list_users ()
{
    getent passwd | grep '/home' | awk -F ':' '{ print $1 }' | sort
}

####
# @param string <path to the ssh key>
# [@param int <timeout in minutes>
####
function net_bazzline_load_ssh_key_in_keychain()
{
    local PATH_TO_THE_SSH_KEY
    local TIMEOUT_IN_MINUTES

    if [[ -f /usr/bin/keychain ]];
    then
        PATH_TO_THE_SSH_KEY=${1:-${HOME}/.ssh/id_rsa}
        TIMEOUT_IN_MINUTES=${2:-${NET_BAZZLINE_REMEMBER_SSH_PASSWORD_TIMEOUT_IN_MINUTES}}

        eval $(keychain --eval --quiet --timeout ${TIMEOUT_IN_MINUTES} ${PATH_TO_THE_SSH_KEY})
    else
        echo ":: Error"
        echo "   keychain is not installed"

        return 1
    fi
}

####
# @param string <path to the luks device>
#
# @since 2018-01-13
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_luks_dump_information()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the lukes device>"

        return 1
    fi

    local PATH_TO_THE_LUKS_DEVICE

    PATH_TO_THE_LUKS_DEVICE="${1}"

    net_bazzline_execute_as_super_user_when_not_beeing_root cryptsetup luksDump ${PATH_TO_THE_LUKS_DEVICE}
}

####
# @param string <path to the luks device>
# @param string <path to the backup file>
#
# @since 2018-01-13
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_luks_header_backup()
{
    if [[ $# -lt 2 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the lukes device> <path to the backup file>"

        return 1
    fi
    local BACKUP_FILE_PATH
    local PATH_TO_THE_LUKS_DEVICE


    BACKUP_FILE_PATH="${2}"
    PATH_TO_THE_LUKS_DEVICE="${1}"

    net_bazzline_execute_as_super_user_when_not_beeing_root cryptsetup luksHeaderBackup ${PATH_TO_THE_LUKS_DEVICE} --header-backup-file "${BACKUP_FILE_PATH}.img"
}

####
# @param string <path to the luks device>
# @param string <path to the backup file>
#
# @since 2018-01-13
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_luks_header_restore()
{
    if [[ $# -lt 2 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <path to the lukes device> <path to the backup file>"

        return 1
    fi

    local BACKUP_FILE_PATH
    local PATH_TO_THE_LUKS_DEVICE

    BACKUP_FILE_PATH="${2}"
    PATH_TO_THE_LUKS_DEVICE="${1}"

    net_bazzline_execute_as_super_user_when_not_beeing_root cryptsetup luksHeaderRestore ${PATH_TO_THE_LUKS_DEVICE} --header-backup-file "${BACKUP_FILE_PATH}"
}

#m

####
# begin of webcam section
####
function net_bazzline_make_picture_via_webcam()
{
    local CURRENT_DATE_TIME
    local FILE_NAME

    if [[ -f /usr/bin/fswebcam ]];
    then
        CURRENT_DATE_TIME=$(date +'%Y_%m_%d_%H_%M_%S')
        FILE_NAME=$CURRENT_DATE_TIME'.jpg'

        /usr/bin/fswebcam -r 1920x1920 $FILE_NAME
        echo 'created '$FILE_NAME
    else
        echo 'fswebcam is not installed'

        return 1
    fi
}

#####
# If one value is given, mkdir -p plus cd is called.
# If multiple values are given. mkdir is called.
#
# @param string $# - string name of directory you want to create
#
# @author stev leibelt
# @since 2013-01-05
####
function net_bazzline_mkdir ()
{
    #check if at least one argument is supplied
    if [[ $# -eq 0 ]];
    then
        echo "No arguments supplied"

        return 1
    fi

    #if one argument is supplied, create dir and
    # change to it
    if [[ $# -eq 1 ]];
    then
      if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_WINDOWS} -eq 1 ]];
      then
        /usr/bin/mkdir -p "${1}"
      else
        /usr/bin/env mkdir -p "${1}" 
      fi

      cd "${1}"
    fi

    #if more then one argument is supplied
    # execute default mkdir
    if [[ $# -gt 1 ]];
    then
      if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_WINDOWS} -eq 1 ]];
      then
        /usr/bin/mkdir ${@}
      else
        /usr/bin/env mkdir ${@}
      fi
    fi

    return 0
}

####
# create a directory with a prefix of current date (Ymd)
#
# @param string $1 - directory name you want to create
#
# @author stev leibelt
# @since 2013-03-08
####
function net_bazzline_mkdir_prefix_with_current_date ()
{
  local CURRENT_DATE
  local DIRECTORY_NAME

  CURRENT_DATE=$(date +%Y%m%d)

  if [[ $# -ge 1 ]];
  then
    DIRECTORY_NAME="${CURRENT_DATE}_${1}"

  else
    DIRECTORY_NAME="${CURRENT_DATE}"
  fi

  net_bazzline_mkdir "${DIRECTORY_NAME}"
}

####
# create a directory with the name of the current date (Ymd)
#
# @author stev leibelt
# @since 2017-09-08
####
function net_bazzline_mkdir_with_the_name_of_the_current_date ()
{
    NAME_OF_THE_DIRECTORY=`eval date +%Y%m%d`

    net_bazzline_mkdir "${NAME_OF_THE_DIRECTORY}"
}

####
# @param string <process name>
# [@param float <refresh intervall in seconds>
#
# @author stev leibelt - inspired by luke adamczwski
# @since 2013-03-08
####
function net_bazzline_monitor_process ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source one> [<source ...>] <target>"

        return 1
    fi

    PROCESS_NAME="${1}"

    if [[ $# -gt 1 ]];
    then
        REFRESH_INTERVALL_IN_SECONDS="${2}"
    else
        REFRESH_INTERVALL_IN_SECONDS=0.5
    fi

    watch -n ${REFRESH_INTERVALL_IN_SECONDS} "pidstat -rl -C ${PROCESS_NAME} | grep -v 'pidstat'"
}

####
# @param - source one
# [@param - source two]
# @param destination
# @todo
#   support multiple sources
#   support configurable --chunk_size=, --number_of_seconds_to_wait= and --verbose
#   replace sync call with blockdev --flushbufs /dev/<device>
####
function net_bazzline_move_in_chunks()
{
    #source [source[...]] destination [--chunk_size=<int>] [--number_of_seconds_to_wait=<int>]
    #begin of input validation
    #@todo do it nicer
    if [[ $# -lt 2 ]];
    then
        echo "invalid number of arguments provided"
        #echo "usage: <command> source [source[...]] destination [--chunk_size=<int>] [--number_of_seconds_to_wait=<int>]"
        echo "usage: <command> source destination"
        return 1
    fi

    local BE_VERBOSE
    local CHUNK_SIZE
    local CURRENT_NUMBER_OF_FILESYSTEM_ITEMS
    local DESTINATION
    local NUMBER_OF_MOVED_FILESYSTEM_ITEMS
    local NUMBER_OF_SECONDS_TO_SLEEP_BETWEEN_CHUNKS
    local SOURCE

    DESTINATION="$2"
    SOURCE="$1"
    #end of input validation

    #begin of runtime dependencies
    BE_VERBOSE=0
    CHUNK_SIZE=23
    CURRENT_NUMBER_OF_FILESYSTEM_ITEMS=$(ls -A ${SOURCE} | wc -l)
    NUMBER_OF_SECONDS_TO_SLEEP_BETWEEN_CHUNKS=7
    #end of runtime dependencies

    #begin of busniess logic
    #iterate over source
    #last argument is the target
    #begin foreach souce
    #
    # NUMBER_OF_FILES_IN_SOURCE=$(ls | head -n $CHUNK_SIZE)
    # IF_DIRECTORY_IS_EMPTY=$(net_bazzline_is_directory_empty )
    # @see
    #   http://stackoverflow.com/questions/1853946/getting-the-last-argument-passed-to-a-shell-script
    #   https://duckduckgo.com/?q=bash+get+last+function+argument&ia=qa
    #   http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html
    #   getopt
    #   http://bahmanm.com/blogs/command-line-options-how-to-parse-in-bash-using-getopt
    #   http://mywiki.wooledge.org/BashFAQ/035#getopts
    #   http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
    # check if $NUMBER_OF_FILES_IN_SOURCE has entries
    #
    #   while $NUMBER_OF_FILES_IN_SOURCE -gt 0
    #       move
    #       sleep
    #       set_number_of_files_
    #end foreach souce
    if [[ ${BE_VERBOSE} -eq 1 ]];
    then
        echo "moving filesystem items from ${SOURCE} to ${DESTINATION} with a chunk size of ${CHUNK_SIZE}"
    fi

    while [[ ${CURRENT_NUMBER_OF_FILESYSTEM_ITEMS} -gt 0 ]];
    do
        NUMBER_OF_MOVED_FILESYSTEM_ITEMS=0

        for FILESYSTEM_ITEM_TO_MOVE in $(ls -A "${SOURCE}" | head -n ${CHUNK_SIZE})
        do
            #mv -v "$SOURCE/$FILESYSTEM_ITEM_TO_MOVE" "$DESTINATION"
            mv "${SOURCE}/${FILESYSTEM_ITEM_TO_MOVE}" "${DESTINATION}"

            if [[ ${BE_VERBOSE} -eq 1 ]];
            then
                ((++NUMBER_OF_MOVED_FILESYSTEM_ITEMS))
            fi
        done

        if [[ ${BE_VERBOSE} -eq 1 ]];
        then
            echo "moved ${NUMBER_OF_MOVED_FILESYSTEM_ITEMS} filesystem items, now syncing and sleeping for ${NUMBER_OF_SECONDS_TO_SLEEP_BETWEEN_CHUNKS}"
        fi

        sync
        sleep ${NUMBER_OF_SECONDS_TO_SLEEP_BETWEEN_CHUNKS}

        CURRENT_NUMBER_OF_FILESYSTEM_ITEMS=$(ls -A ${SOURCE} | wc -l)
    done
    #end of busniess logic
}

####
# @param string $zpool
# @param string $uuid
# @param string $crypto name
# [@param string $uuid]
# [@param string $crypto name]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2015-03-15
# @todo implement support for multiple uuids and crypto names, <zpool> <uuid one> <crypto name one> [<uuid two> <crypto name two>[...]]
####
function net_bazzline_mount_luks_zpool ()
{
    echo $#
    if [[ $# -lt 3 ]];
    then
        echo 'usage: <command> <zpool> <disk uuid> <crypto name> [<disk uuid> <crypto name>[...]]'
        return 1
    else
        local NAME
        local UUID
        local ZPOOL

        NAME="$3"
        UUID="$2"
        ZPOOL="$1"

        sudo cryptsetup luksOpen "/dev/disk/by-uuid/${UUID}" "${NAME}"
        sudo zpool import "${ZPOOL}"
    fi
}

####
# @param string - mount point
# @param string - user name
# @param string - host name or ip
# @param string - host mount point
# [@param string - path to the identity file]
####
function net_bazzline_mount_sshfs ()
{
  if [[ ${#} -lt 4 ]];
  then
    net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <string: mount_point> <string: user_name> <string: host_name_or_ip> <string: host_mount_point> [<string: path_to_the_identity_file>]"

    return 1
  else
    local PATH_TO_THE_IDENTITY_FILE
    local HOST_MOUNT_POINT
    local HOST_NAME_OR_IP
    local MOUNT_POINT
    local USER_NAME

    MOUNT_POINT="${1}"
    USER_NAME="${2}"
    HOST_MOUNT_POINT="${4}"
    HOST_NAME_OR_IP="${3}"
    #begin of duplicated code - remove empty path if possible
    if [[ -d ${MOUNT_POINT} ]]; 
    then
      #check if directory is not empty
      if [[ $(ls -A "${MOUNT_POINT}") ]];
      then
        echo ":: Mount point exists and is not empty."
        echo "   ${MOUNT_POINT}"

        return 2
      else
        echo ":: Mount point exists but is empty."
        echo "   Removing ${MOUNT_POINT}"

        rmdir ${MOUNT_POINT}
      fi
    fi
    #end of duplicated code - remove empty path if possible

    /usr/bin/mkdir "${MOUNT_POINT}"

    if [[ ${#} -gt 4 ]];
    then
      PATH_TO_THE_IDENTITY_FILE="${5}"

      if [[ ! -f ${PATH_TO_THE_IDENTITY_FILE} ]];
      then
        echo ":: Invalid path to the identity file provided."
        echo "   >>${PATH_TO_THE_IDENTITY_FILE}<< is not a file."

        return 3
      fi

      sshfs -o IdentitiyFile="${PATH_TO_THE_IDENTITY_FILE}" "${USER_NAME}@${HOST_NAME_OR_IP}:${HOST_MOUNT_POINT}" "${MOUNT_POINT}"
    else
      sshfs "${USER_NAME}@${HOST_NAME_OR_IP}:${HOST_MOUNT_POINT}" "${MOUNT_POINT}"
    fi
  fi
}

#o

####
# @param string $# - string name of directory you want to create
#
# @author stev leibelt
# @since 2016-04-07
####
function net_bazzline_organize_directory_content()
{
    local DIRECTORY_NAMES
    local DIRECTORY_NAME_AS_LOWERCASE
    local DIRECTORY_NAME_AS_UPPERCASE
    local LENGHT_OF_POSSIBLE_ITEM_NAME
    local LENGHT_OF_DIRECTORY_NAME
    local NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME
    local POSSIBLE_ITEM_NAMES
    local TEMPORARY_DIRECTORY_NAME

    #begin of input validation
    if [[ $# -eq 0 ]]; then
        declare -a DIRECTORY_NAMES=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z");
    else
        DIRECTORY_NAMES=( "$@" )
    fi
    #end of input validation

    #begin of declaration
    TEMPORARY_DIRECTORY_NAME="_net_bazzline_organize_directory_content_temporary"
    #end of declaration

    #begin of iteration over all provided arguments
    for DIRECTORY_NAME in "${DIRECTORY_NAMES[@]}"
    do 
        #@todo figure out why we have to implement this crazy workaround
        LENGHT_OF_DIRECTORY_NAME=${#DIRECTORY_NAME} 
        if [[ $LENGHT_OF_DIRECTORY_NAME -gt 0 ]]
        then
            #begin of declaration
            DIRECTORY_NAME_AS_LOWERCASE=$(echo "$DIRECTORY_NAME" | tr A-Z a-z)
            DIRECTORY_NAME_AS_UPPERCASE=$(echo "$DIRECTORY_NAME" | tr a-z A-Z)
            declare -a POSSIBLE_ITEM_NAMES=( "$DIRECTORY_NAME" )

            if [[ "$DIRECTORY_NAME_AS_LOWERCASE" != "$DIRECTORY_NAME" ]]
            then
                POSSIBLE_ITEM_NAMES+=( "$DIRECTORY_NAME_AS_LOWERCASE" )
            fi

            if [[ "$DIRECTORY_NAME_AS_UPPERCASE" != "$DIRECTORY_NAME" ]]
            then
                POSSIBLE_ITEM_NAMES+=( "$DIRECTORY_NAME_AS_UPPERCASE" )
            fi
            #end of declaration

            #begin of create temporary directory
            if [[ ! -d "$TEMPORARY_DIRECTORY_NAME" ]]
            then
                net_bazzline_mkdir "$TEMPORARY_DIRECTORY_NAME"
            fi
            #end of create temporary directory

            #begin of iteration over all possible argument names
            for POSSIBLE_ITEM_NAME in "${POSSIBLE_ITEM_NAMES[@]}"
            do 
                #@todo figure out why we have to implement this crazy workaround
                LENGHT_OF_POSSIBLE_ITEM_NAME=${#POSSIBLE_ITEM_NAME} 
                if [[ $LENGHT_OF_POSSIBLE_ITEM_NAME -gt 0 ]]
                then
                    NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME=$(find -maxdepth 1 -not -name ".*" -name "$POSSIBLE_ITEM_NAME?*" | wc -l)

                    #begin of moving available files into temporary directory
                    if [[ $NUMBER_OF_ENTRIES_FOR_POSSIBLE_ITEM_NAME -gt 0 ]]
                    then
                        #we found some files, so move it
                        mv "$POSSIBLE_ITEM_NAME"?* "$TEMPORARY_DIRECTORY_NAME/"
                    fi
                    #end of moving available files into temporary directory
                fi
            done
            #end of iteration over all possible argument names

            #begin of moving into real target directory
            if [[ "$(ls -A $TEMPORARY_DIRECTORY_NAME)" ]]
            then
                #directory is not empty
                if [[ ! -d "$DIRECTORY_NAME" ]]
                then
                    #create directory if it does not exist
                    net_bazzline_mkdir "$DIRECTORY_NAME"
                fi

                #move files into it final directory
                mv "$TEMPORARY_DIRECTORY_NAME"/* "$DIRECTORY_NAME"
            fi
            #end of moving into real target directory
        fi
    done
    #end of iteration over all provided arguments

    #begin of clean up
    if [[ -d "$TEMPORARY_DIRECTORY_NAME" ]]
    then
        #remove temporary directory
        rmdir "$TEMPORARY_DIRECTORY_NAME"
    fi
    #end of clean up
}

#p

####
# Starts php's built in webserver
#
# [@param string $1 - directory that should be used as target, default is public]
# [@param int $2 - port the webserver should listen on, default is 80]
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-08-21
####
function net_bazzline_php_start_internal_webserver ()
{
    local DIRECTORY
    local PORT

    if [[ $# -eq 2 ]]; then
        DIRECTORY="$1";
        PORT="$2";
    elif [[ $# -eq 1 ]]; then
        DIRECTORY="$1";
        PORT=8080;
    else
        DIRECTORY="public";
        PORT=8080;
    fi

    /bin/env php -S 0.0.0.0:"$PORT" -t "$DIRECTORY"
}

#####
# Combines ps aux and grep
#
# @param string $1 - pattern your are searching for
#
# @author stev leibelt
# @since 2013-01-30
####
function net_bazzline_psgrep ()
{
    if [[ ${#} -eq 1 ]];
    then
        #last and duplicated grep in the pipe line is just there to enable color highlighting
        ps aux | \grep -i "${1}" | \grep -v "grep -i ${1}" | \grep --color -i "${1}"
        #ps aux | \grep -i "${1}" | \grep -v "grep"
    else
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <search term>"
    fi
}

#r

####
# records function name usage
#
# @todo
#   create function to consume the collected statistics
# @author stev leibelt
# @since 2016-07-26
####
function net_bazzline_record_function_usage ()
{
    local CURRENT_DATE
    local DIRECTORY_PATH_TO_THE_STATISTICS
    local FUNCTION_NAME

    if [[ ${NET_BAZZLINE_RECORD_FUNCTION_USAGE} -eq 1 ]];
    then
        #begin of input validation
        if [[ $# -lt 1 ]];
        then
            echo "invalid number of arguments provided"
            echo "usage: net_bazzline_record_function_usage <function name>"
            return 1
        fi
        #end of input validation

        #begin of business logic
        CURRENT_DATE=$(date +"%Y-%m-%d")
        DIRECTORY_PATH_TO_THE_STATISTICS="${NET_BAZZLINE_CACHE_PATH}/shell_config"
        FUNCTION_NAME="${1}"

        if [[ ! -d "${DIRECTORY_PATH_TO_THE_STATISTICS}" ]];
        then
            net_bazzline_mkdir -p "${DIRECTORY_PATH_TO_THE_STATISTICS}"
        fi

        echo "${FUNCTION_NAME}    #${CURRENT_DATE}" >> "${DIRECTORY_PATH_TO_THE_STATISTICS}/statistics"
        #end of business logic
    fi
}

####
# refresh given interface
#
# @param string $1 - [optional] interface - default eth0
#
# @todo implement --verbose --list-interfaces
# @author stev leibelt
# @since 2013-04-30
####
function net_bazzline_refresh_interface ()
{
    local INTERFACE
    local LENGTH

    LENGTH=${#NET_BAZZLINE_INTERFACES[@]}

    if [[ ${LENGTH} -eq 0 ]];
    then
        echo 'Environment variable NET_BAZZLINE_INTERFACES not defined or empty'

        return 1
    fi

    if [[ $# -eq 0 ]];
    then
        INTERFACE=${NET_BAZZLINE_INTERFACES[0]}
    else
        for NET_BAZZLINE_INTERFACE in "${NET_BAZZLINE_INTERFACES[@]}"
        do
            if [[ "${1}" -eq ${NET_BAZZLINE_INTERFACE} ]];
            then
                INTERFACE=${1}
            fi
        done

        #set default if none is found
        INTERFACE=${INTERFACE:-$NET_BAZZLINE_INTERFACES[0]}
    fi

    sudo ip link set ${INTERFACE} down
    sudo ip link set ${INTERFACE} up
    sudo dhcpcd ${INTERFACE}
}

####
# rename a git repository locally and remotly
#
# @param string <old branch name>
# @param string <new branch name>
# [@param string <path to the repository>]
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2016-11-09
####
function net_bazzline_rename_git_branch ()
{
    if [[ $# -eq 0 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <old branch name> <new branch name> [<path to the repository>]"

        return 1
    else
        NEW_BRANCH_NAME="${2}"
        OLD_BRANCH_NAME="${1}"

        if [[ $# -gt 2 ]];
        then
            PATH_TO_THE_REPOSITORY="${3}"
        else
            PATH_TO_THE_REPOSITORY="."
        fi

        CURRENT_WORKING_DIRECTORY=$(pwd)

        cd "${PATH_TO_THE_REPOSITORY}"

        git fetch origin

        echo ":: Searching for local repository of ${OLD_BRANCH_NAME}."
        FOUND_LOCAL_BRANCHES=($(git branch -l | grep -i ${OLD_BRANCH_NAME}))
        NUMBER_OF_FOUND_LOCAL_BRANCHES=${#FOUND_LOCAL_BRANCHES[@]}

        if [[ ${NUMBER_OF_FOUND_LOCAL_BRANCHES} -eq 0 ]];
        then
            echo ":: No local repository available. Doing a checkout." 
            git checkout -b "${OLD_BRANCH_NAME}" "origin/${OLD_BRANCH_NAME}"
        else
            echo ":: Local repository available. Switching to that branch."
            git checkout "${OLD_BRANCH_NAME}"
        fi

        echo ""
        echo ":: Updating local repository with remote repository." 
        git pull origin "${OLD_BRANCH_NAME}" 

        echo ""
        echo ":: Renaming local repository from ${OLD_BRANCH_NAME} to ${NEW_BRANCH_NAME}."
        git branch -m "${OLD_BRANCH_NAME}" "${NEW_BRANCH_NAME}"

        echo ""
        echo ":: Creating new remote repository with the name ${NEW_BRANCH_NAME}."
        git push --set-upstream origin "${NEW_BRANCH_NAME}"

        echo ""
        echo ":: Deleting old remote repository with the name ${OLD_BRANCH_NAME}." 
        git push origin :"${OLD_BRANCH_NAME}"

        echo ""
        echo ":: Switching back to your current branch"
        git checkout -  

        echo ""
        if net_bazzline_core_ask_yes_or_no "Can I delete the local repository? (Y|n)" "y"
        then
            echo ":: Deleting local repository."
            git branch -D "${NEW_BRANCH_NAME}"
        fi

        cd "${CURRENT_WORKING_DIRECTORY}"
    fi
}

####
# Replaces a string in all files in given path and below
# taken from: http://www.cyberciti.biz/faq/unix-linux-replace-string-words-in-many-files/
# taken from: http://stackoverflow.com/questions/4437901/find-and-replace-string-in-a-file
# taken from: http://stackoverflow.com/questions/7450324/how-do-i-replace-a-string-with-another-string-in-all-files-below-my-current-dir
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-7-30
####
function net_bazzline_replace_string_in_files ()
{
    if [[ $# -lt 2 ]]; then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <search pattern> <replace with> [<path to search in> [<file extension>]]"

        return 1
    fi

    local DIRECTORY_PATH
    local FILTER_BY_FILE_EXTENSION
    local FILE_EXTENSION
    local PATH_TO_SERCH_IN
    local REPLACE_WITH
    local SEARCH_PATTERHN

    FILTER_BY_FILE_EXTENSION=0
    REPLACE_WITH="${2}"
    SEARCH_PATTERHN="${1}"

    if [[ $# -gt 2 ]];
    then
        PATH_TO_SERCH_IN="${3}"

        if [[ $# -gt 3 ]];
        then
            FILE_EXTENSION="${4}"
            FILTER_BY_FILE_EXTENSION=1
        fi
    else
        PATH_TO_SERCH_IN="."
    fi

    if [[ $# -eq 4 ]];
    then
        DIRECTORY_PATH="${4}"
    else
        DIRECTORY_PATH="."
    fi

    if [[ ${FILE_EXTENSION} -eq 1 ]];
    then
        find ${DIRECTPRY_PATH} -name "*.${FILE_EXTENSION}" -type f -exec sed -i "s/${SEARCH_PATTERN}/${REPLACE_WITH}/g" {} \;
    else
        find ${DIRECTPRY_PATH} -type f -exec sed -i "s/${SEARCH_PATTERN}/${REPLACE_WITH}/g" {} \;
    fi
}

####
# @param string - the command e.g. "sleep 4 && ls -halt"
# @see: https://github.com/magicmonty/bash-git-prompt/blob/master/gitprompt.sh - function async_run()
####
function net_bazzline_run_command_in_the_background ()
{
    {
        eval "$@"
    }&
}

####
# @param string - the command e.g. "sleep 4 && ls -halt"
####
function net_bazzline_run_command_quietly_in_the_background ()
{
    net_bazzline_run_command_in_the_background "$@" &> /dev/null
}

#s

####
# @param string $SEARCH_PATTERN
# [@param int $MAXIMUM_LEVELS_OF_DIRECTORY_DEPTH]
####
function net_bazzline_search_in_composer_files()
{
    local MAXIUM_LEVELS_OF_DIRECTORY_DEPTH
    local SEARCH_PATTERN

    SEARCH_PATTERN="$1"

    if [[ $# -gt 1 ]]; then
        MAXIUM_LEVELS_OF_DIRECTORY_DEPTH=$2
    else
        MAXIUM_LEVELS_OF_DIRECTORY_DEPTH=2
    fi

    for FILE_PATH in $(find -maxdepth $MAXIUM_LEVELS_OF_DIRECTORY_DEPTH -name composer.json); do
        echo "$FILE_PATH"
        cat "$FILE_PATH" | grep -i "$SEARCH_PATTERN"
    done
}

####
# @param string $SEARCH_TERM
####
function net_bazzline_search_in_journalctl_since_boot ()
{
    if [[ $# -gt 1 ]];
    then
        SEARCH_TERM="${1}"

        net_bazzline_execute_as_super_user_when_not_beeing_root "journalctl -b --no-pager | grep -i ${SEARCH_TERM}"
    else
        echo ":: Invalid number of arguments provided"
        echo "Usage"
        echo "    ${FUNCNAME[0]} <search term>"
    fi
}

####
# @param string: <ip address/range>
####
function net_bazzline_scan_network ()
{
    if [[ $# -lt 1 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <ip address/range - 192.168.0.0/24>"

        return 1
    fi

    nmap -v -sT ${1} | grep -v "host down"
}

####
# @param string $PATH_TO_SSH_KEY
# @param string $SOURCE_HOST
# @param string $SOURCE_PATH
# @param string $DESTINATION_PATH
# @todo make PATH_TO_SSH_KEY optional
####
function net_bazzline_scp_from_host()
{
    if [[ $# -eq 4 ]];
    then
        local DESTINATION_PATH
        local PATH_TO_SSH_KEY
        local SOURCE_HOST
        local SOURCE_HOST_WITHOUT_USER_AT
        local SOURCE_PATH

        DESTINATION_PATH="${4}"
        PATH_TO_SSH_KEY="${1}"
        SOURCE_HOST="${2}"
        SOURCE_PATH="${3}"

        if net_bazzline_string_contains "${SOURCE_HOST}" "@";
        then
            SOURCE_HOST_WITHOUT_USER_AT="${SOURCE_HOST#*"@"}"
        else
            SOURCE_HOST_WITHOUT_USER_AT="${SOURCE_HOST}"
        fi

        if net_bazzline_network_service_is_reachable "${SOURCE_HOST_WITHOUT_USER_AT}" "ssh"
        then
            scp -r -i ${PATH_TO_SSH_KEY} ${SOURCE_HOST}:${SOURCE_PATH} ${DESTINATION_PATH}
        else
            echo ":: Host >>${SOURCE_HOST_WITHOUT_USER_AT}<< is down or ssh is not running."
        fi
    else
        echo ':: Invalid number of arguments'
        echo '    net_bazzline_scp_from_host <path to ssh key> <source host> <source path> <destination path>'
    fi  
}

####
# @param string $PATH_TO_SSH_KEY
# @param string $DESTINATION_HOST
# @param string $SOURCE_PATH
# @param string $DESTINATION_PATH
# @todo make PATH_TO_SSH_KEY optional
####
function net_bazzline_scp_to_host()
{
    local PATH_TO_SSH_KEY
    local DESTINATION_HOST_WITHOUT_USER_AT
    local DESTINATION_HOST
    local SOURCE_PATH
    local DESTINATION_PATH

    if [[ $# -eq 4 ]];
    then
        PATH_TO_SSH_KEY="${1}"
        DESTINATION_HOST="${2}"
        SOURCE_PATH="${3}"
        DESTINATION_PATH="${4}"

        if net_bazzline_string_contains "${DESTINATION_HOST}" "@";
        then
            DESTINATION_HOST_WITHOUT_USER_AT="${DESTINATION_HOST#*"@"}"
        else
            DESTINATION_HOST_WITHOUT_USER_AT="${DESTINATION_HOST}"
        fi

        if net_bazzline_network_service_is_reachable "${DESTINATION_HOST_WITHOUT_USER_AT}" "ssh"
        then
            scp -r -i ${PATH_TO_SSH_KEY} ${SOURCE_PATH} ${DESTINATION_HOST}:${DESTINATION_PATH}
        else
            echo ":: Host >>${DESTINATION_HOST_WITHOUT_USER_AT}<< is down or ssh is not running"
        fi
    else
        echo ':: Invalid number of arguments'
        echo '    net_bazzline_scp_to_host <path to ssh key> <destination host> <source path> <destination path>'
    fi  
}

####
# Takes a screenshot
# https://wiki.archlinux.org/index.php/Screenshot
#
# @param string $1 - [optional] filename with extension
#
# @author stev leiblt <artodeto@bazzline.net>
# @since 2013-05-25
####
function net_bazzline_screenshot ()
{
    local FILENAME

    if [[ $# -eq 0 ]];
    then
        FILENAME='screenshot.jpg'
    else
        FILENAME="${1}"
    fi

    import -window root "${FILENAME}"
}


####
# [@param] <int: HIGHEST_NUMBER> - default is 99
# [@param] <int: LOWEST_NUMBER> - default is 1
# [@param] <int: NUMBER_OF_RESULTS> - default is 1
function net_bazzline_shuffle_number ()
{
  local HIGHEST_NUMBER
  local LOWEST_NUMBER
  local NUMBER_OF_RESULTS

  HIGHEST_NUMBER="${1:-99}"
  LOWEST_NUMBER="${2:-1}"
  NUMBER_OF_RESULTS="${3:-1}"

  shuf -i ${LOWEST_NUMBER}-${HIGHEST_NUMBER} -n ${NUMBER_OF_RESULTS}
}

####
# Calls grep with "-ir --color=auto --exclude=\*.svn\* --exclude=\*.git\*" and directs errors to /dev/null
# All your provided parameters are passed to grep
####
function net_bazzline_silent_grep ()
{
    if [[ -f /usr/bin/rg ]];
    then
        rg -i "$@"
    else
        if [[ $# -lt 1 ]];
        then
            grep
        else
            grep -irI --color=auto --exclude=\*.svn\* --exclude=\*.git\* --exclude=\*.idea\* "$@" 2>/dev/null
        fi
    fi
}

####
# @param string $STRING
# @param string $SEARCH
# @return int (0 true, 1 false)
#
# @usage: 
#   if net_bazzline_string_contains 'foo' 'bar'; then
#       echo 'contains'
#   else
#       echo 'does not contain'
#   fi
#
# @see:
#   https://stackoverflow.com/a/25535717
#   http://stackoverflow.com/questions/229551/string-contains-in-bash
#   http://stackoverflow.com/questions/6241256/what-is-proper-way-to-test-a-bash-function-return-value
# @author stev leibelt <artodeto@bazzline.net>
# @since 2015-11-05
####
function net_bazzline_string_contains()
{
    local CONTAINS
    local SEARCH
    local STRING

    if [[ $# -eq 2 ]];
    then
        CONTAINS=1
        SEARCH="$2"
        STRING="$1"

        case "${STRING}" in 
           *"${SEARCH}"*)
             CONTAINS=0
            ;;
        esac   

        return ${CONTAINS}
    else
        echo "invalid number of arguments"
        echo "    net_bazzline_string_contains <string> <search>"
        return 1
    fi
}

####
# validates if string starts with given string or not
# 
# @param string $1 - string
# @param string $2 - needle
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-07-31
####
function net_bazzline_string_starts_with ()
{
    local STRING
    local SUB_STRING
    local LENGTH_OF_SUB_STRING
    local STRING_WITH_SUB_STRING_ONLY

    if [[ $# -eq 2 ]];
    then
        STRING="$1"
        SUB_STRING="$2"
        LENGTH_OF_SUB_STRING=${#SUB_STRING}
        STRING_WITH_SUB_STRING_ONLY=${STRING:0:$LENGTH_OF_SUB_STRING}

        if [[ "${STRING_WITH_SUB_STRING_ONLY}" = "${SUB_STRING}" ]];
        then
            return 0
        else
            return 1
        fi
    else
        echo "Usage: net_bazzline_string_starts_with <string> <needle>"
        return 2
    fi
}

####
# use colordiff (if available)
# 
# @author stev leibelt
# @since 2014-12-09
# @see
#   http://zalas.eu/viewing-svn-diff-result-in-colors/
#   http://www.cyberciti.biz/programming/color-terminal-highlighter-for-diff-files/
####
function net_bazzline_svn_diff ()
{
    if [[ -x "/usr/bin/colordiff" ]];
    then
        svn diff "${@}" | /usr/bin/colordiff
    else
        svn diff "${@}"
    fi
}

####
# calls svn log with limit and pipes content into a grep
#
# @param string $1 - pattern / what you search for
# @param integer $2 - svn log limit
#
# @author stev leibelt
# @since 2014-11-11
####
function net_bazzline_svn_log_grep ()
{
    if [[ $# -eq 1 ]];
    then
        svn log --limit 1000 | grep -B2 "${1}"
    elif [[ $# -eq 2 ]];
    then
        svn log --limit "${2}" | grep -B2 "${1}"
    else
        echo "invalid number of arguments supplied."
        echo "Usage:"
        echo "    net_bazzline_svn_log_grep <pattern:string> [<limit:int>]"
    fi
}

#####
# Calls svn diff for two repositories.
# Call $repositoryUrlOne $repositoryUrlTwo $filePath
# Use --summarize as default, so only filenames are shown
#
# @param string $1 - first repository
# @param string $2 - second repository
# @param string $3 - path of file to diff
# [@param string $4 - if set, summarize is disabled]
#
# @author stev leibelt
# @since 2013-01-30
####
function net_bazzline_svn_repository_diff ()
{
    if [[ $# -eq 3 ]];
    then
        svn diff --summarize "${1}/${3}" "${2}/${3}"
    elif [[ $# -eq 4 ]];
    then
        svn diff "${1}/${3}" "${2}/${3}"
    else
        echo 'No valid arguments supplied'
        echo 'repositoryUrlOne repositoryUrlTwo filePath [disableSummerize]'
    fi
}

####
# Uses rsync with ssh to copy data from remote to local host
#
# @param string $1 - remote user
# @param string $2 - remote host
# @param string $3 - source path on remote host
# @param string $4 - destination path on local host
# [@param string $5 - ssh key]
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-07-05
####
function net_bazzline_sync_from_host ()
{
    local DESTINATION
    local HOST
    local KEY
    local SOURCE
    local USER

    if [[ $# -eq 4 ]]; then
        DESTINATION="$4"
        HOST="$2"
        SOURCE="$3"
        USER="$1"

        rsync -aqz -e ssh $USER@$HOST:$SOURCE $DESTINATION
    elif [[ $# -eq 5 ]]; then
        KEY="$5"
        HOST="$2"
        SOURCE="$3"
        DESTINATION="$4"
        USER="$1"

        rsync -aqz -e ssh -i $KEY $USER@$HOST:$SOURCE $DESTINATION
    else
        echo 'invalid number of variables provided'
        echo 'command user host source destination'
        return 1
    fi
}

####
# Rsync with default values
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-12-21
####
function net_bazzline_sync_to ()
{
    if [[ $# -eq 0 ]]; then
        echo 'invalid number of variables provided'
        echo 'command [source one] [source ...] target'
        return 1
    elif [[ $# -eq 1 ]]; then
        rsync -aq . "$1"
    else
        rsync -aq $@
    fi
}

####
# Uses rsync with ssh to copy data from local to remote host
#
# @param string $1 - remote user
# @param string $2 - remote host
# @param string $3 - source path on local host
# @param string $4 - destination path on remote host
# [@param string $5 - ssh key]
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-07-05
####
function net_bazzline_sync_to_host ()
{
    local USER
    local HOST
    local SOURCE
    local DESTINATION

    if [[ $# -eq 4 ]]; then
        DESTINATION="$4"
        HOST="$2"
        SOURCE="$3"
        USER="$1"

        rsync -avz -e ssh $SOURCE $USER@$HOST:$DESTINATION
    elif [[ $# -eq 5 ]]; then
        DESTINATION="$4"
        HOST="$2"
        KEY="$5"
        SOURCE="$3"
        USER="$1"

        rsync -aqz -e ssh -i $KEY $SOURCE $USER@$HOST:$DESTINATION
    else
        echo 'invalid number of variables provided'
        echo 'command user host source destination'
        return 1
    fi
}

#t

####
# creates tar archvie
#
# @param string $1 - archvie name
# @param string $@ - paths
#
# @author stev leibelt
# @since 2013-07-19
####
function net_bazzline_tar_create ()
{
    local FILENAME

    if [[ $# -lt 2 ]]; then
        echo 'No valid arguments supplied.'
        echo 'archive path1 [pathX]'

        exit 1
    fi

    FILENAME="$1"

    # remove $1
    shift

    tar -cf $FILENAME "$@"
}

####
# extract content of a tar archvie
#
# @param string $1 - archvie name
#
# @author stev leibelt
# @since 2013-07-19
####
function net_bazzline_tar_extract ()
{
    if [[ $# -eq 1 ]]; then
        tar -xf "$1"
    else
        echo 'No valid arguments supplied.'
        echo 'archive'

        exit 1
    fi
}

####
# lists content of a tar archvie
#
# @param string $1 - archvie name
#
# @author stev leibelt
# @since 2013-07-19
####
function net_bazzline_tar_list ()
{
    if [[ $# -eq 1 ]]; then
        tar -tvf "$1"
    else
        echo 'No valid arguments supplied.'
        echo 'archive'

        exit 1
    fi
}

####
# create a file with a prefix of current date (Ymd)
#
# @param string $1 - file name you want to create
#
# @author stev leibelt
# @since 2014-09-20
####
function net_bazzline_touch_with_prefix_of_current_date ()
{
  if [[ ${#} -eq 1 ]];
  then
    local CURRENT_DATE
    local FILE_NAME

    CURRENT_DATE=$(date +%Y%m%d)

    if [[ ${1:0:1} == '.' ]];
    then
      #if only a file extension is provided
      FILE_NAME="${CURRENT_DATE}${1}"
    else
      FILE_NAME="${CURRENT_DATE}_${1}"
    fi

    touch "${FILE_NAME}"
  else
    echo 'Should be called with exactly one parameter'
  fi
}

#u

####
# adds "." to the beginning of the directory or file name
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-07-31
####
function net_bazzline_unhide_file_system_object()
{
    local IDENTIFIER

    if [[ $# -eq 1 ]]; then
        IDENTIFIER="$1";
# @todo validate if identifier is file or directory and if first character is "."
# @todo use net_bazzline_string_starts_with
        #if [[ net_bazzline_string_starts_with $IDENTIFIER "." ]]; then
            mv $IDENTIFIER ${IDENTIFIER:1};
            return 0
        #else
            #echo $IDENTIFIER" has to start with ."
            #return 1
    else
        echo "Usage: net_bazzline_unhide_directory <directory_name>"
        return 1
    fi
}

####
# @param string $zpool
# @param string $crypto name
# [@param string $crypto name]
# @author stev leibelt <artodeto@bazzline.net>
# @since 2015-03-15
# @todo implement support for multiple crypto names
####
function net_bazzline_unmount_luks_zpool ()
{
    if [[ $# -lt 3 ]];
    then
        echo "usage: <command> <zpool> <crypto name> <zpool>"
        return 1
    else
        local NAME
        local ZPOOL

        NAME="$2"
        ZPOOL="$1"

        sudo zpool export "${ZPOOL}"
        sudo cryptsetup close "${NAME}"
    fi
}

####
# @param string - mount point
####
function net_bazzline_unmount_sshfs ()
{
    local MOUNT_POINT

    MOUNT_POINT="${1}"

    if [[ -d "${MOUNT_POINT}" ]];
    then

      if mountpoint -q "${MOUNT_POINT}";
      then
        umount "${MOUNT_POINT}"

        if [[ ${?} -ne 0 ]];
        then
          echo ":: Could not unmount directory >>${MOUNT_POINT}<<."

          return 1
        fi

        rmdir "${MOUNT_POINT}"

        if [[ ${?} -ne 0 ]];
        then
          echo ":: Could not remove directory >>${MOUNT_POINT}<<."
          echo "   Please check if the directory is not empty or if there is an issue with the rights."

          return 2
        fi
    else
      echo ":: Invalid mount point provided."
      echo "   >>${MOUNT_POINT}<< is not in the list provided by `mount`."

      return 4
    fi
  else
    echo ":: Invalid argument provided."
    echo "   >>${MOUNT_POINT}<< is not a directory."

    return 3
  fi
}

function net_bazzline_update_shell_configuration ()
{
    #store current working directory
    CURRENT_WORKING_DIRECTORY=$(pwd)
    #change to the repostiory
    cd ${PATH_SHELL_CONFIG}
    #update repository
    if git pull;
    then
      #reload bash environment
      source ~/.bashrc && clear
    else
      echo ":: Something went wrong while updating ..."
    fi
    #change back to the current working directory
    cd ${CURRENT_WORKING_DIRECTORY}
}

#v

function net_bazzline_update_vim_bundles_and_plugins_with_vundle()
{
    local CURRENT_WORKING_DIRECTORY
    local PATH_TO_VUNDLE

    echo "vundlevim is not available anymore :/"

    CURRENT_WORKING_DIRECTORY=$(pwd)
    PATH_TO_VUNDLE="${HOME}/.vim/bundle/Vundle.vim"

    #create directory if it does not exist
    if [[ ! -d "${PATH_TO_VUNDLE}" ]]; then
        echo ":: Vundle directory missing. Creating it ..."
        echo "   ${PATH_TO_VUNDLE}"
        net_bazzline_mkdir -p "${PATH_TO_VUNDLE}"
    fi

    #clone vundle if directory is empty
    if [[ ! "$(ls -A ${PATH_TO_VUNDLE})" ]];
    then
        echo ":: Vundle directory empty. Cloning git repository into it ..."
        git clone https://github.com/VundleVim/Vundle.vim.git "${PATH_TO_VUNDLE}"
    fi

    #install all available plugins
    vim +PluginInstall +qall && vim +BundleInstall +qall

    cd ${CURRENT_WORKING_DIRECTORY}
}

#w

####
# lists all available process listening on given port
#
# @param integer $1 - port number
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-04-07
####
function net_bazzline_what_is_listening_on_that_port()
{
    if [[ $# -eq 1 ]]; then
        netstat -tulpn | grep --color :$1
    else
        echo ":: Invalid number of arguments supplied"
        echo ""
        echo "Usage: net_bazzline_what_is_listening_on_that_port <portnumber>"
        return 1
    fi
}
