#!/bin/bash

####
# [@param string $FILE_NAME_PATTERN=*converted*]
# [@param string $WORKING_DIRECTORY_PATH=$(pwd)]
# [@param int $SIZE_THRESHOLD_LIMIT=2.7]
#
# [@flag -d     - enables dryrun]
# [@flag -v     - be verbose]
# [@flag -vv    - be more verbose]
# [@flag -vvv   - be verbosest!]
####
# @since 2018-10-04
# @author stev leibelt
####
function net_bazzline_cleanup_after_converting_files ()
{
    local IS_DRY_RUN=0;
    local LEVEL_OF_VERBOSITY=0;

    while  true;
    do
        case "${1}" in
            -d)
                IS_DRY_RUN=1
                shift
                ;;
            -v)
                LEVEL_OF_VERBOSITY=1
                shift
                ;;
            -vv)
                LEVEL_OF_VERBOSITY=2
                shift
                ;;
            -vvv)
                LEVEL_OF_VERBOSITY=3
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    local FILE_NAME_PATTERN=${1:-'*converted*'}
    local SIZE_THRESHOLD_LIMIT=${3:-2.7}
    local WORKING_DIRECTORY_PATH=${2:-$(pwd)}

    local LENGTH_OF_THE_FILE_NAME_PATTERN=${#FILE_NAME_PATTERN}

    if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
    then
        echo "Working directory path >>${WORKING_DIRECTORY_PATH}<<."
        echo "File name pattern >>${FILE_NAME_PATTERN}<<."
    fi

    if [[ -f ffmpeg2pass-0.log ]];
    then
        rm ffmpeg2pass-0.log
    fi

    find "${WORKING_DIRECTORY_PATH}" -iname "${FILE_NAME_PATTERN}" -type f -print0 | while read -d $'\0' FOUND_FILE_PATH;
    do
        if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
        then
            echo "   Found file path >>${FOUND_FILE_PATH}<<."
        fi

        #index always starts with 0
        #@todo index is just using first character
        local INDEX_OF_THE_FILE_NAME_PATTERN=$(expr index "${FOUND_FILE_PATH}" "${FILE_NAME_PATTERN}")
        if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
        then
            echo "   Index >>${INDEX_OF_THE_FILE_NAME_PATTERN}<<."
        fi
        #we just add one
        #local INDEX_OF_THE_FILE_NAME_PATTERN=$((INDEX_OF_THE_FILE_NAME_PATTERN+1))
        #echo "   Index >>${INDEX_OF_THE_FILE_NAME_PATTERN}<<."
        #and now we substract the length of pattern
        #we don't have to add the one
        local INDEX_OF_THE_FILE_NAME_PATTERN=$((INDEX_OF_THE_FILE_NAME_PATTERN+${LENGTH_OF_THE_FILE_NAME_PATTERN}))
        if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
        then
            echo "   Index >>${INDEX_OF_THE_FILE_NAME_PATTERN}<<."
        fi

        local SOURCE_FILE_PATH="${FOUND_FILE_PATH:0:-${INDEX_OF_THE_FILE_NAME_PATTERN}}"

        if [[ -f "${SOURCE_FILE_PATH}" ]];
        then
            local SIZE_OF_CONVERTED_FILE_PATH=$(stat --printf="%s" ${FOUND_FILE_PATH})
            local SIZE_OF_SOURCE_FILE_PATH=$(stat --printf="%s" ${SOURCE_FILE_PATH})

            local SIZE_COMPARED=$(calc ${SIZE_OF_SOURCE_FILE_PATH}/${SIZE_OF_CONVERTED_FILE_PATH})

            if [[ ${SIZE_COMPARED} > ${SIZE_THRESHOLD_LIMIT} ]];
            then
                echo ":: Threshold limit reached!"
                echo "   Source file size >>${SIZE_OF_SOURCE_FILE_PATH}<<."
                echo "   Converted file size >>${SIZE_OF_CONVERTED_FILE_PATH}<<."
                echo "   Size compared >>${SIZE_COMPARED}<<."
                echo "   Source file path >>${SOURCE_FILE_PATH}<<."
                echo "   Converted file path >>${FOUND_FILE_PATH}<<."
            else
                if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
                then
                    echo ":: Removing file >>${SOURCE_FILE_PATH}<<."
                fi

                if [[ ${IS_DRY_RUN} -eq 0 ]];
                then
                    rm "${SOURCE_FILE_PATH}"
                fi
            fi
        else
            if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
            then
                echo ":: Is not a file >>${SOURCE_FILE_PATH}<<."
            fi
        fi
    done;
}

####
# @param1 <string: checksum method to use>
# @param2... <string: file path>
####
function net_bazzline_filesystem_create_checksum_from_file ()
{
    local CHECKSUM_METHOD
    local CURRENT_ARGUMENT

    CHECKSUM_METHOD="${1}"
    shift 1

    for CURRENT_ARGUMENT in ${@};
    do
        if [[ -f "${CURRENT_ARGUMENT}" ]];
        then
            sha512sum "${CURRENT_ARGUMENT}" > "${CURRENT_ARGUMENT}.sha512sum"
        else
            echo "  Skipping >>${CURRENT_ARGUMENT}<< because it is not a file."
        fi
    done
}

