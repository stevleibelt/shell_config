#!/bin/bash
########
# Configuration script for local.* files
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2022-04-12
########

function _configure_package_manager ()
{
    local FILE_PATH_TO_LOCAL_SETTING="${1}"

    #bo: check if needed
    if cat "${FILE_PATH_TO_LOCAL_SETTING}" | grep -q NET_BAZZLINE_PACKAGE_MANAGER
    then
        _echo_if_be_verbose "   >>NET_BAZZLINE_PACKAGE_MANAGER<< is configured in >>${FILE_PATH_TO_LOCAL_SETTING}<<. "

        if [[ ${IS_FORCED} -ne 1 ]];
        then
            echo ":: Do you want to overwrite it? (y|N)"
            read local YES_OR_NO
            _echo_if_be_verbose "   Won't do anything."

            return 0
        fi
    fi
    #eo: check if needed

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

    _echo_if_be_verbose "   Detected package manager >>${PACKAGE_MANAGER}<<."

    _echo_if_be_verbose "   Adding line >>NET_BAZZLINE_PACKAGE_MANAGER=\"${PACKAGE_MANAGER}\"<< to >>${FILE_PATH_TO_LOCAL_SETTING}<<."

    if [[ ${IS_DRY_RUN} -ne 1 ]];
    then
        echo "NET_BAZZLINE_PACKAGE_MANAGER=\"${PACKAGE_MANAGER}\"" >> "${FILE_PATH_TO_LOCAL_SETTING}"
    fi
    #eo: detect current package manager
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

    #bo: help
    if [[ ${SHOW_HELP} -eq 1 ]];
    then
        echo ":: Usage"
        echo "   ${0} [-f|--force] [-h|--help] [-v|--verbose]"

        exit 0
    fi
    #eo: help

    _configure_package_manager "${FILE_PATH_TO_LOCAL_SETTING}"

    cd "${CURRENT_WORKING_DIRECTORY}"
}

_main ${@}
