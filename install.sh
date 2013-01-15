#!/bin/bash
########
# Installscript for config_shell.
# Adds entries into your .bashrc
#
# @author stev leibelt
# @since 2013-01-15
########

clear

if [ ! -f $HOME'/.bashrc' ]; then
  echo 'Can not find .bashrc'
  exit 1
fi

PATH_SELF=$(cd $(dirname "$0"); pwd)

echo 'Adapting .bashrc'

echo '#net_bazzline_config_shell start' >> $HOME'/.bashrc'
echo '' >> $HOME'/.bashrc'
echo PATH_SHELL_CONFIG=$PATH_SELF >> $HOME'/.bashrc'
echo "if [ -f \$PATH_SHELL_CONFIG'/bootstrap' ]; then " >> $HOME'/.bashrc'
echo "  source \$PATH_SHELL_CONFIG'/bootstrap' fi" >> $HOME'/.bashrc'
echo "fi" >> $HOME'/.bashrc'
echo '' >> $HOME'/.bashrc'
echo '#net_bazzline_config_shell end' >> $HOME'/.bashrc'

echo 'Finished'
