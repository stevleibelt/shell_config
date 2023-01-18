#!/bin/bash
####
#
####

function _main () {

  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Sorry, we need pacman to work."

    return 1
  fi

  #stage 1
  sudo pacman -S git pactree-contrib base-devel

  #stage 2
  bash "${PATH_TO_THIS_SCRIPT}/../package_manager/yay.sh"

  #stage 3
  yay -S \ 
    arandr autorandr \
    cppcheck chromium clang cyanrip \ 
    ddev-bin dmenu \ 
    element-desktop \ 
    firefox ffmpeg \ 
    gvfs gvfs-mtb gvfs-smb git \ 
    i3-wm i3status \
    jetbrains-toolbox \ 
    keepassxc \ 
    libreoffice-fresh librewolf-bin lm_sensors lutris \ 
    networkmanager nextcloud-client \ 
    pcmanfm python python-pip \ 
    ranger \ 
    signal-desktop splint \ 
    thunderbird \ 
    telegram-desktop tor-browser \ 
    ventoy-bin vim vscodium-bin \ 
    xinit xorg-server xorg-apps \ 
    zrepl-bin

  #stage 4
  #@todo ask
  yay -S \
    vobcopy
}

_main ${@}
