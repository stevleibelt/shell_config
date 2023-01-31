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
  echo "   Processing packages with >>a<<"
  yay -S acpi acpid android-tools android-udev ansible arandr archiso autorandr

  echo "   Processing packages with >>c<<"
  yay -S calc catdoc cppcheck chromium clamav clang composer cyanrip

  echo "   Processing packages with >>d<<"
  yay -S dbeaver ddev-bin dmenu
  
  echo "   Processing packages with >>e<<"
  yay -S element-desktop exfatprogs exfat-utils
  
  echo "   Processing packages with >>f<<"
  yay -S firefox ffmpeg flameshot freeplan fwupd
  
  echo "   Processing packages with >>g<<"
  yay -S gcc gcc-libs geeqie geany gimp git gparted glibc gvfs gvfs-mtb gvfs-smb
  
  echo "   Processing packages with >>h<<"
  yay -S hdparm htop hwinfo
  
  echo "   Processing packages with >>i<<"
  yay -S i3-wm i3status
  
  echo "   Processing packages with >>j<<"
  yay -S jetbrains-toolbox jq
  
  echo "   Processing packages with >>k<<"
  yay -S keepassxc
  
  echo "   Processing packages with >>l<<"
  yay -S libreoffice-fresh librewolf-bin light linux-headers lm_sensors lowdown lshw lutris lynis
  
  echo "   Processing packages with >>m<<"
  yay -S make man-db man-pages man2html mesa mplayer mpv mupdf
  
  echo "   Processing packages with >>n<<"
  yay -S ncdu networkmanager nextcloud-client nmap nmon ntfs-3g
  
  echo "   Processing packages with >>o<<"
  yay -S okular openssh openvpn
  
  echo "   Processing packages with >>p<<"
  yay -S pandoc parallel pavucontrol-qt pcmanfm podman powertop progress pulseaudio-alsa pulsemix python python-pip
  
  echo "   Processing packages with >>q"
  yay -S qemu-full
  
  echo "   Processing packages with >>r<<"
  yay -S ranger redshift rustdesk rustup rsync
  
  echo "   Processing packages with >>s"
  yay -S screen sed signal-desktop simple-scan splint slock smartmontools smplayer sshguard sshfs steam syncthing
  
  echo "   Processing packages with >>t<<"
  yay -S telegram-desktop testdisk thunderbird tor-browser tripwire
  
  echo "   Processing packages with >>u<<"
  yay -S unrar
  
  echo "   Processing packages with >>v<<"
  yay -S valgrind ventoy-bin vim vlc vscodium-bin
  
  echo "   Processing packages with >>w<<"
  yay -S wireguard-tools wireshark wine-staging
  
  echo "   Processing packages with >>x<<"
  yay -S xdg-user-dirs xinit xorg-server xorg-apps xterm
  
  echo "   Processing packages with >>z<<"
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
