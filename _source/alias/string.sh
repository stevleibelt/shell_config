#!/bin/bash
####
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2023-04-18
####

alias leftTrim=net_bazzline_string_left_trim
alias rightTrim=net_bazzline_string_right_trim
alias trim=net_bazzline_string_trim

if [[ -f /usr/bin/jq ]];
then
  alias decodeBase64Jwt=net_bazzline_string_jq_decode_base64_jwt_token
fi

