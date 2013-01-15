stev leibelt config for shell
================

A bootstrapfile that loads all files and if exists local files.

Installation
============
* git clone the repository int /your/path.
* add following line into your .bashrc

PATH_SHELL_CONFIG=$HOME'/your/path'
if [ -f $PATH_SHELL_CONFIG'/bootstrap' ]; then
  source $PATH_SHELL_CONFIG'/bootstrap'
fi
