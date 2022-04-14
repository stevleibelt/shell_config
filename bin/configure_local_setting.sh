#!/bin/bash
########
# Configuration script for local.* files
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2022-04-12
########

####
# @param <string: VARIABLE_NAME>
# @param <string: VARIABLE_VALUE>
####
function _add_or_overwrite_line_in_local_setting ()
{
    #bo: variables
    local REMOVE_EXISTING_VARIABLE=0
    local VARIABLE_NAME="${1}"
    local VARIABLE_VALUE="${2}"
    #eo: variables

    #bo: is variable set already?
    if cat "${FILE_PATH_TO_LOCAL_SETTING}" | grep -q "${VARIABLE_NAME}"
    then
        _echo_if_be_verbose "   >>${VARIABLE_NAME}<< is configured in >>${FILE_PATH_TO_LOCAL_SETTING}<<. "

        if [[ ${IS_FORCED} -eq 1 ]];
        then
            local REMOVE_EXISTING_VARIABLE=1
        else
            read -p "Do you want to overwrite it with calculated value >>${VARIABLE_VALUE}<<? (y|N)" YES_OR_NO

            case ${YES_OR_NO} in
                [Yy]* )
                    local REMOVE_EXISTING_VARIABLE=1
                    ;;
                * )
                    return 0
                    ;;
            esac
        fi
    fi
    #eo: is variable set already?

    #bo: remove line if needed
    if [[ ${REMOVE_EXISTING_VARIABLE} -eq 1 ]];
    then
        _echo_if_be_verbose "   Removing line >>${VARIABLE_NAME}=<< from >>${FILE_PATH_TO_LOCAL_SETTING}<<."

        cat "${FILE_PATH_TO_LOCAL_SETTING}" | grep -v "${VARIABLE_NAME}" > "${FILE_PATH_TO_LOCAL_SETTING}"
    fi
    #eo: remove line if needed

    #bo: adding value
    if [[ ${IS_DRY_RUN} -ne 1 ]];
    then
        _echo_if_be_verbose "   Adding line >>${VARIABLE_NAME}=\"${VARIABLE_VALUE}\"<< to >>${FILE_PATH_TO_LOCAL_SETTING}<<."

        echo "${VARIABLE_NAME}=\"${VARIABLE_VALUE}\"" >> "${FILE_PATH_TO_LOCAL_SETTING}"
    else
        _echo_if_be_verbose "   Would have added line >>${VARIABLE_NAME}=\"${VARIABLE_VALUE}\"<< to >>${FILE_PATH_TO_LOCAL_SETTING}<<."
    fi
    #eo: adding value
}

function _configure_package_manager ()
{
    #bo: detect current package manager
    if [[ -f /usr/bin/pacman ]];
    then
        local PACKAGE_MANAGER="pacman"
    elif [[ -f /usr/bin/apt ]];
    then
        local PACKAGE_MANAGER="apt"
    else
        local PACKAGE_MANAGER="none"
    fi
    #bo: detect current package manager

    _add_or_overwrite_line_in_local_setting "NET_BAZZLINE_PACKAGE_MANAGER" "${PACKAGE_MANAGER}"
}

