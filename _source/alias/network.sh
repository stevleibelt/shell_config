#!/bin/bash

#l
alias listOpenPorts=net_bazzline_network_list_open_ports

#s
alias scanWirelessNetwork='clear; sudo iw wlp3s0 scan | grep "SSID:" | trim | sort | uniq | awk "{ print \$2 }"'

#w
if [[ -x $(command -v wget) ]];
then
  alias wgetWholeWebPage='wget -np -r -k'
fi
