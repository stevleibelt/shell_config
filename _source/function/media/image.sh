#!/bin/bash

#c
####
# Creates thumbnails in the current path
#
# [@paramOne: string] - path to use, default is current working directory
####
# @see https://www.cyberciti.biz/tips/howto-linux-creating-a-image-thumbnails-from-shell-prompt.html
# @author stev leibelt <artodeto@bazzline.net>
# @since 2020-04-24
####
function net_bazzline_create_thumbnails()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 0 ]];
    then
        local CURRENT_WORKING_DIRECTORY=$(pwd)
    else
        local CURRENT_WORKING_DIRECTORY=${1}
    fi

    if [[ ! -d ${CURRENT_WORKING_DIRECTORY} ]];
    then
        echo ":: Invalid argument provided."
        echo "   Path >>${CURRENT_WORKING_DIRECTORY}<< is not a directory."

        return 1
    fi

    find . -name *.jpg -exec convert {} -resize 25% th_{} ;
    ls *.png | xargs -I {} convert -thumbnail 200 {} thumb.{}
    FILES="$@"
    for i in $FILES
    do
    echo "Prcoessing image $i ..."
    /usr/bin/convert -thumbnail 200 $i thumb.$i
    done
}

#i

####
# Converts images in directory with given size
#
# @param int size
# [@param] string name for the directory
#
# @see
#   https://opensource.com/article/21/10/image-processing-bash-script
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-10-02
####
function net_bazzline_image_batch_convert ()
{
    if [[ ${NET_BAZZLINE_OPERATION_SYSTEM_IS_LINUX} -ne 1 ]];
    then
        echo ":: Only supported under linux so far. Sorry."

        return 2
    fi
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    #@todo use parallel if available
    #hook - implement usage and style
    #@todo - implement usage of jpegoptim and optipng
    local SIZE_TO_CONVERT=${1:-1920}

    local RESIZE_DIRECTORY_NAME=${2:-"resized_${SIZE_TO_CONVERT}"}

    if [[ ! -d "${RESIZE_DIRECTORY_NAME}" ]];
    then
        echo ":: Creating directory >>${RESIZE_DIRECTORY_NAME}<<."
        /usr/bin/mkdir "${RESIZE_DIRECTORY_NAME}"
    fi

    #for FILE in *.[jJ][pP][gG];
    for FILE in *.*;
    do
        #check if file is an image
        if file ${FILE} | grep -qE 'image|bitmap'; then
            #check if identify is available
            if [[ -x "$(command -v identify)" ]];
            then
                #check if width or height is greater than the
                local HEIGHT_OF_THE_FILE=$(identify -format %h "${FILE}")
                local WIDTH_OF_THE_FILE=$(identify -format %w "${FILE}")

                if [[ ${HEIGHT_OF_THE_FILE} -gt ${SIZE_TO_CONVERT} || ${WIDTH_OF_THE_FILE} -gt ${SIZE_TO_CONVERT} ]];
                then
                    local CONVERT_THIS_FILE=1
                else
                    local CONVERT_THIS_FILE=0
                fi
            else
                #we can not determine it, so just set the size high enough
                local CONVERT_THIS_FILE=1
            fi


            if [[ ${CONVERT_THIS_FILE} -eq 1 ]];
            then
                convert ${FILE} -verbose -geometry ${SIZE_TO_CONVERT}x${SIZE_TO_CONVERT} -quality 98% -comment "made with linux" "${RESIZE_DIRECTORY_NAME}/${FILE}"
            else
                cp ${FILE} "${RESIZE_DIRECTORY_NAME}/${FILE}"
                #echo "   Just copied file >>${FILE}<<, neither height with >>${HEIGHT_OF_THE_FILE}<< nor width with >>${WIDTH_OF_THE_FILE}<< is greater than >>${SIZE_TO_CONVERT}<<."
            fi
        else
            echo "   Skipping file >>${FILE}<<, it is not an image."
        fi
    done;
}

####
# Converts images in directory with size of 1024
#
# [@param] string name for the directory
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-03-16
####
function net_bazzline_image_batch_convert_1024 ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 1 ]];
    then
        net_bazzline_image_batch_convert 1024 "${1}"
    else
        net_bazzline_image_batch_convert 1024
    fi
}

####
# Converts images in directory with size of 1920
#
# [@param] string name for the directory
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-10-02
####
function net_bazzline_image_batch_convert_1920 ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 1 ]];
    then
        net_bazzline_image_batch_convert 1920 "${1}"
    else
        net_bazzline_image_batch_convert 1920
    fi
}

