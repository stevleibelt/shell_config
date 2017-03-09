#!/bin/bash
########
# Installscript for config_shell.
# Adds entries into your .bashrc
#
# @author stev leibelt
# @since 2013-01-15
# @todo move into functions
########

clear

#begin of setup
DATETIME=$(date +%y%m%d_+%T)

PATH_TO_THE_BASH_RC="${HOME}/.bashrc"
PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
PATH_TO_THE_XINIT="${HOME}/.xinitrc"

PATH_TO_THE_TEMPORARY_XINIT="${PATH_TO_THE_XINIT}.temporary"
#end of setup

##begin of validation
if [[ ! -f "${PATH_TO_THE_BASH_RC}" ]];
then
    echo "No .bashrc file found."
    echo "Bash is currently the only supported shell"

    exit 1
fi
##end of validation

##begin of adapting bashrc
echo "Adapting .bashrc"

cat >> "${PATH_TO_THE_BASH_RC}" <<DELIM
#begin of net_bazzline_config_shell"
#date: "${DATETIME}

PATH_SHELL_CONFIG="${PATH_TO_THIS_SCRIPT}"

if [[ -f "\${PATH_SHELL_CONFIG}/bootstrap" ]];
then
    source "\${PATH_SHELL_CONFIG}/bootstrap"
fi
#end of net_bazzline_config_shell"
DELIM
##end of adapting bashrc

##begin of creating local user files
echo ""
echo "Creating local files"

declare -a FILES_TO_CREATE=("setting" "variable" "source" "export" "function" "alias" "automatic_start")

for FILE_TO_CREATE in ${FILES_TO_CREATE[@]}; do
    FILE_PATH_NAME="${PATH_TO_THIS_SCRIPT}/local.${FILE_TO_CREATE}"
    touch "${FILE_PATH_NAME}"
    echo "#!/bin/bash" > "${FILE_PATH_NAME}"
done;
##end of creating local user files

##begin of adating xínitrc
echo ""
echo "Creating .xinitrc.temporary"

touch "${PATH_TO_THE_TEMPORARY_XINIT}"

echo "Adding content to "basename(${PATH_TO_THE_TEMPORARY_XINIT})

cat >> "${PATH_TO_THE_TEMPORARY_XINIT}" <<DELIM
#begin of net_bazzline_config_shell"
#date: "${DATETIME}

PATH_SHELL_CONFIG="\${PATH_TO_THIS_SCRIPT}"

if [[ -f "${PATH_SHELL_CONFIG}/color" ]];
then
  xrdb -merge "${PATH_SHELL_CONFIG}/color"
fi
if [[ -f "${PATH_SHELL_CONFIG}/color.local" ]];
then
  xrdb -merge "${PATH_SHELL_CONFIG}/color.local"
fi

#end of net_bazzline_config_shell"

DELIM

echo ""
echo "Copying content of .xinitrc to .xinitrc.temporary"

cat "${PATH_TO_THE_XINIT}" >> "${PATH_TO_THE_TEMPORARY_XINIT}"

echo ""
echo "Replacing .xinitrc with .xinitrc.temporary"

mv "${PATH_TO_THE_TEMPORARY_XINIT}" "${PATH_TO_THE_XINIT}"
rm "${PATH_TO_THE_TEMPORARY_XINIT}"
##begin of adating xínitrc

##begin of finish
echo ""
echo "Finished"
##begin of finish
