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

LOCAL_PATH_TO_THE_BASH_RC="$HOME/.bashrc"

if [[ ! -f "$LOCAL_PATH_TO_THE_BASH_RC" ]];
then
    echo "No .bashrc file found."
    echo "Bash is currently the only supported shell"
    exit 1
fi

LOCAL_PATH_TO_THIS_SCRIPT=$(cd $(dirname "$0"); pwd)
LOCAL_DATETIME=$(date +%y%m%d_+%T)

echo "Adapting .bashrc"

echo "#net_bazzline_config_shell start" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "#date: "$LOCAL_DATETIME >> $LOCAL_PATH_TO_THE_BASH_RC
echo "" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "PATH_SHELL_CONFIG=\$LOCAL_PATH_TO_THIS_SCRIPT" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "if [ -f \$PATH_SHELL_CONFIG\"/bootstrap\" ]; then " >> $LOCAL_PATH_TO_THE_BASH_RC
echo "  source \$PATH_SHELL_CONFIG\"/bootstrap\"" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "fi" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "" >> $LOCAL_PATH_TO_THE_BASH_RC
echo "#net_bazzline_config_shell end" >> $LOCAL_PATH_TO_THE_BASH_RC

echo ""
echo "Creating local files"
declare -a FILES_TO_CREATE=("setting" "variable" "source" "export" "function" "alias" "automatic_start")
for FILE_TO_CREATE in ${FILES_TO_CREATE[@]}; do
    LOCAL_FILE_PATH_NAME="$LOCAL_PATH_TO_THIS_SCRIPT/local.$FILE_TO_CREATE"
    touch "$LOCAL_FILE_PATH_NAME"
    echo "#!/bin/bash" > "$LOCAL_PATH_TO_THE_BASH_RC"
done;

LOCAL_PATH_TO_THE_XINIT="$HOME/.xinitrc.temp"
LOCAL_PATH_TO_THE_TEMPORARY_XINIT="$LOCAL_PATH_TO_THE_XINIT.temporary"

echo ""
echo "Creating .xinitrc.temporary"
touch "$LOCAL_PATH_TO_THE_TEMPORARY_XINIT"

echo "Adding content to .xinitrc.temporary"

echo "#net_bazzline_config_shell start" >> "$LOCAL_PATH_TO_THE_TEMPORARY_XINIT"
echo "#date: "$LOCAL_DATETIME >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "PATH_SHELL_CONFIG=\$LOCAL_PATH_TO_THIS_SCRIPT" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "if [[ -f \$PATH_SHELL_CONFIG\"/color\" ]]; then " >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "  xrdb -merge \$PATH_SHELL_CONFIG\"/color\"" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "fi" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "if [[ -f \$PATH_SHELL_CONFIG\"/local.color\" ]]; then " >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "  xrdb -merge \$PATH_SHELL_CONFIG\"/local.color\"" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "fi" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "#net_bazzline_config_shell end" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT
echo "" >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT

echo ""
echo "Copying content of .xinitrc to .xinitrc.temporary"

cat $LOCAL_PATH_TO_THE_XINIT >> $LOCAL_PATH_TO_THE_TEMPORARY_XINIT

echo ""
echo "Replacing .xinitrc with .xinitrc.temporary"

mv $LOCAL_PATH_TO_THE_TEMPORARY_XINIT $LOCAL_PATH_TO_THE_XINIT
rm $LOCAL_PATH_TO_THE_TEMPORARY_XINIT

echo ""
echo "Finished"
