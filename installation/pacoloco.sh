#!/bin/bash
####
# Installs pacoloco-git and sets it up to serve for x86_64 and arm repositories in germany.
####
# @since 2020-02-25
# @author stev leibelt <artodeto@arcor.de>
####

if [[ ! -f /usr/bin/yay ]];
then
    echo ":: Aborting."
    echo "   No /usr/bin/yay installed."

    exit 1
fi

if [[ ! -f /usr/bin/pacoloco ]];
then
    echo ":: Installing pacoloco."

    yay -S pacoloco-git
fi

if [[ -f /etc/pacoloco.yaml ]];
then
    local CURRENT_DATETIME=$(date +'%Y%m%d.%H%M%S')

    echo ":: Moving existing file to /etc/pacoloco.yaml.${CURRENT_DATETIME}."
    sudo mv /etc/pacoloco.yaml /etc/pacoloco.yaml.${CURRENT_DATETIME}
fi

if [[ ! -d /var/cache/pacoloco ]];
then
    echo ":: Creating cache path /var/cache/pacoloco."

    sudo /usr/bin/mkdir -p /var/cache/pacoloco
fi

sudo bash -c "cat >/etc/pacoloco.yaml<<DELIM
echo cache_dir: /var/cache/pacoloco
port: 9129
repos:
  archlinux_x86_64:
    urls:
      #german based
      - https://packages.oth-regensburg.de/archlinux//os/
      - https://arch.eckner.net/archlinux//os/
      - https://mirror.mikrogravitation.org/archlinux//os/
      - https://mirror.23media.com/archlinux//os/
      - https://mirror.f4st.host/archlinux//os/
      - http://archlinux.mirror.iphh.net//os/
      - https://ftp.spline.inf.fu-berlin.de/mirrors/archlinux//os/
      - https://arch.jensgutermuth.de//os/
      - https://mirror.ubrco.de/archlinux//os/
      - https://mirror.netcologne.de/archlinux//os/
      - https://ftp.halifax.rwth-aachen.de/archlinux//os/
      - https://mirror.metalgamer.eu/archlinux//os/
 archlinux_arm:
    urls:
    ## Geo-IP based mirror selection and load balancing
      - http://mirror.archlinuxarm.org//
DELIM"

echo ":: Do not forget to add the url of this server to the pacman mirror list."
echo "   http://myserver:9129/repo/archlinux_\$arch"
