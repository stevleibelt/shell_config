#!/bin/bash
####
# Contains process list aliases in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-10-18
####

#l
if [[ ${NET_BAZZLINE_OPERATION_SYSTEM} == "linux" ]];
then
    alias listProcessMemoryUsage=net_bazzline_process_list_memory_usage
fi
alias listProcessRuntime=net_bazzline_process_list_runtime
