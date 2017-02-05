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

PATH_TO_THE_BASH_RC="${HOME}/.bashrc"

if [[ ! -f "${PATH_TO_THE_BASH_RC}" ]];
then
    echo "No .bashrc file found."
    echo "Bash is currently the only supported shell"

    exit 1
fi

PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
DATETIME=$(date +%y%m%d_+%T)

echo "Adapting .bashrc"

echo "#net_bazzline_config_shell start" >> ${PATH_TO_THE_BASH_RC}
echo "#date: "${DATETIME} >> ${PATH_TO_THE_BASH_RC}
echo "" >> ${PATH_TO_THE_BASH_RC}
echo "PATH_SHELL_CONFIG=\${PATH_TO_THIS_SCRIPT}" >> ${PATH_TO_THE_BASH_RC}
echo "if [ -f \${PATH_SHELL_CONFIG}\"/bootstrap\" ]; then " >> ${PATH_TO_THE_BASH_RC}
echo "  source \${PATH_SHELL_CONFIG}\"/bootstrap\"" >> ${PATH_TO_THE_BASH_RC}
echo "fi" >> ${PATH_TO_THE_BASH_RC}
echo "" >> ${PATH_TO_THE_BASH_RC}
echo "#net_bazzline_config_shell end" >> ${PATH_TO_THE_BASH_RC}

echo ""
echo "Creating local files"
declare -a FILES_TO_CREATE=("setting" "variable" "source" "export" "function" "alias" "automatic_start")
for FILE_TO_CREATE in ${FILES_TO_CREATE[@]}; do
    FILE_PATH_NAME="${PATH_TO_THIS_SCRIPT}/local.${FILE_TO_CREATE}"
    touch "${FILE_PATH_NAME}"
    echo "#!/bin/bash" > "${PATH_TO_THE_BASH_RC}"
done;

PATH_TO_THE_XINIT="${HOME}/.xinitrc.temp"
PATH_TO_THE_TEMPORARY_XINIT="${PATH_TO_THE_XINIT}.temporary"

echo ""
echo "Creating .xinitrc.temporary"
touch "${PATH_TO_THE_TEMPORARY_XINIT}"

echo "Adding content to .xinitrc.temporary"

echo "#net_bazzline_config_shell start" >> "${PATH_TO_THE_TEMPORARY_XINIT}"
echo "#date: "${DATETIME} >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "PATH_SHELL_CONFIG=\${PATH_TO_THIS_SCRIPT}" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "if [[ -f \${PATH_SHELL_CONFIG}\"/color\" ]]; then " >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "  xrdb -merge \${PATH_SHELL_CONFIG}\"/color\"" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "fi" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "if [[ -f \${PATH_SHELL_CONFIG}\"/local.color\" ]]; then " >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "  xrdb -merge \${PATH_SHELL_CONFIG}\"/local.color\"" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "fi" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "#net_bazzline_config_shell end" >> ${PATH_TO_THE_TEMPORARY_XINIT}
echo "" >> ${PATH_TO_THE_TEMPORARY_XINIT}

echo ""
echo "Copying content of .xinitrc to .xinitrc.temporary"

cat ${PATH_TO_THE_XINIT} >> ${PATH_TO_THE_TEMPORARY_XINIT}

echo ""
echo "Replacing .xinitrc with .xinitrc.temporary"

mv ${PATH_TO_THE_TEMPORARY_XINIT} ${PATH_TO_THE_XINIT}
rm ${PATH_TO_THE_TEMPORARY_XINIT}

echo ""
echo "Finished"
