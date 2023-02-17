#!/bin/bash
#l

####
# list available local ip address
#
# @since 2018-10-01
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_list_local_ip_address ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ -f /bin/ip ]];
    then    
        ip addr | grep 'inet' | awk '{print $2}' | cut -f 1 -d '/'
    else
        echo ":: Error"
        echo "   File >>/bin/ip<< not found."

        return 1
    fi
}

####
# @param <string: host_ip_address>
#
# @see: https://linuxhandbook.com/check-open-ports-linux/
# @since: 2022-10-18
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_network_list_open_ports ()
{
  if [[ $# -ne 1 ]];
  then
    net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <string: host_ip_address>"

    return 1
  fi

  local HOST_IP_ADDRESS="${1}"

  nc -z -v ${HOST_IP_ADDRESS} 1-65535 2>&1 | grep -v 'Connection refused'
}

#s

####
# @param <string: ip_address_or_hostname>
# @param <string: service_name>
# @return <int: 0|1> - it also returns 0 if netcat is not available
#
# @see: https://utcc.utoronto.ca/~cks/space/blog/sysadmin/LittleScriptsVII
# @since 2022-05-13
# @author stev leibelt <artodeto@bazzline.net>
####
function net_bazzline_network_service_is_reachable ()
{
    local IP_ADDRESS_OR_HOSTNAME="${1}"
    local RETURN_CODE=0
    local SERVICE_NAME="${2}"

    if [[ -f /usr/bin/netcat ]];
    then
        if netcat -z ${IP_ADDRESS_OR_HOSTNAME} ${SERVICE_NAME}
        then
            local RETURN_CODE=0
        else
            local RETURN_CODE=1
        fi
    fi

    return ${RETURN_CODE};
}

####
# @param: <string: interface_device>
# @param: <string: ssid>
# @param: <string: password>
#
# @see:
#   https://gitlab.com/dakataca/dotfiles/-/blob/dev/files/networkmanager/hostpot.sh
#   https://feeding.cloud.geek.nz/posts/sharing-wifi-connection-with-network-manager-hotspot/
####
net_bazzline_network_create_wifi_hotspot ()
{
echo ":: THIS IS WORK IN PROGRESS"
echo "   Issue is, that we create a dnsmasq error"
  local INTERFACE_DEVICE="${1}"
  local PASSWORD="${3}"
  local SSID="${2}"

  local CONNECTION_NAME="hotspot_${SSID}"

  if [[ ${#} -ne 3 ]];
  then
    net_bazzline_handle_invalid_number_of_arguments_supplied "${FUNCNAME[0]} <string: interface_device> <string: ssid> <string: password>"

    echo ":: Dumping available devices."
    nmcli device | tail -n +2 | cut -f 1 -d " "

    return 1
  fi

  if [[ ! -f /usr/bin/dnsmasq ]];
  then
    echo ":: Mandatory package not found"
    echo "   >>/usr/bin/dnsmasq<< is needed."

    return 2
  fi

  if [[ ! -f /usr/bin/nmcli ]];
  then
    echo ":: Mandatory package not found"
    echo "   >>/usr/bin/nmcli<< is needed."

    return 3
  fi
  nmcli device | cut -f 1 -d " " | grep -q ${INTERFACE_DEVICE}

  if [[ ${?} -ne 0 ]];
  then
    echo ":: Invalid device provided."
    echo "   >>${INTERFACE_DEVICE}<< does not exist."

    return 4
  fi

  nmcli connection show | grep -q ${CONNECTION_NAME}

  if [[ ${?} -eq 0 ]];
  then
    echo ":: Invalid ssid provided."
    echo "   >>${CONNECTION_NAME}<< exists already."

    return 5
  fi

  nmcli connection add \
    type wifi \
    ifname ${INTERFACE_DEVICE} \
    con-name ${CONNECTION_NAME} \
    autoconnect no \
    ssid ${SSID} \
    802-11-wireless.band bg \
    802-11-wireless.mode ap \
    ipv4.method shared \
    wifi-sec.key-mgmt wpa-psk  \
    wifi-sec.psk "${PASSWORD}"

  echo ":: Connection >>${CONNECTION_NAME}<<. created."
  echo "   nmcli connection up ${CONNECTION_NAME}"
  echo "   nmcli connection down ${CONNECTION_NAME}"
}

