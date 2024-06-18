#!/bin/bash

#l
alias listOpenPorts=net_bazzline_network_list_open_ports

#w
if [[ -x $(command -v wget) ]];
then
  alias wgetWholeWebPage='wget -np -r -k'
fi