####
# @param... <string: file path>
####
function net_bazzline_filesystem_create_sha512sum_from_file ()
{
    net_bazzline_filesystem_create_checksum_from_file "sha512sum" "${@}"
}

####
# [@param <int: NUMBER_OF_DAYS_TO_DELETE]> - Default is 14
####
function net_bazzline_filesystem_generic_empty_tmp ()
{
  local NUMBER_OF_DAYS_TO_DELETE="${1:-14}"

  if [[ -d /tmp ]];
  then
    net_bazzline_core_echo_if_be_verbose "Executing: sudo find /tmp -type f,s -atime +${NUMBER_OF_DAYS_TO_DELETE} -delete"
    sudo find /tmp -type f,s -atime +${NUMBER_OF_DAYS_TO_DELETE} -delete
  fi
}

####
# @param <string: path to the file>
#
# @see: https://opensource.com/article/21/9/sed-replace-smart-quotes
####
function net_bazzline_filesystem_generic_fix_quotes ()
{
    local PATH_TO_THE_FILE
    local SINGLEQUOTE_CHARACTER
    local DOUBLEQUOTE_CHARACTER

    PATH_TO_THE_FILE="${1}"
    SINGLEQUOTE_CHARACTER=$(echo -ne '\u2018\u2019')
    DOUBLEQUOTE_CHARACTER=$(echo -ne '\u201C\u201D')

    if [[ ! -f "${PATH_TO_THE_FILE}" ]];
    then
        echo ":: Invalid file path >>${PATH_TO_THE_FILE}<< provided."

        return 1
    fi

    sed -i -e "s/[${SINGLEQUOTE_CHARACTER}]/\'/g" -e "s/[${DOUBLEQUOTE_CHARACTER}]/\"/g" "${PATH_TO_THE_FILE}"
}

####
# @param <string: pattern to grep>
####
function net_bazzline_filesystem_ls_grep ()
{
  # shellcheck disable=SC2010
  ls -hal | grep -i "${1}"
}

####
# [@param int $NUMBER_OF_DIRECTORIES_TO_OUTPUT=20]
####
# @see
#   https://opensource.com/article/18/9/shell-dotfile
#   https://www.cyberciti.biz/faq/how-do-i-find-the-largest-filesdirectories-on-a-linuxunixbsd-filesystem/
#   https://utcc.utoronto.ca/~cks/space/blog/unix/GNUSortHOption
# @since 2018-09-06
# @author stev leibelt
function net_bazzline_filesystem_list_biggest_directories ()
{
    local NUMBER_OF_DIRECTORIES_TO_OUTPUT
    # $((input)) converts string to int
    NUMBER_OF_DIRECTORIES_TO_OUTPUT=$((${1:-20}))

    du -hsx -- * | sort -rh | head -n${NUMBER_OF_DIRECTORIES_TO_OUTPUT}
}

####
# This is only working of you have a swap space configured, else it will just display 0 KB.
#
# @see: https://www.cyberciti.biz/faq/linux-which-process-is-using-swap/
####
function net_bazzline_filesystem_list_biggest_swap_space_consumers ()
{
  local CURRENT_FILE

  for CURRENT_FILE in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' "${CURRENT_FILE}"; done | sort -k 2 -n -r | less
}

####
# [@param string $CURRENT_PATH=/]
# [@param int $NUMBER_OF_ENTRIES_TO_DISPLAY=20]
####
# @see https://www.shellhacks.com/how-to-check-inode-usage-in-linux/
# @since 2018-09-06
# @author stev leibelt
function net_bazzline_list_inodes ()
{
    local CURRENT_PATH
    local NUMBER_OF_ENTRIES_TO_DISPLAY

    CURRENT_PATH=${1:-'/'}
    NUMBER_OF_ENTRIES_TO_DISPLAY=$((${2:-'20'}))

    { find "${CURRENT_PATH}" -xdev -printf '%h\n' | sort | uniq -c | sort -rn; } 2>/dev/null | head -n ${NUMBER_OF_ENTRIES_TO_DISPLAY}
}

####
# [@param string $CURRENT_PATH=.]
####
# @since 2019-12-19
# @author stev leibelt
####
function net_bazzline_list_softlinks ()
{
  local CURRENT_PATH

  CURRENT_PATH=${1:-'.'}

  find -L "${CURRENT_PATH}" -xtype l
}

####
# @param - rsync parameters
####
function net_bazzline_rsync ()
{
  if [[ $# -lt 1 ]];
  then
    net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source> [<destination>]"

    return 1
  fi

  #@see:
  #   https://opensource.com/article/19/5/advanced-rsync
  #   https://utcc.utoronto.ca/~cks/space/blog/sysadmin/RsyncAndHardlinks
  # shellcheck disable=SC2068
  /usr/bin/rsync -caqHS --delete ${@}
}

####
# @see: https://unix.stackexchange.com/a/713647
####
function net_bazzline_filesystem_watch_for_sync ()
{
    watch -n1 'grep -E "(Dirty|Write)" /proc/meminfo; echo; ls /sys/block/ | while read device; do awk "{ print \"$device: \"  \$9 }" "/sys/block/$device/stat"; done'
}

