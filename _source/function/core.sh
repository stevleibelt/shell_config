#!/bin/bash
#####
# Contains core functions used everywhere
#####

####
# Echos all passed parameters if BE_VERBOSE is greater 0
####
function net_bazzline_core_echo_if_be_verbose()
{
  if [[ ${BE_VERBOSE} -gt 0 ]];
  then
    echo "${@}"
  fi
}

