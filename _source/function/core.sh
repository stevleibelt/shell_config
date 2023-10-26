#!/bin/bash
#####
# Contains core functions used everywhere
#####

####
# Asks yes or no
####
# [@param1] <string: question_to_ask> default: > Yes or no? Please input n,N,y or Y
# [@param2] <string: default_answer> default: n
# returns: 0 if yes, 1 if no
####
function net_bazzline_core_ask_yes_or_no ()
{
  local QUESTION_TO_ASK
  local DEFAULT_ANSWER

  QUESTION_TO_ASK="${1:-Yes or no? Please input n,N,y or Y}"
  DEFAULT_ANSWER="${2:-n}"

  if [[ ${#DEFAULT_ANSWER} -gt 0 ]];
  then
    QUESTION_TO_ASK="${QUESTION_TO_ASK} (default is ${DEFAULT_ANSWER})"
  fi
  read -r -p "> ${QUESTION_TO_ASK}: "

  if [[ ${REPLY:-${DEFAULT_ANSWER}} =~ ^[yY]$ ]];
  then
    return 0
  elif [[ ${REPLY:-${DEFAULT_ANSWER}} =~ ^[nN]$ ]];
  then
    return 1
  else
    if [[ ${DEFAULT_ANSWER} =~ ^[yY]$ ]];
    then
      return 0
    else
      return 1
    fi
  fi
}

# ref: https://stackoverflow.com/a/58598185
function net_bazzline_core_capture_command_output ()
{
  tee "/tmp/net_bazzline_core_${USER}_captured_command.out"
}

####
# Echos all passed parameters if BE_VERBOSE is greater 0
####
function net_bazzline_core_echo_if_be_verbose ()
{
  if [[ ${BE_VERBOSE} -gt 0 ]];
  then
    echo "${@}"
  fi
}

# ref: https://stackoverflow.com/a/58598185
function net_bazzline_core_return_command_output ()
{
  cat "/tmp/net_bazzline_core_${USER}_captured_command.out"
}

