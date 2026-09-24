#!/bin/bash
# c
# [param: <int: number_of_characters>] - default is 48
function net_bazzline_string_create_random_alpha_string ()
{
  cat < /dev/urandom | tr -dc 'a-zA-Z' | fold -w "${1:-48}" | head -n 1
}

# [param: <int: number_of_characters>] - default is 48
function net_bazzline_string_create_random_alphanumeric_string ()
{
  cat < /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "${1:-48}" | head -n 1
}

# [param: <int: number_of_characters>] - default is 48
function net_bazzline_string_create_random_alphanumeric_lowercase_string ()
{
  local GENERATED_STRING

  GENERATED_STRING=$(net_bazzline_string_create_random_alphanumeric_string "${@}")
  echo "${GENERATED_STRING}" | tr '[:upper:]' '[:lower:]'
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

function net_bazzline_string_url_decode ()
{
    local CHAR
    local DECODED
    local HEX
    local INPUT
    local ITERATOR
    local OUTPUT

    INPUT="${1}"
    DECODED=""
    OUTPUT=""

    # URL-decode percent-encoded bytes
    for ((ITERATOR = 0; ITERATOR < ${#INPUT}; ITERATOR++)); do
      CHAR="${INPUT:ITERATOR:1}"

      if [[ $CHAR == '%' && ${#INPUT} -ge $((ITERATOR + 3)) ]];
      then
        HEX=${INPUT:ITERATOR+1:2}

          if [[ $HEX =~ ^[0-9A-Fa-f]{2}$ ]]; then
            # "\\x${HEX}": Creates a hex string
            # '%b': Interpret backslash escaped
            # -v CHAR: Store the result in variable CHAR and do not print it
            printf -v CHAR '%b' "\\x$HEX"
            ((ITERATOR += 2))
          fi
      fi

      DECODED+=$CHAR
  done

  # Convert to lowercase and build the slug
  DECODED=${DECODED,,}

  for ((ITERATOR = 0; ITERATOR < ${#DECODED}; ITERATOR++));
  do
    CHAR=${DECODED:ITERATOR:1}

    if [[ $CHAR =~ [a-z0-9] ]];
    then
      OUTPUT+=$CHAR
    else
      # Avoid repeated underscores
      [[ $OUTPUT && ${OUTPUT: -1} != "_" ]] && OUTPUT+="_"
    fi
  done

  # Remove a trailing underscore
  OUTPUT=${OUTPUT%_}

  printf '%s\n' "$OUTPUT"
}

