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
  echo ":: Installing core packages."
  sudo pacman -S git pactree-contrib base-devel

  if lscpu | grep -iq intel;
  then
    sudo pacman -S intel-ucode
  fi

  if lscpu | grep -iq amd;
  then
    sudo pacman -S amd-ucode
  fi
  #xf86-video-amdgpu

  #stage 2
  echo ":: Installing yay if needed."
  bash "${PATH_TO_THIS_SCRIPT}/../package_manager/yay.sh"

  #stage 3
  #use >>pacman -Qe<< to get a list of installed packages
  echo ":: Installig software"
  echo "   a"
  yay -S acpi acpid android-tools android-udev ansible arandr archiso autorandr

  echo "   c"
  yay -S catdoc cppcheck chromium clang composer cyanrip

  echo "   d"
  yay -S dbeaver ddev-bin dmenu
  
  echo "   e"
  yay -S element-desktop
  
  echo "   f"
  yay -S firefox ffmpeg flameshot freeplan fwupd
  
  echo "   g"
  yay -S gcc gcc-libs gimp git gparted glibc gvfs gvfs-mtb gvfs-smb
  
  echo "   h"
  yay -S htop hwinfo
  
  echo "   i"
  yay -S i3-wm i3status
  
  echo "   j"
  yay -S jetbrains-toolbox jq
  
  echo "   k"
  yay -S keepassxc
  
  echo "   l"
  yay -S libreoffice-fresh librewolf-bin light linux-headers lm_sensors lowdown lshw lutris
  
  echo "   m"
  yay -S make man-db man-pages man2html mesa mplayer mpv mupdf
  
  echo "   n"
  yay -S ncdu networkmanager nextcloud-client nmap nmon ntfs-3g
  
  echo "   o"
  yay -S okular openssh openvpn
  
  echo "   p"
  yay -S pandoc parallel pavucontrol-qt pcmanfm podman powertop progress pulseaudio-alsa pulsemix python python-pip
  
  echo "   q"
  yay -S qemu-full
  
  echo "   r"
  yay -S ranger redshift rustdesk rustup rsync
  
  echo "   s"
  yay -S screen sed signal-desktop simple-scan splint slock smartmontools smplayer sshfs steam syncthing
  
  echo "   t"
  yay -S telegram-desktop thunderbird tor-browser
  
  echo "   u"
  yay -S unrar
  
  echo "   v"
  yay -S valgrind ventoy-bin vim vlc vscodium-bin
  
  echo "   w"
  yay -S wireguard-tools wireshark wine-staging
  
  echo "   x"
  yay -S xdg-user-dirs xinit xorg-server xorg-apps xterm
  
  echo "   z"
  yay -S zrepl-bin

  #stage 4
  #@todo ask
  yay -S vobcopy

  #stage 5
  if [[ -f /usr/bin/zfs ]];
  then
    bash "${PATH_TO_THIS_SCRIPT}/../zfs/setup.sh"
  fi

  #stage 6
  sudo systemctl enable acpid.service
  sudo systemctl start acpid.service
}

_main ${@}
