#!/bin/bash
#s

####
# @param <string: ssh string like >>ssh -i ~/.ssh/foo_bar username@>
# @param <string: <hostname or ip address>[,<hostname or ip address>[,...]]
# [@param <int: <number of retries if a host is down>] - default is 3
# [@param <int: <number seconds to wait between retries>] - default is 10
####
function net_bazzline_network_ssh_to_host
{
    local HOST_IS_ONLINE=1
    local NUMBER_OF_RETIRES_IF_HOST_IS_DOWN="${3:-3}"
    local NUMBER_OF_SECONDS_TO_WAIT_BETWEEN_RETRIES="${3:-10}"
    local SSH_COMMAND_STRING="${1}"
    local STRING_OF_HOSTS="${2}"
    local WE_WHERE_CONNECTED=1

    local CURRENT_RETRY_NUMBER=1
    local LIST_OF_HOSTS=($(echo ${STRING_OF_HOSTS} | tr "," "\n"))

    while [[ ${CURRENT_RETRY_NUMBER} -le ${NUMBER_OF_RETIRES_IF_HOST_IS_DOWN} ]]
    do
        for CURRENT_HOST in "${LIST_OF_HOSTS[@]}";
        do
            if [[ ${WE_WHERE_CONNECTED} -ne 0 ]];
            then
                if net_bazzline_network_service_is_reachable "${CURRENT_HOST}" "ssh"
                then
                    ${SSH_COMMAND_STRING}@${CURRENT_HOST}

                    local HOST_IS_ONLINE=0
                    local WE_WHERE_CONNECTED=0

                    break
                fi
            fi
        done

        if [[ ${HOST_IS_ONLINE} -eq 1 ]];
        then
            echo ":: Host with provided list >>${STRING_OF_HOSTS}<< is down or ssh is not running."
            echo "   Waiting for >>${NUMBER_OF_SECONDS_TO_WAIT_BETWEEN_RETRIES}<< seconds."
            echo "   Run [${CURRENT_RETRY_NUMBER}/${NUMBER_OF_RETIRES_IF_HOST_IS_DOWN}]."

            sleep ${NUMBER_OF_SECONDS_TO_WAIT_BETWEEN_RETRIES}s
            ((CURRENT_RETRY_NUMBER++))
        else
            CURRENT_RETRY_NUMBER=${NUMBER_OF_RETIRES_IF_HOST_IS_DOWN}
        fi
    done

    return ${HOST_IS_ONLINE}
}

