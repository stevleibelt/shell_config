#!/bin/bash
####
#
####

function _ask ()
{
  read -p "> ${1} " -r
  echo
}

function _install_packages_with_pacman ()
{
  sudo pacman -S --noconfirm --needed ${@}
}

function _install_packages_with_yay ()
{
  #@see: https://github.com/Jguer/yay/issues/830
  #yay -S --clean --answerdiff=None --noconfirm ${@}
  yay --needed --noconfirm -S ${@}
}

function _main ()
{
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)

  if [[ ! -f /usr/bin/pacman ]];
  then
    echo ":: Sorry, we need pacman to work."

    return 1
  fi

  #stage 1
  echo ":: Installing core packages."
  _install_packages_with_pacman git pactree-contrib base-devel

  if lscpu | grep -iq intel;
  then
    _install_packages_with_pacman intel-ucode
  fi

  if lscpu | grep -iq amd;
  then
    _install_packages_with_pacman amd-ucode
  fi
  #xf86-video-amdgpu

  #stage 2
  echo ":: Installing yay if needed."
  bash "${PATH_TO_THIS_SCRIPT}/../package_manager/yay.sh"

  #stage 3
  #use >>pacman -Qe<< to get a list of installed packages
  echo ":: Installig software"
  echo "   Processing packages with >>a<<"
  _install_packages_with_yay acpi acpid android-tools android-udev ansible arandr archiso autorandr

  echo "   Processing packages with >>b<<"
  _install_packages_with_yay bat btop

  echo "   Processing packages with >>c<<"
  _install_packages_with_yay calc catdoc cppcheck chromium clamav clang composer cyanrip

  echo "   Processing packages with >>d<<"
  _install_packages_with_yay dbeaver ddev-bin dmenu
  
  echo "   Processing packages with >>e<<"
  _install_packages_with_yay element-desktop exfatprogs exfat-utils
  
  echo "   Processing packages with >>f<<"
  _install_packages_with_yay firefox ffmpeg flameshot freeplan fwupd
  
  echo "   Processing packages with >>g<<"
  _install_packages_with_yay gcc gcc-libs geeqie geany gimp git gparted glibc gvfs gvfs-mtb gvfs-smb
  
  echo "   Processing packages with >>h<<"
  _install_packages_with_yay hdparm htop hwinfo
  
  echo "   Processing packages with >>i<<"
  _install_packages_with_yay i3-wm i3status iw
  
  echo "   Processing packages with >>j<<"
  _install_packages_with_yay jetbrains-toolbox jq
  
  echo "   Processing packages with >>k<<"
  _install_packages_with_yay keepassxc
  
  echo "   Processing packages with >>l<<"
  _install_packages_with_yay libcoverart libdiscid libreoffice-fresh librewolf-bin light linux-headers lm_sensors lowdown lshw lutris lxterminal lynis
  
  echo "   Processing packages with >>m<<"
  _install_packages_with_yay make man-db man-pages man2html mesa mplayer mpv mupdf
  
  echo "   Processing packages with >>n<<"
  _install_packages_with_yay ncdu networkmanager nextcloud-client nm-applet nmap nmon ntfs-3g
  
  echo "   Processing packages with >>o<<"
  _install_packages_with_yay okular openssh openvpn
  
  echo "   Processing packages with >>p<<"
  _install_packages_with_yay pandoc parallel pavucontrol-qt picard pcmanfm perl-io-socket-ssl picocom plantuml podman potato powertop progress pulseaudio-alsa pulsemix python python-pip
  
  echo "   Processing packages with >>q<<"
  _install_packages_with_yay qemu-full
  
  echo "   Processing packages with >>r<<"
  _install_packages_with_yay ranger redshift rustdesk rustup rsync
  
  echo "   Processing packages with >>s<<"
  _install_packages_with_yay screen sed shelldap signal-desktop simple-scan splint slock smartmontools smplayer sshguard sshfs steam syncthing
  
  echo "   Processing packages with >>t<<"
  _install_packages_with_yay texlive-core telegram-desktop tree testdisk thunderbird tor-browser tripwire terminus-font ttf-terminus-nerd
  
  echo "   Processing packages with >>u<<"
  _install_packages_with_yay umlet unrar
  
  echo "   Processing packages with >>v<<"
  _install_packages_with_yay valgrind ventoy-bin vim vlc vscodium-bin
  
  echo "   Processing packages with >>w<<"
  _install_packages_with_yay wireguard-tools wireshark wine-staging
  
  echo "   Processing packages with >>x<<"
  _install_packages_with_yay xdg-user-dirs xorg-xinit xorg-server xorg-apps xterm
  
  echo "   Processing packages with >>z<<"
  _install_packages_with_yay zrepl-bin

  #stage 4
  ask ":: Do you want to install multimedia tools? (N|y)"
  if [[ ${REPLY} =~ ^[Yy]$ ]]
  then
    _install_packages_with_yay vobcopy
  fi

  #stage 5
  #ref: https://wiki.archlinux.org/title/List_of_games
  ask ":: Do you want to install ga,es? (N|y)"
  if [[ ${REPLY} =~ ^[Yy]$ ]]
  then
    _install_packages_with_yay widelands wesnoth cataclysm-dda 0ad 0ad-data openttd kollision liquidwar neverball veloren hedgewars ltris mari0 warmux aisleriot atanks lskat gnuchess pingus supertuxkart trigger ultimatestunts vdrift flare darkplaces quake-qrp-textures quake2 quake2-retexture ioquake3 redeclipse unrealtournament4 urbanterror rigsofrods openra 
  fi

  #stage 6
  ask ":: Do you want to install educational games? (N|y)"
  if [[ ${REPLY} =~ ^[Yy]$ ]]
  then
    _install_packages_with_yay artikulate blinken gcompris kanagram khangman tuxtype tuxmath 
  fi

  yay --clean

  #stage 5
  if [[ -f /usr/bin/zfs ]];
  then
    bash "${PATH_TO_THIS_SCRIPT}/../zfs/setup.sh"
  fi

  #stage 6
  sudo systemctl -q is-enabled acpid.service

  if [[ ${?} -eq 0 ]];
  then
    echo ":: Enabling and starting acpid.service"
    sudo systemctl enable acpid.service
    sudo systemctl start acpid.service
  fi
}

_main ${@}
