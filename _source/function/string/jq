#!/bin/bash

# d
# Usage: net_bazzline_string_jq_decode_base64_jwt_token "content of jwt token"
# ref: https://tribut.de
function net_bazzline_string_jq_decode_base64_jwt_token ()
{
  jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< "${1}"
}

