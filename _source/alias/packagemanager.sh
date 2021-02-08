#!/bin/bash
####
# Contains package manager dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'apt' ]];
then
    alias cal='ncal -w3 -m'
else
    alias cal='cal -w3 -m'
fi

#@todo: validate against https://wiki.archlinux.org/index.php/Pacman/Rosetta
if [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'yay' ]];
then
    alias software-check-unneeded-dependencies='yay -Qqdt'
    alias software-clean-cache='yay -Scc && echo "" && echo "removing ~/.cache/yay" && sudo rm -fr ~/.cache/yay'
    alias software-fetch='yay -G'
    alias software-fill-the-cache='yay -Sy'
    alias software-info='yay -Qi'
    alias software-install='yay -S'
    alias software-install-local='sudo pacman -U'
    alias software-list='yay -Qlm'
    if [[ -f /usr/bin/pactree ]];
    then
        alias software-list-depends-on='pactree -r'
    else
        alias software-list-depends-on='echo "pactree is missing, please install pacman-contrib!"'
    fi
    alias software-list-foreign='yay -Qmq'
    alias software-list-installed='yay -Qen' #use pacman -Qqen to create a list you can use to install like "pacman -Qqen > installed && pacman -S < installed
    alias software-list-unofficial-installed='yay -Qem'
    alias software-prepare-for-upgrade='yay -Swyu'
    alias software-remove="sudo pacman -Rsu"
    alias software-search='yay -Ss'
    alias software-search-installed='yay -Qs'
    alias software-upgrade-from-cache='yay -uu'
    if [[ ${NET_BAZZLINE_IS_LTS_KERNEL} -eq 1 ]];
    then
        #@todo implement zfs enable/disable handling
        alias software-upgrade='yay -Syuu || yay -Syuu --ignore=linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils,spl-linux-lts,spl-utils-common'
        alias software-upgrade-without-lts-kernel='yay -Syuu --ignore=linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils,spl-linux-lts,spl-utils-common'
    else
        alias software-upgrade='yay -Syuu || yay -Syuu --ignore=linux,linux-headers,zfs-linux,zfs-utils,spl-linux,spl-utils-common'
        alias software-upgrade-without-kernel='yay -Syuu --ignore=linux,linux-headers,zfs-linux,zfs-utils,spl-linux,spl-utils-common'
    fi
    alias software-repository-info='yay -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'pacman' ]];
then
    alias software-check-unneeded-dependencies='sudo pacman -Qqdt'
    alias software-clean-cache='sudo pacman -Scc'
    alias software-fetch='sudo pacman -G'
    alias software-info='sudo pacman -Qi'
    alias software-install='sudo pacman -S'
    alias software-install-local='sudo pacman -U'
    alias software-list='sudo pacman -Ql'
    if [[ -f /usr/bin/pactree ]];
    then
        alias software-list-depends-on='pactree -r'
    else
        alias software-list-depends-on='echo "pactree is missing, please install pacman-contrib!"'
    fi
    alias software-list-foreign='sudo pacman -Qmq'
    alias software-list-installed='sudo pacman -Qen'
    alias software-list-unofficial-installed='sudo pacman -Qemq'
    alias software-prepare-for-upgrade='sudo pacman -Swyu'
    alias software-remove='sudo pacman -Rsu'
    alias software-search='pacman -Ss'
    alias software-search-installed='sudo pacman -Qs'
    alias software-upgrade-from-cache='sudo pacman -u'
    if [[ ${NET_BAZZLINE_IS_LTS_KERNEL} -eq 1 ]];
    then
        alias software-upgrade='sudo pacman -Syuu || sudo pacman -Syuu --ignore=linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils,spl-linux-lts,spl-utils-common'
        alias software-upgrade-without-lts-kernel='sudo pacman -Syuu --ignore=linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils,spl-linux-lts,spl-utils-common'
    else
        alias software-upgrade='sudo pacman -Syuu || sudo pacman -Syuu --ignore=linux,linux-headers,zfs-linux,zfs-utils,spl-linux,spl-utils-common'
        alias software-upgrade-without-kernel='sudo pacman -Syuu --ignore=linux,linux-headers,zfs-linux,zfs-utils,spl-linux,spl-utils-common'
    fi
    alias software-repository-info='sudo pacman -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'apk' ]];
then
    #alias software-check-unneeded-dependencies='pacaur -Qqdt'
    alias software-clean-cache='apk cache clean'
    #alias software-fetch='pacaur -G'
    #alias software-fill-the-cache='pacaur -Sy'
    #alias software-info='pacaur -Qi'
    alias software-install='apk add '
    #alias software-install-local='sudo pacman -U'
    alias software-list='apk search -v'
    #alias software-list-foreign='pacaur -Qmq'
    alias software-list-installed='apk -vv info|sort'
    #alias software-list-unofficial-installed='pacaur -Qem'
    #alias software-prepare-for-upgrade='pacaur -Swyu'
    alias software-remove="apk del "
    alias software-search='apk search -v '
    #alias software-search-installed='pacaur -Qs'
    alias software-update='apk update'
    alias software-update-cache='apk cache -v sync'
    alias software-upgrade='apk upgrade --update-cache --available'
    #alias software-upgrade-from-cache='pacaur -uu'
    #alias software-upgrade-without-lts-kernel='pacaur -Syuu --ignore=linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils-common,spl-linux-lts,spl-utils-common'
    #alias software-repository-info='pacaur -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'apt' ]];
then
    alias poweroff='net_bazzline_execute_as_super_user_when_not_beeing_root poweroff'
    alias reboot='net_bazzline_execute_as_super_user_when_not_beeing_root reboot'
    #alias software-check-unneeded-dependencies='echo "todo"'
    alias software-clean-cache='sudo apt-get autoclean && sudo apt-get autoremove'
    alias software-dist-upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
    #alias software-fetch='echo "todo"'
    alias software-info='sudo apt-cache show'
    alias software-install='sudo apt-get install'
    alias software-install-local='sudo dpkg -i'
    alias software-list='sudo dpkg -l'
    alias software-remove='sudo apt-get remove'
    alias software-search='sudo apt-cache search'
    #alias software-search-installed='echo "todo"'
    #alias software-update='sudo apt-get update'
    alias software-upgrade='sudo apt-get update && sudo apt-get upgrade --assume-yes'
    #@see: https://debian-administration.org/article/69/Some_upgrades_show_packages_being_kept_back
    alias software-upgrade-with-new='sudo apt-get --with-new-pkgs upgrade --assume-yes'
    alias software-upgrade-to-new-version='sudo apt-get dist-upgrade --assume-yes'
    #alias software-repository-info='echo "todo"'
fi
