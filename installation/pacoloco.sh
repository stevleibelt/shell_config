#!/bin/bash
####
# Installs pacoloco-git and sets it up to serve for x86_64 and arm repositories in germany.
####
# @since 2020-02-25
# @author stev leibelt <artodeto@arcor.de>
####

function install_pacoloco_if_needed() {
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
        local CURRENT_DATETIME=$(date +'%Y%m%d.%H%M')

        echo ":: Moving existing file to /etc/pacoloco.yaml.${CURRENT_DATETIME}."
        sudo mv /etc/pacoloco.yaml "/etc/pacoloco.yaml.${CURRENT_DATETIME}"
    fi

    if [[ ! -d /var/cache/pacoloco ]];
    then
        echo ":: Creating cache path /var/cache/pacoloco."

        sudo /usr/bin/mkdir -p /var/cache/pacoloco
    fi

    sudo bash -c "cat >/etc/pacoloco.yaml<<DELIM
---
echo cache_dir: /var/cache/pacoloco
port: 9129
repos:
  archlinux_x86_64:
    urls:
      # german based
      - https://packages.oth-regensburg.de/archlinux/
      - https://arch.eckner.net/archlinux/
      - https://mirror.mikrogravitation.org/archlinux/
      - https://mirror.23media.com/archlinux/
      - https://mirror.f4st.host/archlinux/
      - http://archlinux.mirror.iphh.net/
      - https://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/
      - https://arch.jensgutermuth.de/
      - https://mirror.ubrco.de/archlinux/
      - https://mirror.netcologne.de/archlinux/
      - https://ftp.halifax.rwth-aachen.de/archlinux/
      - https://mirror.metalgamer.eu/archlinux/
  archlinux_armv6h:
    urls:
      # Geo-IP based mirror selection and load balancing
      - http://mirror.archlinuxarm.org/
DELIM"

    sudo systemctl enable pacoloco.service
    sudo systemctl restart pacoloco.service

    echo ":: Do not forget to add the url of this server to the pacman mirror list."
    echo "   1.) for arm6vh"
    echo "   http://myserver:9129/repo/archlinux_\$arch/\$arch/\$repo"
    echo "   2.) for x86_64"
    echo "   http://myserver:9129/repo/archlinux_\$arch/\$repo/os\$arch"
}

install_pacoloco_if_needed
