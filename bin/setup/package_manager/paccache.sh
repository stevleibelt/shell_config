#!/bin/bash
####
# @ref https://wiki.archlinux.org/title/Pacman#Cleaning_the_package_cache
# @since 2025-03-25
# @author stev leibelt <artodeto@bazzline.net>
####

function _main ()
{
  if [[ ! -f /etc/pacman.d/hooks/trigger_cleanup_paccache.hook ]];
  then
    echo ":: Installing trigger_cleanup_paccache.hook"
    #@see: https://bbs.archlinux.org/viewtopic.php?pid=1694743#p1694743
    sudo bash -c "cat > /etc/pacman.d/hooks/trigger_cleanup_paccache.hook <<DELIM
[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Keep the last cache and the currently installed.
When = PostTransaction
Exec = /usr/bin/paccache -rvk2
DELIM"
  fi
}

_main "${@}"

