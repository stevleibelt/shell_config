#!/bin/bash
####
# Contains webp dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-02-15
####

if [[ ${NET_BAZZLINE_WEBP_IS_AVAILABLE} -eq 1 ]];
then
    #c
    alias batchConvertImageToWebP="net_bazzline_image_batch_convert_to_webp"
fi
