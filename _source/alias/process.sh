#!/bin/bash
####
# Contains process list aliases in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-10-18
####

#d
alias decreaseProcessPriority='renice -n 5 -p '

#i
alias increaseProcessPriority='renice -n -5 -p '

#l
if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_LINUX} -eq 1 ]];
then
    alias listProcessMemoryUsage=net_bazzline_process_list_memory_usage
fi
alias listProcessRuntime=net_bazzline_process_list_runtime
