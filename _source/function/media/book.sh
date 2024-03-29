#!/bin/bash

if [[ -f /usr/bin/naps2 ]];
then
  function net_bazzline_media_book_add_ocr_to_pdf ()
  {
    local DESTINATION_FILE_PATH
    local SOURCE_FILE_PATH
    # ref: https://www.loc.gov/standards/iso639-2/php/code_list.php
    local OCR_LANGUAGE

    DESTINATION_FILE_PATH="${3:-${1}}"
    OCR_LANGUAGE="${2:-deu}"
    SOURCE_FILE_PATH="${1}"

    if [[ -f "${SOURCE_FILE_PATH}" ]];
    then
      # ref: https://www.naps2.com/doc/command-line
      #
      # --enableocr:  enables usage of ocr
      # --force:      overwrite if output file path exists
      # -i:           import file path
      # -n 0:         scan 0 pages
      # -o:           output file path
      # --ocrlang:    defines ocr language
      if [[ "${SOURCE_FILE_PATH}" == "${DESTINATION_FILE_PATH}" ]];
      then
        naps2 console -i "${SOURCE_FILE_PATH}" -n 0 --enableocr --ocrlang "${OCR_LANGUAGE}" --force -o "${DESTINATION_FILE_PATH}"
      else
        naps2 console -i "${SOURCE_FILE_PATH}" -n 0 --enableocr --ocrlang "${OCR_LANGUAGE}" -o "${DESTINATION_FILE_PATH}"
      fi
    else
      echo ":: Invalid source file path provided"
      echo "   >>${SOURCE_FILE_PATH}<< does not exist"
    fi
  }
fi

