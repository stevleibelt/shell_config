#!/bin/bash
#l

####
# param <string: process name>
# [param <string: process name>]
# [...]
# @see: https://opensource.com/article/21/10/memory-stats-linux-smem
####
function net_bazzline_process_list_memory_usage
{
    if [[ ! -x $(command -v smem) ]];
    then
        echo ":: smem is not installed."

        return 1
    fi

    for CURRENT_PROCESS_NAME in "${@}";
    do
        echo -n "${CURRENT_PROCESS_NAME}: " && smem -t -k -c pss -P ${CURRENT_PROCESS_NAME} | tail -n 1
    done
}

####
# [param] <int: process id>...
####
function net_bazzline_process_list_runtime
{
    if [[ $# -lt 2 ]];
    then
        local PROCESS_ID=${1:-1}
        echo ${PROCESS_ID}

        ps -p ${PROCESS_ID} -o pid,tname,state,command,etime
    else
        shift

        ps -p "$*" -o pid,tname,state,command,etime
    fi
}

#r
####
# This uses the gnu parallel property
#
# [param] string - code to execute
#
# @since 2021-02-15
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_run_in_parallel_when_available
{
    if ${NET_BAZZLINE_PARALLEL_IS_AVAILABLE} -eq 1 ]];
    then
        if [[ ${NET_BAZZLINE_NUMBER_OF_CPU_CORES} -gt 1 ]];
        then
            local NUMBER_OF_THREADS=$(expr ${NET_BAZZLINE_NUMBER_OF_CPU_CORES} - 1)
        else
            local DEFAULT_PARALLEL=1
        fi

        local NUMBER_OF_JOBS=${1:-${DEFAULT_PARALLEL}}

        if [[ ${NUMBER_OF_JOBS} -lt 1 ]];
        then
            local NUMBER_OF_JOBS=1
        fi

        parallel -P ${NUMBER_OF_JOBS} $@
    else
        ${@}
    fi
}
