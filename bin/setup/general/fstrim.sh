#!/bin/bash
####
# Setup fstrim
####
# @see https://linuxman.co/linux-desktop/5-things-to-do-immediately-after-installing-garuda/
# @since 2024-04-02
# @author stev leibelt <artodeto@arcor.de>
####

function _main()
{
  sudo systemctl enable fstrim.timer
  sudo systemctl start fstrim.timer
}

_main "${@}"
