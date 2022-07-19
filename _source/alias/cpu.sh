#!/bin/bash

#l
if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_LINUX} -eq 1 ]];
then
    #@see: https://www.phoronix.com/scan.php?page=article&item=retbleed-benchmark&num=1
    alias listCpuVulnerabilities="ls /sys/devices/system/cpu/vulnerabilities/*"
fi
