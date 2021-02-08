#!/bin/bash
####
# Contains php dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_PHP_IS_AVAILABLE} -eq 1 ]];
then
    #l
    alias lintPhpCode="find . -name *.php | xargs -n1 php -l | grep -v 'No syntax errors detected'"

    #s
    alias startPhpWebserver=net_bazzline_php_start_internal_webserver
fi
