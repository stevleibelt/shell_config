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
DATETIME=$(date +%y%m%d_+%T)

echo 'Adapting .bashrc'

echo '#net_bazzline_config_shell start' >> $HOME'/.bashrc'
echo '#date: '$DATETIME >> $HOME'/.bashrc'
echo '' >> $HOME'/.bashrc'
echo PATH_SHELL_CONFIG=$PATH_SELF >> $HOME'/.bashrc'
echo "if [ -f \$PATH_SHELL_CONFIG'/bootstrap' ]; then " >> $HOME'/.bashrc'
echo "  source \$PATH_SHELL_CONFIG'/bootstrap' fi" >> $HOME'/.bashrc'
echo "fi" >> $HOME'/.bashrc'
echo '' >> $HOME'/.bashrc'
echo '#net_bazzline_config_shell end' >> $HOME'/.bashrc'

echo 'Creating local files'
touch $PATH_SELF/alias.local $PATH_SELF/color.local $PATH_SELF/export.local $PATH_SELF/function.local $PATH_SELF/setting.local $PATH_SELF/source.local $PATH_SELF/variable.local

echo 'Creating temporary .xinitrc.temp'
touch $HOME'/.xinitrc.temp'

echo 'Adding content to temporary .xinitrc.temp'

echo '#net_bazzline_config_shell start' >> $HOME'/.xinitrc.temp'
echo '#date: '$DATETIME >> $HOME'/.xinitrc.temp'
echo '' >> $HOME'/.xinitrc.temp'
echo PATH_SHELL_CONFIG=$PATH_SELF >> $HOME'/.xinitrc.temp'
echo "if [ -f \$PATH_SHELL_CONFIG'/color' ]; then " >> $HOME'/.xinitrc.temp'
echo "  xrdb -merge \$PATH_SHELL_CONFIG'/color'" >> $HOME'/.xinitrc.temp'
echo "fi" >> $HOME'/.xinitrc.temp'
echo "if [ -f \$PATH_SHELL_CONFIG'/color.local' ]; then " >> $HOME'/.xinitrc.temp'
echo "  xrdb -merge \$PATH_SHELL_CONFIG'/color.local'" >> $HOME'/.xinitrc.temp'
echo "fi" >> $HOME'/.xinitrc.temp'
echo '' >> $HOME'/.xinitrc.temp'
echo '#net_bazzline_config_shell end' >> $HOME'/.xinitrc.temp'
echo '' >> $HOME'/.xinitrc.temp'

echo 'Copying content of .xinitrc to .xinitrc.temp'

cat $HOME'/.xinitrc' >> $HOME'/.xinitrc.temp'

echo 'Replacing .xinitrc with .xinitrc.temp'

mv $HOME'/.xinitrc.temp' $HOME'/.xinitrc'

echo 'Finished'
