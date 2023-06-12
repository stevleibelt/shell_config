#!/bin/bash
########
# Installscript for config_shell.
# Adds entries into your .bashrc
#
# @author stev leibelt
# @since 2013-01-15
# @todo move into functions
########

function _main ()
{
  clear

  local ADAPT_BASH_RC
  local ADAPT_XINIT
  local PATH_TO_THE_BASH_PROFILE
  local PATH_TO_THE_BASH_RC
  local PATH_TO_THE_XINIT
  local PATH_TO_THIS_SCRIPT
  local PATH_TO_THE_TEMPORARY_XINIT

  #begin of setup
  printf -v DATETIME "%(%F-%T)T" -1

  ADAPT_BASH_RC=1
  ADAPT_XINIT=1
  PATH_TO_THE_BASH_PROFILE="${HOME}/.bash_profile"
  PATH_TO_THE_BASH_RC="${HOME}/.bashrc"
  PATH_TO_THE_XINIT="${HOME}/.xinitrc"
  PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  PATH_TO_THE_TEMPORARY_XINIT="${PATH_TO_THE_XINIT}.temporary"
  #end of setup

  ##begin of validation
  if [[ -f "${PATH_TO_THE_BASH_RC}" ]];
  then
    if grep -q net_bazzline_config_shell "${PATH_TO_THE_BASH_RC}";
    then
      ADAPT_BASH_RC=0
    fi
  fi

  if [[ -f "${PATH_TO_THE_XINIT}" ]];
  then
    if grep -q net_bazzline_config_shell "${PATH_TO_THE_XINIT}";
    then
      ADAPT_XINIT=0
    fi
  fi
  ##end of validation

  ##begin of adapting bashrc
  if [[ ${ADAPT_BASH_RC} -gt 0 ]];
  then
    echo ":: .bashrc adaptation"
    if [[ ! -f "${PATH_TO_THE_BASH_RC}" ]];
    then
      echo "   No .bashrc file found."
      echo "   Bash is currently the only supported shell"
      
      echo "   Copying and creating it."
      cp -v /etc/bash.bashrc ~/.bashrc
    fi

    echo "   Adding content"
    cat >> "${PATH_TO_THE_BASH_RC}" <<DELIM
#begin of net_bazzline_config_shell"
#date: "${DATETIME}

PATH_SHELL_CONFIG="${PATH_TO_THIS_SCRIPT}/.."

if [[ -f "\${PATH_SHELL_CONFIG}/bootstrap" ]];
then
    source "\${PATH_SHELL_CONFIG}/bootstrap"
fi
#end of net_bazzline_config_shell"
DELIM
  fi
  ##end of adapting bashrc

  ##begin of adapting bash_profile
  if [[ ! -f "${PATH_TO_THE_BASH_PROFILE}" ]];
  then
    echo ":: No .bash_profile file found."
    echo "   Creating on ..."

    touch "${PATH_TO_THE_BASH_PROFILE}"
    cat > "${PATH_TO_THE_BASH_PROFILE}" <<DELIM
#begin of created net_bazzline_config_shell"
#created at date: "${DATETIME}
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
#end of created net_bazzline_config_shell"
DELIM
  else
    echo ":: .bash_profile file found."
    echo "   Nothing to do."
  fi
  ##end of adapting bash_profile

  ##begin of creating local user files
  echo ""
  echo ":: Creating local setting files"

  declare -a FILES_TO_CREATE=("setting" "variable" "source" "export" "function" "alias" "automatic_start")

  for FILE_TO_CREATE in "${FILES_TO_CREATE[@]}";
  do
    if [[ ! -f ${FILE_TO_CREATE} ]];
    then
      FILE_PATH_NAME="${PATH_TO_THIS_SCRIPT}/../local.${FILE_TO_CREATE}"
      touch "${FILE_PATH_NAME}"
      echo "#!/bin/bash" > "${FILE_PATH_NAME}"
    fi
  done;
  ##end of creating local user files

  ##begin of adapting xinitrc
  if [[ ${ADAPT_XINIT} -gt 0 ]];
  then
    echo ""
    echo ":: XINIT adaptation"
    echo "   Creating .xinitrc.temporary"

    touch "${PATH_TO_THE_TEMPORARY_XINIT}"

    echo "   Adding content to ${PATH_TO_THE_TEMPORARY_XINIT}"

    cat > "${PATH_TO_THE_TEMPORARY_XINIT}" <<DELIM
#begin of net_bazzline_config_shell"
#date: "${DATETIME}

PATH_SHELL_CONFIG="${PATH_TO_THIS_SCRIPT}/.."

if [[ -f "\${PATH_SHELL_CONFIG}/color" ]];
then
  xrdb -merge "\${PATH_SHELL_CONFIG}/color"
fi
if [[ -f "\${PATH_SHELL_CONFIG}/color.local" ]];
then
  xrdb -merge "\${PATH_SHELL_CONFIG}/color.local"
fi

#end of net_bazzline_config_shell"
DELIM

    if [[ -f "${PATH_TO_THE_XINIT}" ]];
    then
      echo "   Copy content of ${PATH_TO_THE_XINIT} into ${PATH_TO_THE_TEMPORARY_XINIT}"

      cat "${PATH_TO_THE_XINIT}" >> "${PATH_TO_THE_TEMPORARY_XINIT}"
    fi

    echo "   Replacing ${PATH_TO_THE_XINIT} with ${PATH_TO_THE_TEMPORARY_XINIT}"

    mv "${PATH_TO_THE_TEMPORARY_XINIT}" "${PATH_TO_THE_XINIT}"
  fi
  ##end of adapting xinitrc

  ##begin of creating cache directory
  if [[ ! -d ~/.cache/net_bazzline/shell_config ]];
  then
    mkdir -p ~/.cache/net_bazzline/shell_config
  fi
  ##end of creating cache directory

  ##begin of finish
  echo ""
  echo ":: Finished"
  ##end of finish
}

_main "${@}"
