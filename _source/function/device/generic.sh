#!/bin/bash

# d

####
# Creates /etc/systemd/logind.conf.d/999_disable_led_switch.conf to
# disable handle lid switch
####
function net_bazzline_device_disable_lid_suspend ()
{
  sudo bash -c 'cat <<DELIM > /etc/systemd/logind.conf.d/999_disable_led_switch.conf
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
DELIM'
  sudo systemctl reload systemd-logind.service
}

#l

####
# lists the processes sorted by memory usage decreasing
#
# [@param int $1] - number of processes to list (default is 8)
####
# @see https://www.shellhacks.com/find-top-processes-memory-usage-linux/
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-18
####
function net_bazzline_device_list_memory_usage_by_process ()
{
    local NUMBER_OF_PROCESSES_TO_LIST=${1:-20}

    sudo ps axo rss,comm,pid \
        | awk '{ proc_list[$2]++; proc_list[$2 "," 1] += $1;  } \
    END { for (proc in proc_list) { printf("%d\t%s\n", \
    proc_list[proc "," 1],proc);  } }' | sort -n | tail -n ${NUMBER_OF_PROCESSES_TO_LIST} | sort -rn \
    | awk '{$1/=1024;printf "%.0fMB\t",$1}{print $2}'

    echo ":: If you are using firefox, open a tab with >>about:memory?verbose<< and click on >>Minimize ...<<"

    #@see: https://superuser.com/questions/398862/linux-find-out-what-process-is-using-all-the-ram
    #ps aux  | awk '{printf "%8.3f MB\t\t%s\n", $6/1024, $11}'  | sort -n | grep -v '^   0.000 MB'
}

# r

####
# Removes /etc/systemd/logind.conf.d/999_disable_led_switch.conf to
# restore handle lid switch behavior
####
function net_bazzline_device_restore_lid_suspend ()
{
  sudo bash -c 'rm /etc/systemd/logind.conf.d/999_disable_led_switch.conf'
  sudo systemctl reload systemd-logind.service
}

#s

####
# sets the provided optical drive speed
# 
# @param int $1 - speed (default is 12)
# @param string $2 - path the device (default is /dev/sr0)
# 
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-12-02
####
function net_bazzline_device_set_optical_drive_speed ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    local PATH_TO_THE_DEVICE=${2:-'/dev/sr0'}
    local SPEED=${1:-12}

    eject -x ${SPEED} ${PATH_TO_THE_DEVICE}
}
