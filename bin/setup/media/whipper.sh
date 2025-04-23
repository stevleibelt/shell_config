#!/bin/bash
####
# Installs and configures whipper
####
# ref: https://github.com/whipper-team/whipper
# @since 2025-04-23
# @author stev leibelt <artodeto@arcor.de>
####

function _install_if_needed()
{
  local PACKAGE

  PACKAGE="whipper"

  if [[ ! -f /usr/bin/pacman ]];
  then
      echo "   Aborting."
      echo "   No /usr/bin/pacman installed."

      return 10
  fi

  if [[ ! -f /usr/bin/${PACKAGE} ]];
  then
    sudo pacman -S ${PACKAGE}
  fi

  echo "   Configuring ${PACKAGE} if needed"

  if [[ ! -f ~/.config/whipper/whipper.conf ]];
    if [[ ! -d ~/media/audio/whipper ]];
    then
      /usr/bin/mkdir -p ~/media/audio/whipper
    fi

    /usr/bin/mkdir -p ~/.config/whipper

    cat > ~/.config/whipper/whipper.conf <<DELIM
# ref: https://github.com/whipper-team/whipper?tab=readme-ov-file#configuration-file-documentation
[main]
path_filter_dot = True			; replace leading dot with _
path_filter_posix = True		; replace illegal chars in *nix OSes with _
path_filter_vfat = True			; replace illegal chars in VFAT filesystems with _
path_filter_whitespace = True		; replace all whitespace chars with _
path_filter_printable = True		; replace all non printable ASCII chars with _

# command line defaults for `whipper cd rip`
[whipper.cd.rip]
unknown = True
output_directory = ~/media/audio/whipper
# Note: the format char '%' must be represented '%%'.
# Do not add inline comments with an unescaped '%' character (else an 'InterpolationSyntaxError' will occur).
track_template = %%A_-_%%d_-_%%y/%%t_-_%%a_-_%%n
disc_template = %%A_-_%%d_-_%%y/%%A_-_%%d

DELIM

    whipper drive analyze
  fi
}

_install_if_needed "${@}"

