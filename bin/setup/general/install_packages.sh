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
    acpi acpid android-tools android-udev arandr archiso autorandr \
    cppcheck chromium clang composer cyanrip \ 
    ddev-bin dmenu \ 
    element-desktop \ 
    firefox ffmpeg flameshot fwupd \ 
    gcc gcc-libs glibc gvfs gvfs-mtb gvfs-smb git \ 
    htop hwinfo \ 
    i3-wm i3status \
    jetbrains-toolbox \ 
    keepassxc \ 
    libreoffice-fresh librewolf-bin light linux-headers lm_sensors lshw lutris \ 
    make mesa mplayer mpv mupdf \ 
    ncdu networkmanager nextcloud-client nmap nmon ntfs-3g \ 
    okular openssh \ 
    parallel pavucontrol-qt pcmanfm podman powertop progress pulseaudio-alsa pulsemix python python-pip \ 
    qemu-full \ 
    ranger redshift rsync \ 
    screen sed signal-desktop simple-scan splint slock smartmontools smplayer sshfs steam syncthing \ 
    thunderbird \ 
    telegram-desktop tor-browser \ 
    unrar \ 
    valgrind ventoy-bin vim vlc vscodium-bin \ 
    wine-staging \ 
    xinit xorg-server xorg-apps xterm \ 
    zrepl-bin

  #stage 4
  #@todo ask
  yay -S \
    vobcopy
}

_main ${@}
