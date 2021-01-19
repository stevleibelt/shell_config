#!/bin/bash
####
# Contains acpi dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_ACPI_IS_AVAILABLE} -eq 1 ]];
then
    alias showBatteryStatusWithoutAcpi='for BATTERY_FILE_PATH in $(find /sys/class/power_supply/ -iname "BAT*");do echo ${BATTERY_FILE_PATH}; cat ${BATTERY_FILE_PATH}/capacity; cat ${BATTERY_FILE_PATH}/status; done;'
    alias showBatteryStatusWithAcpi='acpi -i'
fi
