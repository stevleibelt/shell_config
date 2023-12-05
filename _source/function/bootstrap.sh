#!/bin/bash
####
#
####
# @since 2018-06-03
# @author stev leibelt
####

function net_bazzline_shell_config_function_bootstrap ()
{
    local PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

    #order is important
    #@todo each section should have its own bootstrap
    declare -a FILES_TO_LOAD=(
      'core.sh' #has to be the first file always loaded
      'date/generic.sh'
      'device/generic.sh'
      'function.sh' 
      'filesystem/generic.sh' 
      'filesystem/luks.sh' 
      'media/audio.sh' 
      'media/book.sh'
      'media/generic.sh' 
      'media/image.sh' 
      'media/video.sh' 
      'network/generic.sh' 
      'network/ssh.sh' 
      'process/generic.sh' 
      'packagemanager/generic.sh' 
      'string/generic.sh'
    )

    if [[ ${NET_BAZZLINE_ZFS_IS_AVAILABLE} -eq 1 ]];
    then
      FILES_TO_LOAD+=('filesystem/zfs.sh')
    fi

    if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_WINDOWS} -eq 1 ]];
    then
      FILES_TO_LOAD+=('filesystem/windows.sh')
    fi

    if [[ -f /usr/bin/jq ]];
    then
      FILES_TO_LOAD+=('string/jq.sh')
    fi

    for FILE_TO_LOAD in "${FILES_TO_LOAD[@]}";
    do
      source "${PATH_OF_THE_CURRENT_SCRIPT}/${FILE_TO_LOAD}"
    done;
}

net_bazzline_shell_config_function_bootstrap

