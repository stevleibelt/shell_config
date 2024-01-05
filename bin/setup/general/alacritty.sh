#!/bin/bash
####
# Installs and configures alacritty
####
# @see
#   https://github.com/alacritty/alacritty-theme
#   https://github.com/alacritty/alacritty
# @since 2024-01-05
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/alacritty ]];
  then
      echo ":: Alacritty is installed already"
  else
      sudo pacman -S alacritty
  fi

  if [[ -d "${HOME}/.config/alacritty/themes/" ]];
  then
    echo "   Themes directory already created"
    cd "${HOME}/.config/alacritty/themes/" || echo ":: Error: could not create themes directory." && return
    git pull
    cd - || echo ":: Error: Could not change back to previous pwd." && return
  else
    echo "   Creating themes directory and downloading themes"
    /usr/bin/mkdir -p "${HOME}/.config/alacritty/themes"
    git clone https://github.com/alacritty/alacritty-theme "${HOME}/.config/alacritty/themes"
  fi

  if [[ -f ${HOME}/.config/alacritty/alacritty.toml ]];
  then
    echo "   Config file already created"
  else
    echo "   Creating config file"

    /usr/bin/mkdir -p "${HOME}/.config/alacritty"
    cat > "${HOME}/.config/alacritty/alacritty.toml" <<DELIM
import = [
    "~/.config/alacritty/themes/themes/zenburn.toml"
]
DELIM
  fi
}

install_if_needed

