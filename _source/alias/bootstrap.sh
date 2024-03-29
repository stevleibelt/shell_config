#!/bin/bash
####
#
####
# @since 2021-01-19
# @author stev leibelt
####

function net_bazzline_shell_config_alias_bootstrap ()
{
    local PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

    #order is important
    #@todo each section should have its own bootstrap
    declare -a FILES_TO_LOAD=(
        'acpi.sh'
        'cpu.sh'
        'general.sh'
        'filesystem.sh'
        'media.sh'
        'network.sh'
        'packagemanager.sh'
        'php.sh'
        'print.sh'
        'powerstate.sh'
        'process.sh'
        'pulseaudio.sh'
        'string.sh'
        'svn.sh'
        'systemd.sh'
        'virtualbox.sh'
        'webp.sh'
        'zfs.sh'
    )

    if [[ ${NET_BAZZLINE_ZFS_IS_AVAILABLE} -eq 1 ]];
    then
        FILES_TO_LOAD+=('zfs.sh')
    fi

    if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_WINDOWS} -eq 1 ]];
    then
        FILES_TO_LOAD+=('windows.sh')
    fi

    for FILE_TO_LOAD in "${FILES_TO_LOAD[@]}";
    do
        source "${PATH_OF_THE_CURRENT_SCRIPT}/${FILE_TO_LOAD}"
    done;
}

net_bazzline_shell_config_alias_bootstrap

