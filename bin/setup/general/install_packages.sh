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
  #amd-ucode || intel-ucode
  #xf86-video-amdgpu

  #stage 2
  bash "${PATH_TO_THIS_SCRIPT}/../package_manager/yay.sh"

  #stage 3
  #use >>pacman -Qe<< to get a list of installed packages
  yay -S \ 
    acpi acpid android-tools android-udev ansible arandr archiso autorandr \
    catdoc cppcheck chromium clang composer cyanrip \ 
    dbeaver ddev-bin dmenu \ 
    element-desktop \ 
    firefox ffmpeg flameshot freeplan fwupd \ 
    gcc gcc-libs gimp git gparted glibc gvfs gvfs-mtb gvfs-smb \ 
    htop hwinfo \ 
    i3-wm i3status \
    jetbrains-toolbox jq \ 
    keepassxc \ 
    libreoffice-fresh librewolf-bin light linux-headers lm_sensors lowdown lshw lutris \ 
    make man-db man-pages man2html mesa mplayer mpv mupdf \ 
    ncdu networkmanager nextcloud-client nmap nmon ntfs-3g \ 
    okular openssh openvpn \ 
    pandoc parallel pavucontrol-qt pcmanfm podman powertop progress pulseaudio-alsa pulsemix python python-pip \ 
    qemu-full \ 
    ranger redshift rustdesk rustup rsync \ 
    screen sed signal-desktop simple-scan splint slock smartmontools smplayer sshfs steam syncthing \ 
    thunderbird \ 
    telegram-desktop tor-browser \ 
    unrar \ 
    valgrind ventoy-bin vim vlc vscodium-bin \ 
    wireguard-tools wireshark wine-staging \ 
    xdg-user-dirs xinit xorg-server xorg-apps xterm \ 
    zrepl-bin

  #stage 4
  #@todo ask
  yay -S \
    vobcopy

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
