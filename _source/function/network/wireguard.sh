#!/bin/bash
####
# @see: https://raw.githubusercontent.com/pivpn/pivpn/master/auto_install/install.sh
####

if [[ -f /usr/bin/wg ]];
then
    function net_bazzline_wireguard_create_key()
    {
        #@todo: ask for name or check is one is provided
        wg genkey | tee peer_A.key | wg pubkey > peer_A.pub
    }
fi