####
# Converts images in directory with size of 1920
#
# [@param] string name for the directory
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-10-02
####
function net_bazzline_image_batch_convert_4096 ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 1 ]];
    then
        net_bazzline_image_batch_convert 4096 "${1}"
    else
        net_bazzline_image_batch_convert 4096
    fi
}



####
# Converts images in directory with size of 640
#
# [@param] string name for the directory
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2014-08-03
####
function net_bazzline_image_batch_convert_640 ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    if [[ $# -eq 1 ]];
    then
        net_bazzline_image_batch_convert 640 "${1}"
    else
        net_bazzline_image_batch_convert 640
    fi
}

####
# Converts png and jpg files in directory to jpg
#
# [@param] int - image quality, default is 94
# [@param] string - path where the files are located, default is current directory
# [@param] int - geometry, default is keep the geometry
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-02-26
####
function net_bazzline_image_batch_convert_to_jpg ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    #@todo use parallel if available
    local IMAGE_QUALITY=${1:-94}

    if [[ $# -eq 2 ]];
    then
        local DIRECTORY="${2}";
    else
        local DIRECTORY=$(pwd)
    fi

    if [[ $# -eq 3 ]];
    then
        local GEOMETRY="${3}";

        for FILE in *.[wW][eE][bB][pP];
        do
            local NEW_FILE_NAME="${FILE:0:-5}.jpg"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -geometry ${GEOMETRY}x${GEOMETRY} -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;
    else
        for FILE in *.[wW][eE][bB][pP];
        do
            local NEW_FILE_NAME="${FILE:0:-5}.jpg"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;
    fi
}

####
# Convert a file to jpg
#
# @param string - file path
# [@param] int - image quality, default is 80
# [@param] int - geometry, default is keep the geometry
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-04-07
####
function net_bazzline_image_convert_to_jpg ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    local FILE_PATH=${1}
    local IMAGE_QUALITY=${2:-80}
    local GEOMETRY=${3:0}

    if [[ ! -f ${FILE_PATH} ]];
    then
        echo ":: Path >>${FILE_PATH}<< is not a file!"

        return 1
    fi

    local NEW_FILE_NAME="${FILE_PATH}.jpg"

    if [[ ${GEOMETRY} -eq 0 ]];
    then
        convert ${FILE_PATH} -verbose -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
    else
        convert ${FILE_PATH} -verbose -geometry ${GEOMETRY}x${GEOMETRY} -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
    fi
}

####
# Convert a file to webp
#
# @param string - file path
# [@param] int - image quality, default is 80
# [@param] int - geometry, default is keep the geometry
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-04-07
####
function net_bazzline_image_convert_to_webp ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    local FILE_PATH=${1}
    local IMAGE_QUALITY=${2:-80}
    local GEOMETRY=${3:0}

    if [[ ! -f ${FILE_PATH} ]];
    then
        echo ":: Path >>${FILE_PATH}<< is not a file!"

        return 1
    fi

    local NEW_FILE_NAME="${FILE_PATH}.webp"

    if [[ ${GEOMETRY} -eq 0 ]];
    then
        convert ${FILE_PATH} -verbose -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
    else
        convert ${FILE_PATH} -verbose -geometry ${GEOMETRY}x${GEOMETRY} -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
    fi
}

####
# Converts png and jpg files in directory to webp
#
# [@param] int - image quality, default is 80
# [@param] string - path where the files are located, default is current directory
# [@param] int - geometry, default is keep the geometry
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-02-15
####
function net_bazzline_image_batch_convert_to_webp ()
{
    net_bazzline_record_function_usage ${FUNCNAME[0]}

    #@todo use parallel if available
    local IMAGE_QUALITY=${1:-80}

    if [[ $# -eq 2 ]];
    then
        local DIRECTORY="${2}";
    else
        local DIRECTORY=$(pwd)
    fi

    if [[ $# -eq 3 ]];
    then
        local GEOMETRY="${3}";

        for FILE in *.[jJ][pP][gG];
        do
            local NEW_FILE_NAME="${FILE:0:-4}.webp"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -geometry ${GEOMETRY}x${GEOMETRY} -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;

        for FILE in *.[pP][nN][gG];
        do
            local NEW_FILE_NAME="${FILE:0:-4}.webp"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -geometry ${GEOMETRY}x${GEOMETRY} -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;
    else
        for FILE in *.[jJ][pP][gG];
        do
            local NEW_FILE_NAME="${FILE:0:-4}.webp"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;

        for FILE in *.[pP][nN][gG];
        do
            local NEW_FILE_NAME="${FILE:0:-4}.webp"

            if [[ ! -f "${NEW_FILE_NAME}" ]];
            then
                convert ${FILE} -verbose -quality ${IMAGE_QUALITY} -comment "made with linux and love" "${NEW_FILE_NAME}"
            fi
        done;
    fi
}
