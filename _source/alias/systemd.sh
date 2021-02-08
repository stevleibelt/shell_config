#!/bin/bash
####
# Contains systemd dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_SYSTEMD_IS_AVAILABLE} -eq 1 ]]
then
    #t
    #@see: https://www.howtogeek.com/499623/how-to-use-journalctl-to-read-linux-system-logs/
    alias tailJournalctl='net_bazzline_execute_as_super_user_when_not_beeing_root journalctl -f -p 5'
fi