####
# finds all *.md files in current working directory
# converts each md file in a pdf file
# merges all created pdf files into one file
####
# @param: FILE_PATTERN - default: *.md
# @param: MERGED_PDF_FILENAME - default: _merged.pdf
####
function net_bazzline_media_book_convert_markdown_files_to_one_pdf ()
{
  local CURRENT_WORKING_DIRECTORY
  local FILE_PATTERN
  local NUMBER_OF_FOUND_FILES
  local MERGED_PDF_FILE_NAME
  local PDF_DIRECTORY_PATH
  local TEMPORARY_DIRECTORY
  local TEMPORARY_FILE_PATH

  CURRENT_WORKING_DIRECTORY=$(pwd)
  FILE_PATTERN="${1-*.md}"
  MERGED_PDF_FILE_NAME="${2-_merged.pdf}"
  TEMPORARY_DIRECTORY=$(mktemp -d)

  PDF_DIRECTORY_PATH="${TEMPORARY_DIRECTORY}/_pdf"
  TEMPORARY_FILE_PATH="${TEMPORARY_DIRECTORY}/list_of_files.txt"

  if [[ ! -f /usr/bin/pandoc ]];
  then
    echo ":: >>/usr/bin/pandoc<< is not a file."
    echo "   pandoc is mandatory"

    exit 1
  fi

  if [[ ! -f /usr/bin/gs ]];
  then
    echo ":: >>/usr/bin/gs<< is not a file."
    echo "   gs is mandatory"

    exit 2
  fi

  net_bazzline_core_echo_if_be_verbose ":: Dumping runtime environment"
  net_bazzline_core_echo_if_be_verbose "   CURRENT_WORKING_DIRECTORY >>${CURRENT_WORKING_DIRECTORY}<<"
  net_bazzline_core_echo_if_be_verbose "   FILE_PATTERN >>${FILE_PATTERN}<<"
  net_bazzline_core_echo_if_be_verbose "   MERGED_PDF_FILE_NAME >>${MERGED_PDF_FILE_NAME}<<"
  net_bazzline_core_echo_if_be_verbose "   PDF_DIRECTORY_PATH >>${PDF_DIRECTORY_PATH}<<"
  net_bazzline_core_echo_if_be_verbose "   TEMPORARY_FILE_PATH >>${TEMPORARY_FILE_PATH}<<"

  #find all md files and put the file path into a temporary file
  find . -iname "${FILE_PATTERN}" -type f -exec sh -c 'printf "${0:2}\n"' {} \; > "${TEMPORARY_FILE_PATH}"

  NUMBER_OF_FOUND_FILES=$(wc -l < "${TEMPORARY_FILE_PATH}")

  if [[ ${NUMBER_OF_FOUND_FILES} -gt 0  ]];
  then
    net_bazzline_core_echo_if_be_verbose ":: Processing >>${NUMBER_OF_FOUND_FILES}<< *.md files from >>${CURRENT_WORKING_DIRECTORY}<< or below."

    /usr/bin/mkdir -p "${PDF_DIRECTORY_PATH}" || echo ":: Could not create directory >>${PDF_DIRECTORY_PATH}<<"

    local OUTPUT_FILE_PATH
    local FILE_BASEDIR
    local FILE_BASENAME
    local FILE_NAMES_TO_MERGE

    while read -r FILE_PATH;
    do
      OUTPUT_FILE_PATH=$(echo "${FILE_PATH}" | sed 's/\//-/g')
      FILE_BASEDIR=$(dirname "${FILE_PATH}")
      FILE_BASENAME=$(basename "${FILE_PATH}")

      net_bazzline_core_echo_if_be_verbose "      FILE_BASEDIR >>${FILE_BASEDIR}<<"
      net_bazzline_core_echo_if_be_verbose "      FILE_BASENAME >>${FILE_BASENAME}<<"
      net_bazzline_core_echo_if_be_verbose "      OUTPUT_FILE_PATH >>${OUTPUT_FILE_PATH}<<"

      cd "${FILE_BASEDIR}" || echo "Could not change into directory >>${FILE_BASEDIR}<<."

      if [[ -f "${FILE_BASENAME}" ]];
      then
        net_bazzline_core_echo_if_be_verbose "   Executing >>pandoc --standalone \"${FILE_BASENAME}\" --output=\"${PDF_DIRECTORY_PATH}/${OUTPUT_FILE_PATH}.pdf\"<<"
        pandoc --standalone "${FILE_BASENAME}" --output="${PDF_DIRECTORY_PATH}/${OUTPUT_FILE_PATH}.pdf"
      else
        echo "   Skipping file >>${FILE_BASENAME}<<, does not exist."
      fi

      cd - || echo "Could not change into previous directory."
    done < "${TEMPORARY_FILE_PATH}"

    cd "${CURRENT_WORKING_DIRECTORY}" || echo "Could not change into directory >>${CURRENT_WORKING_DIRECTORY}<<"

    FILE_NAMES_TO_MERGE=$(ls "${PDF_DIRECTORY_PATH}"/*.pdf)

    net_bazzline_core_echo_if_be_verbose ":: Creating file >>${MERGED_PDF_FILE_NAME}<< by using all files from >>${PDF_DIRECTORY_PATH}<<."
    net_bazzline_core_echo_if_be_verbose "   Executing >>gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=\"${MERGED_PDF_FILE_NAME}\" -dBATCH ${FILE_NAMES_TO_MERGE}<<"
    # shellcheck disable=SC2086
    gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="${MERGED_PDF_FILE_NAME}" -dBATCH ${FILE_NAMES_TO_MERGE}
  else
    echo ":: No files found for pattern >>${FILE_PATTERN}<< in >>${CURRENT_WORKING_DIRECTORY}<< or below."
  fi

  net_bazzline_core_echo_if_be_verbose ":: Removing temporary directory >>${TEMPORARY_DIRECTORY}<<."
  rm -fr "${TEMPORARY_DIRECTORY}"
}

####
# @param: <string: source_file_path>
# [@param: <string: destination_file_path=source_file_path.compressed.pdf>]
# [@param: <int: image resolution=150]
# [@param: <string: pdf setting=/ebook]
#
# @see: https://opensource.com/article/20/8/reduce-pdf
####
function net_bazzline_media_book_compress_pdf ()
{
    #bo: user input
    DESTINATION_FILE_PATH=${2:-''}
    IMAGE_RESOLUTION=${3:-150}
    PDF_SETTINGS=${4:-'/ebook'}
    SOURCE_FILE_PATH=${1}
    #eo: user input

    #bo: input validation
    if [[ ${DESTINATION_FILE_PATH} == '' ]];
    then
        #assumed the file ends with .pdf, we are removing the last four
        #   characters and adding >>.compressed.pdf<<.
        DESTINATION_FILE_PATH="${SOURCE_FILE_PATH:0:-4}.compressed.pdf"
    fi

    if [[ ! -f "${SOURCE_FILE_PATH}" ]];
    then
        echo ":: Provided source file path >>${SOURCE_FILE_PATH}<< does not exist."

        return 1
    fi

    SOURCE_FILE_PATH_TYPE=$(file -b "${SOURCE_FILE_PATH}");

    if [[ "${SOURCE_FILE_PATH_TYPE:0:12}" != "PDF document" ]];
    then
        echo ":: Provided source file path >>${SOURCE_FILE_PATH}<< is not a pdf document."

        return 2
    fi
    #eo: input validation

    if [[ ! -x $(command -v gs) ]];
    then
        #find all md files and put the file path into a temporary file
        find . -iname "*.md" -type f -exec sh -c 'printf "${0:2}\n"' {} \; > "${TEMPORARY_FILE_PATH}"

        local NUMBER_OF_FOUND_FILES=$(cat "${TEMPORARY_FILE_PATH}" | wc -l)

        if [[ ${NUMBER_OF_FOUND_FILES} -gt 0  ]];
        then
            echo ":: Processing >>${NUMBER_OF_FOUND_FILES}<< *.md files from >>${CURRENT_WORKING_DIRECTORY}<< or below."

            mkdir "${PDF_DIRECTORY_PATH}"

            cat "${TEMPORARY_FILE_PATH}" | while read FILE_PATH;
            do
                    echo -n "."
                    local OUTPUT_FILE_PATH=$(echo "${FILE_PATH}" | sed 's/\//-/g')
                    local FILE_BASEDIR=$(dirname "${FILE_PATH}")
                    local FILE_BASENAME=$(basename "${FILE_PATH}")

                    cd "${FILE_BASEDIR}"

                    pandoc -s "${FILE_BASENAME}" -o "${PDF_DIRECTORY_PATH}/${OUTPUT_FILE_PATH}.pdf"

                    cd -
            done

            cd "${CURRENT_WORKING_DIRECTORY}"

            echo ":: Creating file >>${MERGED_PDF_FILE_NAME}<< by using all files from >>${PDF_DIRECTORY_PATH}<<."
            gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=${MERGED_PDF_FILE_NAME} -dBATCH ${PDF_DIRECTORY_PATH}/*
        fi
    else
        echo ":: No *.md files found in >>${CURRENT_WORKING_DIRECTORY}<< or below."
    fi

    rm -fr "${TEMPORARY_DIRECTORY}"
}

####
# @param: <string: source_file_path>
# [@param: <string: destination_file_path=source_file_path.compressed.pdf>]
# [@param: <int: image resolution=150]
# [@param: <string: pdf setting=/ebook]
#
# @see: https://opensource.com/article/20/8/reduce-pdf
####
function net_bazzline_media_book_compress_pdf ()
{
    #bo: user input
    DESTINATION_FILE_PATH=${2:-''}
    IMAGE_RESOLUTION=${3:-150}
    PDF_SETTINGS=${4:-'/ebook'}
    SOURCE_FILE_PATH=${1}
    #eo: user input

    #bo: input validation
    if [[ ${DESTINATION_FILE_PATH} == '' ]];
    then
        #assumed the file ends with .pdf, we are removing the last four
        #   characters and adding >>.compressed.pdf<<.
        DESTINATION_FILE_PATH="${SOURCE_FILE_PATH:0:-4}.compressed.pdf"
    fi

    if [[ ! -f "${SOURCE_FILE_PATH}" ]];
    then
        echo ":: Provided source file path >>${SOURCE_FILE_PATH}<< does not exist."

        return 1
    fi

    SOURCE_FILE_PATH_TYPE=$(file -b "${SOURCE_FILE_PATH}");

    if [[ "${SOURCE_FILE_PATH_TYPE:0:12}" != "PDF document" ]];
    then
        echo ":: Provided source file path >>${SOURCE_FILE_PATH}<< is not a pdf document."

        return 2
    fi
    #eo: input validation

    if [[ ! -x $(command -v gs) ]];
    then
        echo ":: gs is not installed. Please install it and run this command again."

        return 3
    fi

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=${PDF_SETTINGS} -dNOPAUSE -dBATCH -dColorImageResolution=${IMAGE_RESOLUTION} -sOutputFile="${DESTINATION_FILE_PATH}" "${SOURCE_FILE_PATH}"
}