function _configure_simple_values ()
{
    #@see: https://stackoverflow.com/a/32591963
    local VARIABLE_NAME_TO_FILE_PATH=(
        #enables (1) or disables (0) acpi support
        "NET_BAZZLINE_ACPI_IS_AVAILABLE|/usr/bin/acpi"
        #enables (1) or disables (0) php support
        "NET_BAZZLINE_PHP_IS_AVAILABLE|/usr/bin/php"
        #enables (1) or disables (0) powerstate support
        "NET_BAZZLINE_POWERSTATE_IS_AVAILABLE|/sys/power/state"
        #enables (1) or disables (0) usage of parallel
        "NET_BAZZLINE_PARALLEL_IS_AVAILABLE|/usr/bin/parallel"
        #enables (1) or disables (0) pulseaudio support
        "NET_BAZZLINE_PULSEAUDIO_IS_AVAILABLE|/usr/bin/pulseaudio"
        #enables (1) or disables (0) svn support
        #@todo - still needed?
        "NET_BAZZLINE_SVN_IS_AVAILABLE|/usr/bin/svn"
        #enables (1) or disables (0) systemd support
        "NET_BAZZLINE_SYSTEMD_IS_AVAILABLE|/usr/lib/systemd"
        #enables (1) or disables (0) virtualbox support
        "NET_BAZZLINE_VIRTUALBOX_IS_AVAILABLE|/usr/bin/virtualbox"
        #enables (1) or disables (0) webp support
        "NET_BAZZLINE_WEBP_IS_AVAILABLE|/usr/include/webp"
        #enables (1) or disables (0) zfs support
        "NET_BAZZLINE_ZFS_IS_AVAILABLE|/usr/bin/zpool"
    )

    for CURRENT_ROW in "${VARIABLE_NAME_TO_FILE_PATH[@]}"
    do
        IFS=$'|' read -r CURRENT_VARIABLE_NAME CURRENT_FILE_PATH <<< "${CURRENT_ROW}"

        if [[ -x "${CURRENT_FILE_PATH}" ]];
        then
            _add_or_overwrite_line_in_local_setting "${CURRENT_VARIABLE_NAME}" 1
        else
            _add_or_overwrite_line_in_local_setting "${CURRENT_VARIABLE_NAME}" 0
        fi
    done

    #enables (1) or disables (0) zfs support
    if [[ -f /usr/bin/zpool ]];
    then
        _add_or_overwrite_line_in_local_setting NET_BAZZLINE_ZFS_IS_AVAILABLE 1
        #default zfs pool if non is provided
        NET_BAZZLINE_ZFS_DEFAULT_POOL='zpool'
        declare -a NET_BAZZLINE_ZFS_LIST_OF_POOLS_TO_SCRUB=("zpool");
    else
        _add_or_overwrite_line_in_local_setting NET_BAZZLINE_ZFS_IS_AVAILABLE 0
    fi


}

####
# @param <string: string to echo>
####
function _echo_if_be_verbose
{
    if [[ ${BE_VERBOSE} -eq 1 ]];
    then
        echo "${1}"
    fi
}

function _main ()
{
    #bo: variables
    local CURRENT_WORKING_DIRECTORY=$(pwd)
    local PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)

    local PROJECT_ROOT_PATH="${PATH_TO_THIS_SCRIPT}/.."

    local FILE_PATH_TO_LOCAL_SETTING="${PROJECT_ROOT_PATH}/local.setting"
    #eo: variables

    #bo: user input
    local BE_VERBOSE=0
    local IS_DRY_RUN=0
    local IS_FORCED=0
    local SHOW_HELP=0

    while true;
    do
        case "${1}" in
            "-d" | "--dry-run" )
                IS_DRY_RUN=1
                shift 1
                ;;
            "-f" | "--force" )
                IS_FORCED=1
                shift 1
                ;;
            "-h" | "--help" )
                SHOW_HELP=1
                shift 1
                ;;
            "-v" | "--verbose" )
                BE_VERBOSE=1
                shift 1
                ;;
            * )
                break
                ;;
        esac
    done
    #eo: user input

    #bo: verbose output
    if [[ ${BE_VERBOSE} -eq 1 ]];
    then
        echo ":: Dumping variables"
        echo "   CURRENT_WORKING_DIRECTORY: >>${CURRENT_WORKING_DIRECTORY}<<."
        echo "   PATH_TO_THIS_SCRIPT: >>${PATH_TO_THIS_SCRIPT}<<."
        echo "   PROJECT_ROOT_PATH: >>${PROJECT_ROOT_PATH}<<."
        echo "   FILE_PATH_TO_LOCAL_SETTING: >>${FILE_PATH_TO_LOCAL_SETTING}<<."
        echo "   BE_VERBOSE: >>${BE_VERBOSE}<<."
        echo "   IS_DRY_RUN: >>${IS_DRY_RUN}<<."
        echo "   IS_FORCED: >>${IS_FORCED}<<."
        echo "   SHOW_HELP: >>${SHOW_HELP}<<."
        echo ""
    fi
    #eo: verbose output

    #bo: help
    if [[ ${SHOW_HELP} -eq 1 ]];
    then
        echo ":: Usage"
        echo "   ${0} [-f|--force] [-h|--help] [-v|--verbose]"

        exit 0
    fi
    #eo: help

    _configure_package_manager
    _configure_simple_values

    cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
