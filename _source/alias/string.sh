#!/bin/bash
####
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2023-04-18
####

# c
alias createRandomAlphanumericString=net_bazzline_string_create_random_alphanumeric_string

# l
alias leftTrim=net_bazzline_string_left_trim

# r
alias rightTrim=net_bazzline_string_right_trim

# t
alias trim=net_bazzline_string_trim

if [[ -f /usr/bin/jq ]];
then
  # d
  alias decodeBase64Jwt=net_bazzline_string_jq_decode_base64_jwt_token
fi

