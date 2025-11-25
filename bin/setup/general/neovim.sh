#!/bin/bash
####
# Installs and configures neovim
####
# @see
#   https://wiki.archlinux.org/title/Neovim
#   https://www.lazyvim.org/
# @since 2025-11-25
# @author stev leibelt <artodeto@arcor.de>
####

function install_if_needed() {
  if [[ ! -f /usr/bin/pacman ]];
  then
      echo ":: Aborting."
      echo "   No /usr/bin/pacman installed."

      exit 1
  fi

  if [[ -f /usr/bin/nvim ]];
  then
      echo ":: Neovim is installed already"
  else
      sudo pacman -S neovim
  fi

  if [[ -f /usr/bin/neovide ]];
  then
      echo ":: Neovide is installed already"
  else
      sudo pacman -S neovide
  fi

  if [[ ! -d ~/.config/nvim ]];
  then
    /usr/bin/mkdir -p ~/.config/nvim
  fi

  if [[ -f ~/.vimrc ]] && [[ ! -f ~/.config/nvim/init.vim ]];
  then
    cp ~/.vimrc ~/.config/nvim/init.vim
  fi

  if [[ ! -d ~/.config/nvimFlavorLazyvim ]];
  then
    git clone https://github.com/LazyVim/starter ~/.config/nvimFlavorLazyvim
    rm -fr ~/.config/nvimFlavorLazyvim/.git

    echo "Add >>alias lazyvim='NVIM_APPNAME=nvimFlavorLazyvim nvim'<< to your alias"
  fi
}

install_if_needed

