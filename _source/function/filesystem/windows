#!/bin/bash
####
# net_bazzline_rsync, but for windows
# 
# @param <string: source>
# @param <string: destination>
####
# @since: 20220621
# @author: stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_filesystem_windows_robocopy ()
{
    if [[ $# -ne 2 ]];
    then
        net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <source> <destination>"

        return 1
    fi

    robocopy.exe "${1}" "${2}" /Z /ZB /MIR  /R:5 /W:5 /TBD /NP
}

