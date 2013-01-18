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

echo 'Creating local files'
touch alias.local color.local export.local function.local setting.local source.local variable.local

echo 'Adapting .xinitrc'

echo '#net_bazzline_config_shell start' >> $HOME'/.xinitrc'
echo '' >> $HOME'/.xinitrc'
echo "if [ -f \$PATH_SHELL_CONFIG'/color' ]; then " >> $HOME'/.xinitrc'
echo "  xrdb -merge $PATH_SHELL_CONFIG'/color'" >> $HOME'/.xinitrc'
echo "fi" >> $HOME'/.xinitrc'
echo "if [ -f \$PATH_SHELL_CONFIG'/color.local' ]; then " >> $HOME'/.xinitrc'
echo "  xrdb -merge $PATH_SHELL_CONFIG'/color.local'" >> $HOME'/.xinitrc'
echo "fi" >> $HOME'/.xinitrc'
echo '' >> $HOME'/.xinitrc'
echo '#net_bazzline_config_shell end' >> $HOME'/.xinitrc'


echo 'Finished'
