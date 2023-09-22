#!/bin/bash
# c
# [param: <int: number_of_characters>] - default is 48
function net_bazzline_string_create_random_alphanumeric_string ()
{
  cat < /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "${1:-48}" | head -n 1
}

# l
# Usage: echo " my string to trim " | net_bazzline_string_left_trim
# ref: https://unix.stackexchange.com/a/660011
function net_bazzline_string_left_trim ()
{
  sed -E 's/^[[:space:]]+//'
}

# r
# Usage: echo " my string to trim " | net_bazzline_string_right_trim
# ref: https://unix.stackexchange.com/a/660011
function net_bazzline_string_right_trim ()
{
  sed -E 's/[[:space:]]+$//'
}

# t
# Usage: echo " my string to trim " | net_bazzline_string_trim
# ref: https://unix.stackexchange.com/a/660011
function net_bazzline_string_trim ()
{
  net_bazzline_string_left_trim | net_bazzline_string_right_trim
}

