#!/bin/bash
####
# @see: https://wiki.archlinux.org/index.php/Reflector
# @since 2018-02-01
# @author stev leibelt <artodeto@bazzline.net>
####

function _main()
{
  #bo: variable
  local PATH_TO_THIS_SCRIPT
  PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
  #eo: variable

  #begin of testing if we are on the right system
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Can not install on your system."
      echo "   Sorry dude, I can only install things on a arch linux."

      return 1
  fi

  #bo: bootstrapping
  if [[ $(type -t net_bazzline_core_ask_yes_or_no) != function ]];
  then
    source "${PATH_TO_THIS_SCRIPT}/../../../_source/function/core.sh"
  fi
  #eo: bootstrapping

  echo ":: Updating system"
  sudo pacman -Syy
  #end of testing if we are on the right system

  ##begin of test
  #bo: 20201112 - migration for old versions without priority number
  if [[ -f /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook ]];
  then
      sudo mv /etc/pacman.d/hooks/trigger_reflector_on_mirrorlist_update.hook /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook
  fi
  #bo: 20201112 - migration for old versions without priority number

  if [[ -f /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook ]];
  then
      echo ":: Reflector already configured."

      if net_bazzline_core_ask_yes_or_no "Do you want to remove the configuration file? (y|N)"
      then
          sudo rm /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook
      else
          echo "   If you want to rerun this script, remove following file:"
          echo "   /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook"

          return 1
      fi
  fi
  ##end of test

  ##begin of installation
  #@todo only install if not installed
  if [[ ! -f /usr/bin/reflector ]];
  then
      echo ":: Installing reflector"
      sudo pacman -S reflector --noconfirm
  fi
  ##end of installation

  if [[ -f /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook ]];
  then
    echo ":: Reflector is already configured."
    echo "   Starting reflector service"

    sudo systemctl start reflector.service

  else
    ##begin of setup
    echo ":: Please insert one of the following listed country names (default: Germany)."
    echo ""
    reflector --list-countries
    read COUNTRY_NAME

    COUNTRY_NAME=${COUNTRY_NAME:-'Germany'}

    echo ":: Please insert the maximum number of used servers."
    echo "   A good value is something between 50 and 200 (default: 7)."
    echo ""
    read MAXIMUM_NUMBERS_OF_SERVER_TO_USE

    MAXIMUM_NUMBERS_OF_SERVER_TO_USE=${MAXIMUM_NUMBERS_OF_SERVER_TO_USE:-7}

    if [[ ! -d /etc/pacman.d/hooks ]];
    then
        echo "   Creating path >>/etc/pacman.d/hooks<<"
        sudo /usr/bin/env mkdir -p /etc/pacman.d/hooks
    fi

    echo "   Creating file >>/etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook<<"

    sudo touch /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook

    sudo bash -c "cat > /etc/pacman.d/hooks/60-trigger_reflector_on_mirrorlist_update.hook <<DELIM
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = pacman-mirrorlist

  [Action]
  Description = Updating pacman-mirrorlist with reflector and removing pacnew...
  When = PostTransaction
  Depends = reflector
  Exec = /bin/sh -c 'systemctl start reflector.service; [ -f /etc/pacman.d/mirrorlist.pacnew ] && rm /etc/pacman.d/mirrorlist.pacnew'
  DELIM"

    echo "   Creating file >>/etc/xdg/reflector/reflector.conf<<"

    sudo bash -c "cat > /etc/xdg/reflector/reflector.conf <<DELIM
  # Reflector configuration file for the systemd service.
  #
  # Empty lines and lines beginning with \"#\" are ignored.  All other lines should
  # contain valid reflector command-line arguments. The lines are parsed with
  # Python's shlex modules so standard shell syntax should work. All arguments are
  # collected into a single argument list.
  #
  # See \"reflector --help\" for details.

  # Recommended Options

  # Set the output path where the mirrorlist will be saved (--save).
  --save /etc/pacman.d/mirrorlist

  # Select the transfer protocol (--protocol).
  --protocol https

  # Select the country (--country).
  # Consult the list of available countries with \"reflector --list-countries\" and
  # select the countries nearest to you or the ones that you trust. For example:
  --country ${COUNTRY_NAME}

  # Use only the  most recently synchronized mirrors (--latest).
  --latest ${MAXIMUM_NUMBERS_OF_SERVER_TO_USE}

  # Sort the mirrors by synchronization time (--sort).
  --sort age
  DELIM"

    echo ":: Done."
    ##end of setup
  fi
}

_main ${@}

