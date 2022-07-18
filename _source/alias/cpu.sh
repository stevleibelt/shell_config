#!/bin/bash

#l
if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_LINUX} -eq 1 ]];
then
    alias listCpuVulnerabilities="ls /sys/devices/system/cpu/vulnerabilities/*"
fi
