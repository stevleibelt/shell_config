#!/bin/bash
####
# @see:
#   https://wiki.archlinux.org/index.php/Dnsmasq
#   http://www.g-loaded.eu/2010/09/18/caching-nameserver-using-dnsmasq/
# @since 2018-02-20
# @author stev leibelt <artodeto@bazzline.net>
####

#begin of testing if we are on the right system
if [[ ! -f /usr/bin/pacman ]];
then
    echo ":: Can not install on your system."
    echo "   Sorry dude, I can only install things on a arch linux."

    exit 1
fi
#end of testing if we are on the right system

#begin of installation
if [[ ! -f /usr/bin/dnsmasq ]];
then
    echo ":: Installing package"
    sudo pacman -S dnsmasq --noconfirm
fi
#end of installation

#begin of add group and user if needed
if cat /etc/group | grep -q dnsmasq
then
    echo "   Group dnsmmasq exists already"
else
    sudo groupadd -r dnsmasq
fi

if cat /etc/passwd | grep -q dnsmasq
then
    echo "   User dnsmmasq exists already"
else
    sudo useradd -r -g dnsmasq dnsmasq
fi
#end of add group and user if needed

#begin of backup original configuration file and adapt it
if [[ -f /etc/dnsmasq.conf.dist ]];
then
    echo ":: Looks like somebody created the file /etc/dnsmasq.conf.dist already."
    echo "   I won't do anything else now."
    echo "   Please remove the file mentioned above."

    exit 2
else
    sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.dist

    sudo bash -c "cat >> /etc/dnsmasq.conf <<DELIM
####
# @see
#   http://www.g-loaded.eu/2010/09/18/caching-nameserver-using-dnsmasq/
#   https://wiki.archlinux.org/index.php/Dnsmasq
####
#begin of basic configuration
listen-address=127.0.0.1
port=53
bind-interfaces
user=dnsmasq
group=dnsmasq
pid-file=/var/run/dnsmasq.pid
#end of basic configuration

#begin of logging
#if you enable it, add it to the logrotate!
#log-facility=/var/log/dnsmasq.log
#log-queries
#end of logging

#begin of name resultion option
domain-needed
bogus-priv
no-hosts
dns-forward-max=150
cache-size=1000
#no-negcache
neg-ttl=3600
resolv-file=/etc/resolv.dnsmasq
no-poll
#end of name resultion option
DELIM"
fi
#end of backup original configuration file and adapt it

#begin of adapting dhscp if needed
if [[ -f /etc/dhcpcd.conf ]];
then
    echo ":: Updating dhcpcd.conf"

    sudo bash -c "echo 'nohook resolv.conf' >> /etc/dhcpcd.conf"
fi
#end of adapting dhscp if needed

#begin of setup systemd
sudo systemctl daemon-reload
sudo systemctl enable dnsmasq.service
sudo systemctl start dnsmasq.service
#end of setup systemd

#begin of fancy testing
if [[ -f /usr/bin/drill ]];
then
    echo ":: Lets do some testing."
    echo "   Filling the cache."

    drill archlinux.org | grep "Query time"
    drill bazzline.net | grep "Query time"

    echo "   And retry, this time, the Query time should be way smaller"

    drill archlinux.org | grep "Query time"
    drill bazzline.net | grep "Query time"
fi
#end of fancy testing
