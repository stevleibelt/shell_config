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
PACKAGES_TO_IGNORE="linux,linux-headers,zfs-linux,linux-lts,linux-lts-headers,zfs-linux-lts,zfs-utils,zfs-dkms"

if [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'paru' ]];
then
    alias software-check-unneeded-dependencies='paru -Qqdt'
    alias software-clean-cache='paru -Scc && echo "" && echo "removing ~/.cache/paru" && sudo rm -fr ~/.cache/paru'
    alias software-fetch='paru -G'
    alias software-fill-the-cache='paru -Sy'
    alias software-info='paru -Qi'
    alias software-add='paru -S'
    alias software-add-local='sudo pacman -U'
    alias software-list='paru -Qlm'
    if [[ -f /usr/bin/pactree ]];
    then
        alias software-list-depends-on='pactree -r'
    else
        alias software-list-depends-on='echo "pactree is missing, please add pacman-contrib!"'
    fi
    alias software-list-added='paru -Qen' #use pacman -Qqen to create a list you can use to add like "pacman -Qqen > added && pacman -S < added
    alias software-list-foreign='paru -Qmq'
    alias software-list-orphaned='paru -Qdtq'
    alias software-list-unofficial-adparu='paru -Qem'
    alias software-prepare-for-upgrade='paru -Swyu'
    alias software-remove="sudo pacman -Rsu"
    alias software-remove-not-needed-dependencies='sudo pacman -Rs $(paru -Qdtq)'
    alias software-search='paru -Ss'
    alias software-search-added='paru -Qs'
    alias software-upgrade-from-cache='paru -uu --skipreview'
    alias software-upgrade="net_bazzline_packagemanager_arch_linux_software_upgrade paru"
    alias software-upgrade-without-ignored-packages="net_bazzline_packagemanager_arch_linux_software_upgrade paru ${PACKAGES_TO_IGNORE}"
    alias software-repository-info='paru -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'yay' ]];
then
    alias software-check-unneeded-dependencies='yay -Qqdt'
    alias software-clean-cache='yay -Scc && echo "" && echo "removing ~/.cache/yay" && sudo rm -fr ~/.cache/yay'
    alias software-fetch='yay -G'
    alias software-fill-the-cache='yay -Sy'
    alias software-info='yay -Qi'
    alias software-add='yay -S'
    alias software-add-local='sudo pacman -U'
    alias software-list='yay -Qlm'
    if [[ -f /usr/bin/pactree ]];
    then
        alias software-list-depends-on='pactree -r'
    else
        alias software-list-depends-on='echo "pactree is missing, please add pacman-contrib!"'
    fi
    alias software-list-added='yay -Qen' #use pacman -Qqen to create a list you can use to add like "pacman -Qqen > added && pacman -S < added
    alias software-list-foreign='yay -Qmq'
    alias software-list-orphaned='yay -Qdtq'
    alias software-list-unofficial-added='yay -Qem'
    alias software-prepare-for-upgrade='yay -Swyu'
    alias software-remove="sudo pacman -Rsu"
    alias software-remove-not-needed-dependencies='sudo pacman -Rs $(yay -Qdtq)'
    alias software-search='yay -Ss'
    alias software-search-added='yay -Qs'
    alias software-upgrade-from-cache='yay -uu'
    alias software-upgrade="net_bazzline_packagemanager_arch_linux_software_upgrade yay"
    alias software-upgrade-without-ignored-packages="net_bazzline_packagemanager_arch_linux_software_upgrade yay ${PACKAGES_TO_IGNORE}"
    alias software-repository-info='yay -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'pacman' ]];
then
    alias software-check-unneeded-dependencies='sudo pacman -Qqdt'
    alias software-clean-cache='sudo pacman -Scc'
    alias software-fetch='sudo pacman -G'
    alias software-info='sudo pacman -Qi'
    alias software-add='sudo pacman -S'
    alias software-add-local='sudo pacman -U'
    alias software-list='sudo pacman -Ql'
    if [[ -f /usr/bin/pactree ]];
    then
        alias software-list-depends-on='pactree -r'
    else
        alias software-list-depends-on='echo "pactree is missing, please add pacman-contrib!"'
    fi
    alias software-list-added='sudo pacman -Qen'
    alias software-list-foreign='sudo pacman -Qmq'
    alias software-list-orphaned='yay -Qdtq'
    alias software-list-unofficial-added='sudo pacman -Qemq'
    alias software-prepare-for-upgrade='sudo pacman -Swyu'
    alias software-remove='sudo pacman -Rsu'
    alias software-remove-not-needed-dependencies='sudo pacman -Rs $(pacman -Qdtq)'
    alias software-search='pacman -Ss'
    alias software-search-added='sudo pacman -Qs'
    alias software-upgrade-from-cache='sudo pacman -u'
    alias software-upgrade="net_bazzline_packagemanager_arch_linux_software_upgrade 'sudo pacman'"
    alias software-upgrade-without-ignored-packages="net_bazzline_packagemanager_arch_linux_software_upgrade packman ${PACKAGES_TO_IGNORE}"
    alias software-repository-info='sudo pacman -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'apk' ]];
then
    #alias software-check-unneeded-dependencies='pacaur -Qqdt'
    alias software-clean-cache='apk cache clean'
    #alias software-fetch='pacaur -G'
    #alias software-fill-the-cache='pacaur -Sy'
    #alias software-info='pacaur -Qi'
    alias software-add='apk add '
    #alias software-add-local='sudo pacman -U'
    alias software-list='apk search -v'
    #alias software-list-foreign='pacaur -Qmq'
    alias software-list-added='apk -vv info|sort'
    #alias software-list-unofficial-added='pacaur -Qem'
    #alias software-prepare-for-upgrade='pacaur -Swyu'
    alias software-remove="apk del "
    alias software-search='apk search -v '
    #alias software-search-added='pacaur -Qs'
    alias software-update='apk update'
    alias software-update-cache='apk cache -v sync'
    alias software-upgrade='apk upgrade --update-cache --available'
    #alias software-upgrade-from-cache='pacaur -uu'
    #alias software-repository-info='pacaur -Si'
elif [[ ${NET_BAZZLINE_PACKAGE_MANAGER} = 'apt' ]];
then
    alias poweroff='net_bazzline_execute_as_super_user_when_not_beeing_root poweroff'
    alias reboot='net_bazzline_execute_as_super_user_when_not_beeing_root reboot'
    #alias software-check-unneeded-dependencies='echo "todo"'
    alias software-clean-cache='sudo apt-get autoclean; sudo apt --purge autoremove'
    #alias software-fetch='echo "todo"'
    alias software-info='apt-cache show'
    alias software-add='sudo apt-get install'
    alias software-add-local='sudo dpkg -i'
    alias software-list='sudo dpkg -l'
    #alias software-list-depends-on='sudo dpkg -l | grep'
    alias software-list-depends-on='sudo apt-cache depends'
    alias software-remove='sudo apt-get remove'
    alias software-search='apt-cache search'
    #alias software-search-added='echo "todo"'
    #alias software-update='sudo apt-get update'
    alias software-upgrade="net_bazzline_packagemanager_apt_software_upgrade 'sudo apt update; sudo apt full-upgrade --assume-yes; sudo apt autoclean; sudo apt --purge autoremove'"
    #alias software-repository-info='echo "todo"'
fi
