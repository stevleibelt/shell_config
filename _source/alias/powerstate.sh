#!/bin/bash
####
# Contains powerstate dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

# ref: https://www.makeuseof.com/disable-auto-suspend-in-linux/
alias disableAutomaticSuspend='sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target'
alias enableAutomaticSuspend='sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target'

if [[ ${NET_BAZZLINE_POWERSTATE_IS_AVAILABLE} -eq 1 ]]
then
    alias suspendToDisk='sudo bash -c "echo mem > /sys/power/state"'
fi
